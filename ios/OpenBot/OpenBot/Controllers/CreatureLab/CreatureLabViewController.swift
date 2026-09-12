import AVFoundation
import UIKit

final class CreatureLabViewController: UIViewController, AVCapturePhotoCaptureDelegate,
    AVCaptureVideoDataOutputSampleBufferDelegate, UITextFieldDelegate
{
    private enum Defaults {
        static let serverURL = "creatureLabServerURL"
        static let placeholderURL = "http://192.168.1.100:3000"
    }

    private enum Detection {
        static let columns = 20
        static let rows = 15
        static let frameStride = 6
        static let calibrationFrameCount = 10
        static let changedCellThreshold = 20.0
        static let changedCellRatio = 0.012
        static let stableFrameDifference = 12.0
        static let requiredStableFrames = 7
    }

    private struct GenerateRequest: Encodable {
        let image: String
    }

    private struct GenerateResponse: Decodable {
        struct Profile: Decodable {
            let name: String
            let type: String
            let description: String
            let ability: String
        }

        let image: String
        let profile: Profile
    }

    private struct ErrorResponse: Decodable {
        let error: String?
    }

    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "org.jarzlabs.creature-lab.camera")
    private let analysisQueue = DispatchQueue(label: "org.jarzlabs.creature-lab.analysis")
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var capturedJPEG: Data?

    // Access these scene-analysis values only from analysisQueue.
    private var analyzedFrameCount = 0
    private var calibrationFramesRemaining = 0
    private var calibrationSums: [Int] = []
    private var baselineFingerprint: [UInt8]?
    private var previousCandidateFingerprint: [UInt8]?
    private var stableCandidateFrames = 0
    private var isWatchingForObject = false
    private var isWatchingOnMainThread = false
    private var hasBaselineOnMainThread = false

    private let previewContainer = UIView()
    private let discoveryGuide = UIView()
    private let imageView = UIImageView()
    private let statusLabel = UILabel()
    private let serverField = UITextField()
    private let captureButton = UIButton(type: .system)
    private let retakeButton = UIButton(type: .system)
    private let generateButton = UIButton(type: .system)
    private let calibrateButton = UIButton(type: .system)
    private let watchButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let resultStack = UIStackView()
    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let abilityLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Creature Lab"
        view.backgroundColor = .systemBackground
        configureInterface()
        configureCamera()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = previewContainer.bounds
        updateCameraOrientation()
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self else { return }
            previewLayer?.frame = previewContainer.bounds
        }, completion: { [weak self] _ in
            self?.updateCameraOrientation()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionQueue.async { [weak self] in self?.captureSession.stopRunning() }
    }

    private func configureInterface() {
        let instructions = UILabel()
        instructions.text = "Place one object in the center, then take a photo. The rover will stay stopped."
        instructions.numberOfLines = 0
        instructions.textAlignment = .center
        instructions.font = .preferredFont(forTextStyle: .subheadline)

        serverField.borderStyle = .roundedRect
        serverField.autocapitalizationType = .none
        serverField.autocorrectionType = .no
        serverField.keyboardType = .URL
        serverField.returnKeyType = .done
        serverField.delegate = self
        serverField.placeholder = Defaults.placeholderURL
        serverField.text = UserDefaults.standard.string(forKey: Defaults.serverURL)
        serverField.accessibilityLabel = "Creature Lab server address"

        previewContainer.backgroundColor = .black
        previewContainer.layer.cornerRadius = 16
        previewContainer.clipsToBounds = true
        previewContainer.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.heightAnchor.constraint(equalTo: previewContainer.widthAnchor, multiplier: 0.75).isActive = true

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: previewContainer.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: previewContainer.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: previewContainer.bottomAnchor),
        ])

        discoveryGuide.layer.borderColor = UIColor.systemYellow.cgColor
        discoveryGuide.layer.borderWidth = 3
        discoveryGuide.layer.cornerRadius = 12
        discoveryGuide.isUserInteractionEnabled = false
        discoveryGuide.isHidden = true
        discoveryGuide.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.addSubview(discoveryGuide)

        let guideLabel = UILabel()
        guideLabel.text = "DISCOVERY ZONE"
        guideLabel.textColor = .black
        guideLabel.backgroundColor = .systemYellow
        guideLabel.font = .preferredFont(forTextStyle: .caption1)
        guideLabel.textAlignment = .center
        guideLabel.layer.cornerRadius = 5
        guideLabel.clipsToBounds = true
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        discoveryGuide.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            discoveryGuide.centerXAnchor.constraint(equalTo: previewContainer.centerXAnchor),
            discoveryGuide.centerYAnchor.constraint(equalTo: previewContainer.centerYAnchor),
            discoveryGuide.widthAnchor.constraint(equalTo: previewContainer.widthAnchor, multiplier: 0.62),
            discoveryGuide.heightAnchor.constraint(equalTo: previewContainer.heightAnchor, multiplier: 0.62),
            guideLabel.centerXAnchor.constraint(equalTo: discoveryGuide.centerXAnchor),
            guideLabel.topAnchor.constraint(equalTo: discoveryGuide.topAnchor, constant: 6),
            guideLabel.widthAnchor.constraint(equalToConstant: 130),
            guideLabel.heightAnchor.constraint(equalToConstant: 24),
        ])

        statusLabel.text = "Starting camera…"
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.font = .preferredFont(forTextStyle: .body)

        styleButton(captureButton, title: "Take Photo", symbol: "camera.fill")
        styleButton(retakeButton, title: "Retake", symbol: "arrow.counterclockwise")
        styleButton(generateButton, title: "Create Creature", symbol: "sparkles")
        styleButton(calibrateButton, title: "Learn Empty Arena", symbol: "viewfinder")
        styleButton(watchButton, title: "Watch for Object", symbol: "eye.fill")
        captureButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        retakeButton.addTarget(self, action: #selector(retakePhoto), for: .touchUpInside)
        generateButton.addTarget(self, action: #selector(generateCreature), for: .touchUpInside)
        calibrateButton.addTarget(self, action: #selector(calibrateEmptyArena), for: .touchUpInside)
        watchButton.addTarget(self, action: #selector(toggleObjectWatching), for: .touchUpInside)
        captureButton.isEnabled = false
        calibrateButton.isEnabled = false
        watchButton.isEnabled = false
        retakeButton.isHidden = true
        generateButton.isHidden = true

        let buttonStack = UIStackView(arrangedSubviews: [captureButton, retakeButton, generateButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually

        let discoveryButtonStack = UIStackView(arrangedSubviews: [calibrateButton, watchButton])
        discoveryButtonStack.axis = .horizontal
        discoveryButtonStack.spacing = 10
        discoveryButtonStack.distribution = .fillEqually

        [nameLabel, typeLabel, descriptionLabel, abilityLabel].forEach {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        nameLabel.font = .preferredFont(forTextStyle: .title2)
        nameLabel.adjustsFontForContentSizeCategory = true
        typeLabel.font = .preferredFont(forTextStyle: .headline)
        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        abilityLabel.font = .preferredFont(forTextStyle: .headline)
        resultStack.axis = .vertical
        resultStack.spacing = 6
        resultStack.addArrangedSubview(nameLabel)
        resultStack.addArrangedSubview(typeLabel)
        resultStack.addArrangedSubview(descriptionLabel)
        resultStack.addArrangedSubview(abilityLabel)
        resultStack.isHidden = true

        activityIndicator.hidesWhenStopped = true

        let contentStack = UIStackView(arrangedSubviews: [
            instructions, serverField, previewContainer, statusLabel,
            buttonStack, discoveryButtonStack, activityIndicator, resultStack,
        ])
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 18),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -18),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -36),
        ])
    }

    private func styleButton(_ button: UIButton, title: String, symbol: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.image = UIImage(systemName: symbol)
        configuration.imagePadding = 6
        configuration.cornerStyle = .medium
        button.configuration = configuration
    }

    private func configureCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] allowed in
                DispatchQueue.main.async {
                    allowed ? self?.startCamera() : self?.showCameraPermissionError()
                }
            }
        default:
            showCameraPermissionError()
        }
    }

    private func startCamera() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            captureSession.beginConfiguration()
            captureSession.sessionPreset = .photo

            guard captureSession.inputs.isEmpty,
                  let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: camera),
                  captureSession.canAddInput(input),
                  captureSession.canAddOutput(photoOutput),
                  captureSession.canAddOutput(videoOutput) else {
                captureSession.commitConfiguration()
                DispatchQueue.main.async { self.showStatus("The rear camera could not be started.", isError: true) }
                return
            }

            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
            ]
            videoOutput.setSampleBufferDelegate(self, queue: analysisQueue)
            captureSession.addInput(input)
            captureSession.addOutput(photoOutput)
            captureSession.addOutput(videoOutput)
            captureSession.commitConfiguration()
            captureSession.startRunning()

            DispatchQueue.main.async {
                let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                layer.videoGravity = .resizeAspectFill
                self.previewContainer.layer.insertSublayer(layer, at: 0)
                self.previewLayer = layer
                self.view.setNeedsLayout()
                self.updateCameraOrientation()
                self.captureButton.isEnabled = true
                self.calibrateButton.isEnabled = true
                self.discoveryGuide.isHidden = false
                self.showStatus("Camera ready. Take a photo, or learn the empty arena for discovery mode.")
            }
        }
    }

    private func showCameraPermissionError() {
        showStatus("Camera access is required. Enable it in Settings → Privacy & Security → Camera.", isError: true)
    }

    @objc private func takePhoto() {
        setWatching(false)
        captureButton.isEnabled = false
        showStatus("Taking photo…")
        let orientation = captureVideoOrientation()
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if let connection = photoOutput.connection(with: .video),
               connection.isVideoOrientationSupported {
                connection.videoOrientation = orientation
            }
            photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }

    private func updateCameraOrientation() {
        let orientation = captureVideoOrientation()
        if let connection = previewLayer?.connection, connection.isVideoOrientationSupported {
            connection.videoOrientation = orientation
        }
        sessionQueue.async { [weak self] in
            guard let self,
                  let connection = photoOutput.connection(with: .video),
                  connection.isVideoOrientationSupported else { return }
            connection.videoOrientation = orientation
        }
    }

    private func captureVideoOrientation() -> AVCaptureVideoOrientation {
        guard let interfaceOrientation = view.window?.windowScene?.interfaceOrientation else {
            return .portrait
        }
        switch interfaceOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        default:
            return .portrait
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else {
            captureButton.isEnabled = true
            showStatus("The photo could not be captured. Please try again.", isError: true)
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            capturedJPEG = image.jpegData(compressionQuality: 0.82)
            imageView.image = image
            imageView.isHidden = false
            discoveryGuide.isHidden = true
            captureButton.isHidden = true
            retakeButton.isHidden = false
            generateButton.isHidden = false
            calibrateButton.isEnabled = false
            watchButton.isEnabled = false
            resultStack.isHidden = true
            showStatus("Photo accepted! You can retake it or create the creature.")
        }
    }

    @objc private func retakePhoto() {
        capturedJPEG = nil
        imageView.image = nil
        imageView.isHidden = true
        discoveryGuide.isHidden = false
        resultStack.isHidden = true
        captureButton.isHidden = false
        captureButton.isEnabled = true
        calibrateButton.isEnabled = true
        watchButton.isEnabled = hasBaselineOnMainThread
        retakeButton.isHidden = true
        generateButton.isHidden = true
        showStatus("Camera ready. Center one object in the discovery zone.")
    }

    @objc private func calibrateEmptyArena() {
        if capturedJPEG != nil { retakePhoto() }
        setWatching(false)
        calibrateButton.isEnabled = false
        watchButton.isEnabled = false
        hasBaselineOnMainThread = false
        showStatus("Learning the empty arena… Keep the yellow zone clear and hold the phone still.")

        analysisQueue.async { [weak self] in
            guard let self else { return }
            calibrationSums = []
            calibrationFramesRemaining = Detection.calibrationFrameCount
            baselineFingerprint = nil
            previousCandidateFingerprint = nil
            stableCandidateFrames = 0
        }
    }

    @objc private func toggleObjectWatching() {
        setWatching(!isWatchingOnMainThread)
    }

    private func setWatching(_ watching: Bool) {
        isWatchingOnMainThread = watching
        calibrateButton.isEnabled = !watching && capturedJPEG == nil
        watchButton.isEnabled = capturedJPEG == nil && hasBaselineOnMainThread
        var configuration = watchButton.configuration
        configuration?.title = watching ? "Stop Watching" : "Watch for Object"
        configuration?.image = UIImage(systemName: watching ? "stop.fill" : "eye.fill")
        watchButton.configuration = configuration

        if watching {
            showStatus("Watching… Place one object inside the yellow zone, then move your hands away.")
        }

        analysisQueue.async { [weak self] in
            guard let self else { return }
            isWatchingForObject = watching && baselineFingerprint != nil
            previousCandidateFingerprint = nil
            stableCandidateFrames = 0
        }
    }

    private func showObjectDiscoveredPrompt() {
        setWatching(false)
        let alert = UIAlertController(
            title: "Object discovered!",
            message: "The new object is holding still. Would you like to take its picture?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Not Yet", style: .cancel) { [weak self] _ in
            self?.showStatus("Discovery paused. Remove the object or tap Watch for Object to continue.")
        })
        alert.addAction(UIAlertAction(title: "Take Picture", style: .default) { [weak self] _ in
            self?.takePhoto()
        })
        present(alert, animated: true)
    }

    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        analyzedFrameCount += 1
        guard analyzedFrameCount % Detection.frameStride == 0,
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let fingerprint = makeFingerprint(from: pixelBuffer) else { return }

        if calibrationFramesRemaining > 0 {
            if calibrationSums.isEmpty {
                calibrationSums = Array(repeating: 0, count: fingerprint.count)
            }
            for index in fingerprint.indices {
                calibrationSums[index] += Int(fingerprint[index])
            }
            calibrationFramesRemaining -= 1

            if calibrationFramesRemaining == 0 {
                baselineFingerprint = calibrationSums.map {
                    UInt8($0 / Detection.calibrationFrameCount)
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    hasBaselineOnMainThread = true
                    calibrateButton.isEnabled = true
                    watchButton.isEnabled = true
                    showStatus("Empty arena learned. Tap Watch for Object, then place an object in the yellow zone.")
                }
            }
            return
        }

        guard isWatchingForObject, let baselineFingerprint else { return }
        let sceneDifference = compare(fingerprint, with: baselineFingerprint)
        if analyzedFrameCount % (Detection.frameStride * 5) == 0 {
            let changedPercent = Int((sceneDifference.changedCellRatio * 100).rounded())
            DispatchQueue.main.async { [weak self] in
                guard let self, isWatchingOnMainThread else { return }
                showStatus("Watching… Scene change: \(changedPercent)%. Place an object in the yellow zone.")
            }
        }
        guard sceneDifference.changedCellRatio >= Detection.changedCellRatio else {
            previousCandidateFingerprint = nil
            stableCandidateFrames = 0
            return
        }

        if let previousCandidateFingerprint {
            let motionDifference = compare(fingerprint, with: previousCandidateFingerprint)
            stableCandidateFrames = motionDifference.meanDifference <= Detection.stableFrameDifference
                ? stableCandidateFrames + 1 : 0
        } else {
            stableCandidateFrames = 0
        }
        previousCandidateFingerprint = fingerprint

        if stableCandidateFrames >= Detection.requiredStableFrames {
            isWatchingForObject = false
            stableCandidateFrames = 0
            previousCandidateFingerprint = nil
            DispatchQueue.main.async { [weak self] in self?.showObjectDiscoveredPrompt() }
        }
    }

    private func makeFingerprint(from pixelBuffer: CVPixelBuffer) -> [UInt8]? {
        guard CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32BGRA else { return nil }
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else { return nil }

        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let regionX = width / 5
        let regionY = height / 5
        let regionWidth = width * 3 / 5
        let regionHeight = height * 3 / 5
        let bytes = baseAddress.assumingMemoryBound(to: UInt8.self)
        var fingerprint: [UInt8] = []
        fingerprint.reserveCapacity(Detection.columns * Detection.rows * 3)

        for row in 0..<Detection.rows {
            let y = regionY + ((row * 2 + 1) * regionHeight) / (Detection.rows * 2)
            for column in 0..<Detection.columns {
                let x = regionX + ((column * 2 + 1) * regionWidth) / (Detection.columns * 2)
                let offset = y * bytesPerRow + x * 4
                fingerprint.append(bytes[offset])
                fingerprint.append(bytes[offset + 1])
                fingerprint.append(bytes[offset + 2])
            }
        }
        return fingerprint
    }

    private func compare(_ first: [UInt8], with second: [UInt8]) ->
        (meanDifference: Double, changedCellRatio: Double)
    {
        guard first.count == second.count, first.count.isMultiple(of: 3), !first.isEmpty else {
            return (.infinity, 1)
        }
        var totalDifference = 0
        var changedCells = 0
        let cellCount = first.count / 3

        for offset in stride(from: 0, to: first.count, by: 3) {
            let blue = abs(Int(first[offset]) - Int(second[offset]))
            let green = abs(Int(first[offset + 1]) - Int(second[offset + 1]))
            let red = abs(Int(first[offset + 2]) - Int(second[offset + 2]))
            let cellDifference = Double(blue + green + red) / 3
            totalDifference += blue + green + red
            if cellDifference >= Detection.changedCellThreshold { changedCells += 1 }
        }

        return (
            Double(totalDifference) / Double(first.count),
            Double(changedCells) / Double(cellCount)
        )
    }

    @objc private func generateCreature() {
        view.endEditing(true)
        guard let jpeg = capturedJPEG else { return }
        guard let endpoint = generationEndpoint() else {
            showStatus("Enter the Creature Lab server address, for example http://192.168.1.25:3000", isError: true)
            return
        }

        let baseURL = endpoint.deletingLastPathComponent().deletingLastPathComponent()
        UserDefaults.standard.set(baseURL.absoluteString, forKey: Defaults.serverURL)

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 75

        do {
            request.httpBody = try JSONEncoder().encode(
                GenerateRequest(image: "data:image/jpeg;base64,\(jpeg.base64EncodedString())")
            )
        } catch {
            showStatus("The photo could not be prepared.", isError: true)
            return
        }

        setGenerating(true)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.setGenerating(false)

                if let error {
                    self.showStatus("Could not reach Creature Lab: \(error.localizedDescription)", isError: true)
                    return
                }
                guard let data else {
                    self.showStatus("Creature Lab returned no data.", isError: true)
                    return
                }
                guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                    let message = (try? JSONDecoder().decode(ErrorResponse.self, from: data).error)
                        ?? "Creature generation failed."
                    self.showStatus(message, isError: true)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(GenerateResponse.self, from: data)
                    try self.display(result)
                } catch {
                    self.showStatus("The Creature Lab response could not be read.", isError: true)
                }
            }
        }.resume()
    }

    private func generationEndpoint() -> URL? {
        let rawValue = serverField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !rawValue.isEmpty, var components = URLComponents(string: rawValue) else { return nil }
        components.path = "/api/generate"
        components.query = nil
        components.fragment = nil
        return components.url
    }

    private func display(_ result: GenerateResponse) throws {
        guard let comma = result.image.firstIndex(of: ","),
              let imageData = Data(base64Encoded: String(result.image[result.image.index(after: comma)...])),
              let image = UIImage(data: imageData) else {
            throw NSError(domain: "CreatureLab", code: 1)
        }
        imageView.image = image
        nameLabel.text = result.profile.name
        typeLabel.text = result.profile.type
        descriptionLabel.text = result.profile.description
        abilityLabel.text = "Special ability: \(result.profile.ability)"
        resultStack.isHidden = false
        generateButton.isHidden = true
        showStatus("Creature discovered!")
    }

    private func setGenerating(_ generating: Bool) {
        generateButton.isEnabled = !generating
        retakeButton.isEnabled = !generating
        serverField.isEnabled = !generating
        generating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        if generating { showStatus("Creating your creature… This can take up to a minute.") }
    }

    private func showStatus(_ message: String, isError: Bool = false) {
        statusLabel.text = message
        statusLabel.textColor = isError ? .systemRed : .label
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
