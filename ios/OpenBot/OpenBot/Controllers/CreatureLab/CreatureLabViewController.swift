import AVFoundation
import UIKit

final class CreatureLabViewController: UIViewController, AVCapturePhotoCaptureDelegate, UITextFieldDelegate {
    private enum Defaults {
        static let serverURL = "creatureLabServerURL"
        static let placeholderURL = "http://192.168.1.100:3000"
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
    private let sessionQueue = DispatchQueue(label: "org.jarzlabs.creature-lab.camera")
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var capturedJPEG: Data?

    private let previewContainer = UIView()
    private let imageView = UIImageView()
    private let statusLabel = UILabel()
    private let serverField = UITextField()
    private let captureButton = UIButton(type: .system)
    private let retakeButton = UIButton(type: .system)
    private let generateButton = UIButton(type: .system)
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

        statusLabel.text = "Starting camera…"
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.font = .preferredFont(forTextStyle: .body)

        styleButton(captureButton, title: "Take Photo", symbol: "camera.fill")
        styleButton(retakeButton, title: "Retake", symbol: "arrow.counterclockwise")
        styleButton(generateButton, title: "Create Creature", symbol: "sparkles")
        captureButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        retakeButton.addTarget(self, action: #selector(retakePhoto), for: .touchUpInside)
        generateButton.addTarget(self, action: #selector(generateCreature), for: .touchUpInside)
        captureButton.isEnabled = false
        retakeButton.isHidden = true
        generateButton.isHidden = true

        let buttonStack = UIStackView(arrangedSubviews: [captureButton, retakeButton, generateButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually

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
            buttonStack, activityIndicator, resultStack,
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
                  captureSession.canAddOutput(photoOutput) else {
                captureSession.commitConfiguration()
                DispatchQueue.main.async { self.showStatus("The rear camera could not be started.", isError: true) }
                return
            }

            captureSession.addInput(input)
            captureSession.addOutput(photoOutput)
            captureSession.commitConfiguration()
            captureSession.startRunning()

            DispatchQueue.main.async {
                let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                layer.videoGravity = .resizeAspectFill
                self.previewContainer.layer.insertSublayer(layer, at: 0)
                self.previewLayer = layer
                self.view.setNeedsLayout()
                self.captureButton.isEnabled = true
                self.showStatus("Camera ready. Center one object in the frame.")
            }
        }
    }

    private func showCameraPermissionError() {
        showStatus("Camera access is required. Enable it in Settings → Privacy & Security → Camera.", isError: true)
    }

    @objc private func takePhoto() {
        captureButton.isEnabled = false
        showStatus("Taking photo…")
        photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else {
            captureButton.isEnabled = true
            showStatus("The photo could not be captured. Please try again.", isError: true)
            return
        }

        capturedJPEG = image.jpegData(compressionQuality: 0.82)
        imageView.image = image
        imageView.isHidden = false
        captureButton.isHidden = true
        retakeButton.isHidden = false
        generateButton.isHidden = false
        resultStack.isHidden = true
        showStatus("Photo accepted! You can retake it or create the creature.")
    }

    @objc private func retakePhoto() {
        capturedJPEG = nil
        imageView.image = nil
        imageView.isHidden = true
        resultStack.isHidden = true
        captureButton.isHidden = false
        captureButton.isEnabled = true
        retakeButton.isHidden = true
        generateButton.isHidden = true
        showStatus("Camera ready. Center one object in the frame.")
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
