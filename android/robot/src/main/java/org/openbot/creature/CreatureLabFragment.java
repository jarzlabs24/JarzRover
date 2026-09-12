package org.openbot.creature;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ImageProxy;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.json.JSONObject;
import org.openbot.R;
import org.openbot.common.CameraFragment;
import org.openbot.databinding.FragmentCreatureLabBinding;

/** Manual Android milestone for capturing an object and generating its Creature Lab result. */
public class CreatureLabFragment extends CameraFragment {

  private static final String PREFS_NAME = "creature_lab";
  private static final String SERVER_ADDRESS_KEY = "server_address";
  private static final int OUTPUT_SIZE = 1024;
  private static final int DETECTION_FRAME_STRIDE = 6;
  private static final MediaType JSON_MEDIA_TYPE =
      MediaType.get("application/json; charset=utf-8");

  private final ExecutorService networkExecutor = Executors.newSingleThreadExecutor();
  private final Object captureLock = new Object();
  private final CreatureSceneDetector sceneDetector = new CreatureSceneDetector();
  private final OkHttpClient httpClient =
      new OkHttpClient.Builder()
          .connectTimeout(15, TimeUnit.SECONDS)
          .writeTimeout(30, TimeUnit.SECONDS)
          .readTimeout(85, TimeUnit.SECONDS)
          .callTimeout(95, TimeUnit.SECONDS)
          .build();

  private FragmentCreatureLabBinding binding;
  private volatile boolean captureRequested;
  private int analyzedFrameCount;
  private boolean watchingOnUi;
  private Bitmap capturedBitmap;
  private Bitmap generatedBitmap;

  @Override
  public View onCreateView(
      @NonNull LayoutInflater inflater,
      @Nullable ViewGroup container,
      @Nullable Bundle savedInstanceState) {
    binding = FragmentCreatureLabBinding.inflate(inflater, container, false);
    return inflateFragment(binding, inflater, container);
  }

  @Override
  public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);

    // The rear camera faces the object when the phone is mounted on the rover.
    if (lensFacing == CameraSelector.LENS_FACING_FRONT) toggleCamera();

    String savedServer =
        requireContext().getSharedPreferences(PREFS_NAME, 0).getString(SERVER_ADDRESS_KEY, "");
    binding.serverAddress.setText(savedServer);
    binding.takePhotoButton.setOnClickListener(ignored -> requestPhoto());
    binding.retakeButton.setOnClickListener(ignored -> resetForRetake());
    binding.createButton.setOnClickListener(ignored -> createCreature());
    binding.learnAreaButton.setOnClickListener(ignored -> learnEmptyArea());
    binding.watchButton.setOnClickListener(ignored -> setWatching(!watchingOnUi));
  }

  private void requestPhoto() {
    if (captureRequested) return;
    setWatching(false);
    binding.discoveryGuide.setVisibility(View.GONE);
    binding.discoveryPanel.setVisibility(View.GONE);
    binding.takePhotoButton.setEnabled(false);
    binding.statusText.setText(R.string.creature_lab_capturing);
    captureRequested = true;
  }

  @Override
  protected void processFrame(Bitmap image, ImageProxy imageProxy) {
    boolean captured = false;
    if (captureRequested) {
      synchronized (captureLock) {
        if (captureRequested) {
          captureRequested = false;
          Bitmap photo = makeSquarePhoto(image, getRotationDegrees());
          replaceCapturedBitmap(photo);
          captured = true;
        }
      }
    }

    if (captured) {
      postToUi(
          () -> {
            binding.photoPreview.setImageBitmap(capturedBitmap);
            binding.photoPreview.setVisibility(View.VISIBLE);
            binding.takePhotoButton.setVisibility(View.GONE);
            binding.retakeButton.setVisibility(View.VISIBLE);
            binding.createButton.setVisibility(View.VISIBLE);
            binding.takePhotoButton.setEnabled(true);
            binding.statusText.setText(R.string.creature_lab_photo_ready);
            clearProfile();
          });
      return;
    }

    analyzedFrameCount++;
    if (analyzedFrameCount % DETECTION_FRAME_STRIDE != 0) return;
    boolean landscape =
        getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE;
    CreatureSceneDetector.Event event = sceneDetector.observe(makeFingerprint(image, landscape));
    if (event == CreatureSceneDetector.Event.BASELINE_LEARNED) {
      postToUi(this::onBaselineLearned);
    } else if (event == CreatureSceneDetector.Event.OBJECT_STABLE) {
      postToUi(this::showObjectDiscoveredPrompt);
    } else if (sceneDetector.isWatching()
        && analyzedFrameCount % (DETECTION_FRAME_STRIDE * 5) == 0) {
      int changedPercent = (int) Math.round(sceneDetector.getLatestChangedCellRatio() * 100);
      postToUi(
          () -> {
            if (watchingOnUi) {
              binding.statusText.setText(
                  getString(R.string.creature_lab_watching_change, changedPercent));
            }
          });
    }
  }

  private void learnEmptyArea() {
    if (capturedBitmap != null || generatedBitmap != null) resetForRetake();
    setWatching(false);
    sceneDetector.beginCalibration();
    binding.learnAreaButton.setEnabled(false);
    binding.watchButton.setEnabled(false);
    binding.discoveryGuide.setVisibility(View.VISIBLE);
    binding.statusText.setText(R.string.creature_lab_learning);
  }

  private void onBaselineLearned() {
    binding.learnAreaButton.setEnabled(true);
    binding.watchButton.setEnabled(true);
    binding.statusText.setText(R.string.creature_lab_learned);
  }

  private void setWatching(boolean watching) {
    sceneDetector.setWatching(watching);
    watchingOnUi = sceneDetector.isWatching();
    binding.learnAreaButton.setEnabled(!watchingOnUi && capturedBitmap == null);
    binding.watchButton.setEnabled(capturedBitmap == null && sceneDetector.hasBaseline());
    binding.watchButton.setText(
        watchingOnUi ? R.string.creature_lab_stop_watching : R.string.creature_lab_watch);
    if (watchingOnUi) binding.statusText.setText(R.string.creature_lab_watching);
  }

  private void showObjectDiscoveredPrompt() {
    if (binding == null || !isAdded()) return;
    setWatching(false);
    new AlertDialog.Builder(requireContext())
        .setTitle(R.string.creature_lab_object_found_title)
        .setMessage(R.string.creature_lab_object_found_message)
        .setNegativeButton(
            R.string.creature_lab_not_yet,
            (dialog, which) ->
                binding.statusText.setText(R.string.creature_lab_discovery_paused))
        .setPositiveButton(
            R.string.creature_lab_take_photo, (dialog, which) -> requestPhoto())
        .show();
  }

  private void postToUi(Runnable action) {
    if (!isAdded()) return;
    requireActivity()
        .runOnUiThread(
            () -> {
              if (binding != null) action.run();
            });
  }

  private static int[] makeFingerprint(Bitmap image, boolean landscape) {
    int[] fingerprint = new int[CreatureSceneDetector.FINGERPRINT_SIZE];
    int regionX = image.getWidth() / 5;
    int regionWidth = image.getWidth() * 3 / 5;
    int regionY = landscape ? image.getHeight() * 11 / 20 : image.getHeight() / 5;
    int regionHeight = landscape ? image.getHeight() * 2 / 5 : image.getHeight() * 3 / 5;
    int offset = 0;
    for (int row = 0; row < CreatureSceneDetector.ROWS; row++) {
      int y =
          regionY
              + ((row * 2 + 1) * regionHeight) / (CreatureSceneDetector.ROWS * 2);
      for (int column = 0; column < CreatureSceneDetector.COLUMNS; column++) {
        int x =
            regionX
                + ((column * 2 + 1) * regionWidth) / (CreatureSceneDetector.COLUMNS * 2);
        int pixel = image.getPixel(x, y);
        fingerprint[offset++] = Color.red(pixel);
        fingerprint[offset++] = Color.green(pixel);
        fingerprint[offset++] = Color.blue(pixel);
      }
    }
    return fingerprint;
  }

  @Override
  protected void processControllerKeyData(String command) {
    // Creature Lab's first Android milestone is stationary and does not consume drive commands.
  }

  @Override
  protected void processUSBData(String data) {
    // USB telemetry is intentionally left untouched for the later patrol integration milestone.
  }

  private static Bitmap makeSquarePhoto(Bitmap source, int rotationDegrees) {
    Matrix rotation = new Matrix();
    rotation.postRotate(rotationDegrees);
    Bitmap oriented =
        Bitmap.createBitmap(
            source, 0, 0, source.getWidth(), source.getHeight(), rotation, true);
    int cropSize = Math.min(oriented.getWidth(), oriented.getHeight());
    int cropX = (oriented.getWidth() - cropSize) / 2;
    int cropY = (oriented.getHeight() - cropSize) / 2;
    Bitmap square = Bitmap.createBitmap(oriented, cropX, cropY, cropSize, cropSize);
    Bitmap scaled = Bitmap.createScaledBitmap(square, OUTPUT_SIZE, OUTPUT_SIZE, true);

    if (square != oriented) square.recycle();
    if (oriented != source && oriented != scaled) oriented.recycle();
    return scaled;
  }

  private void createCreature() {
    if (capturedBitmap == null) {
      binding.statusText.setText(R.string.creature_lab_photo_required);
      return;
    }

    String serverUrl = normalizeServerUrl(binding.serverAddress.getText().toString());
    if (serverUrl.isEmpty()) {
      binding.serverAddress.setError(getString(R.string.creature_lab_server_required));
      return;
    }

    binding.serverAddress.setError(null);
    requireContext()
        .getSharedPreferences(PREFS_NAME, 0)
        .edit()
        .putString(SERVER_ADDRESS_KEY, serverUrl)
        .apply();
    binding.serverAddress.setText(serverUrl);
    setGenerating(true);

    Bitmap photo = capturedBitmap;
    networkExecutor.execute(() -> generateCreature(serverUrl, photo));
  }

  private void generateCreature(String serverUrl, Bitmap photo) {
    try {
      ByteArrayOutputStream stream = new ByteArrayOutputStream();
      if (!photo.compress(Bitmap.CompressFormat.JPEG, 88, stream)) {
        throw new IOException("The photo could not be prepared.");
      }

      String encodedPhoto = Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP);
      JSONObject requestJson = new JSONObject();
      requestJson.put("image", "data:image/jpeg;base64," + encodedPhoto);

      Request request =
          new Request.Builder()
              .url(serverUrl + "/api/generate")
              .post(RequestBody.create(requestJson.toString(), JSON_MEDIA_TYPE))
              .build();

      try (Response response = httpClient.newCall(request).execute()) {
        String responseText = response.body() == null ? "" : response.body().string();
        JSONObject result = responseText.isEmpty() ? new JSONObject() : new JSONObject(responseText);
        if (!response.isSuccessful()) {
          throw new IOException(result.optString("error", "Server returned " + response.code()));
        }

        JSONObject profile = result.optJSONObject("profile");
        String imageData = result.optString("image", "");
        if (profile == null || !imageData.startsWith("data:image/")) {
          throw new IOException("The server response did not include a creature.");
        }

        int comma = imageData.indexOf(',');
        byte[] imageBytes = Base64.decode(imageData.substring(comma + 1), Base64.DEFAULT);
        Bitmap creature = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.length);
        if (creature == null) throw new IOException("The creature image could not be opened.");

        showCreature(
            creature,
            profile.optString("name", "New Creature"),
            profile.optString("type", "Mystery"),
            profile.optString("description", ""),
            profile.optString("ability", ""));
      }
    } catch (Exception error) {
      showGenerationError(error.getMessage() == null ? "Unknown error" : error.getMessage());
    }
  }

  private void showCreature(
      Bitmap creature, String name, String type, String description, String ability) {
    if (!isAdded()) {
      creature.recycle();
      return;
    }
    requireActivity()
        .runOnUiThread(
            () -> {
              if (binding == null) {
                creature.recycle();
                return;
              }
              replaceGeneratedBitmap(creature);
              binding.photoPreview.setImageBitmap(generatedBitmap);
              binding.creatureName.setText(name);
              binding.creatureType.setText(getString(R.string.creature_lab_type, type));
              binding.creatureDescription.setText(description);
              binding.creatureAbility.setText(getString(R.string.creature_lab_ability, ability));
              binding.serverPanel.setVisibility(View.GONE);
              binding.discoveryGuide.setVisibility(View.GONE);
              binding.discoveryPanel.setVisibility(View.GONE);
              binding.resultPanel.setVisibility(View.VISIBLE);
              binding.statusText.setText(R.string.creature_lab_result_ready);
              binding.retakeButton.setText(R.string.creature_lab_try_again);
              binding.createButton.setVisibility(View.GONE);
              setGenerating(false);
            });
  }

  private void showGenerationError(String message) {
    if (!isAdded()) return;
    requireActivity()
        .runOnUiThread(
            () -> {
              if (binding == null) return;
              setGenerating(false);
              binding.statusText.setText(getString(R.string.creature_lab_generation_failed, message));
            });
  }

  private void setGenerating(boolean generating) {
    binding.progress.setVisibility(generating ? View.VISIBLE : View.GONE);
    binding.retakeButton.setEnabled(!generating);
    binding.createButton.setEnabled(!generating);
    binding.serverAddress.setEnabled(!generating);
    if (generating) binding.statusText.setText(R.string.creature_lab_generating);
  }

  private void resetForRetake() {
    binding.photoPreview.setImageDrawable(null);
    binding.photoPreview.setVisibility(View.GONE);
    binding.serverPanel.setVisibility(View.VISIBLE);
    binding.discoveryGuide.setVisibility(View.VISIBLE);
    binding.discoveryPanel.setVisibility(View.VISIBLE);
    binding.takePhotoButton.setVisibility(View.VISIBLE);
    binding.retakeButton.setVisibility(View.GONE);
    binding.retakeButton.setText(R.string.creature_lab_retake);
    binding.createButton.setVisibility(View.GONE);
    binding.statusText.setText(R.string.creature_lab_camera_ready);
    binding.learnAreaButton.setEnabled(true);
    binding.watchButton.setEnabled(sceneDetector.hasBaseline());
    binding.watchButton.setText(R.string.creature_lab_watch);
    watchingOnUi = false;
    sceneDetector.setWatching(false);
    clearProfile();
    replaceCapturedBitmap(null);
    replaceGeneratedBitmap(null);
  }

  private void clearProfile() {
    binding.resultPanel.setVisibility(View.GONE);
    binding.creatureName.setText("");
    binding.creatureType.setText("");
    binding.creatureDescription.setText("");
    binding.creatureAbility.setText("");
  }

  static String normalizeServerUrl(String rawAddress) {
    String normalized = rawAddress == null ? "" : rawAddress.trim();
    while (normalized.endsWith("/")) {
      normalized = normalized.substring(0, normalized.length() - 1);
    }
    if (normalized.isEmpty()) return "";
    if (!normalized.startsWith("http://") && !normalized.startsWith("https://")) {
      normalized = "http://" + normalized;
    }
    return normalized;
  }

  private void replaceCapturedBitmap(@Nullable Bitmap replacement) {
    if (capturedBitmap != null && capturedBitmap != replacement && !capturedBitmap.isRecycled()) {
      capturedBitmap.recycle();
    }
    capturedBitmap = replacement;
  }

  private void replaceGeneratedBitmap(@Nullable Bitmap replacement) {
    if (generatedBitmap != null && generatedBitmap != replacement && !generatedBitmap.isRecycled()) {
      generatedBitmap.recycle();
    }
    generatedBitmap = replacement;
  }

  @Override
  public void onDestroyView() {
    captureRequested = false;
    binding = null;
    super.onDestroyView();
  }

  @Override
  public void onDestroy() {
    networkExecutor.shutdownNow();
    replaceCapturedBitmap(null);
    replaceGeneratedBitmap(null);
    super.onDestroy();
  }
}
