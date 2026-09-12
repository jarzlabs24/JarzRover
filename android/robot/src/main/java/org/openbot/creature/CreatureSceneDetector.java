package org.openbot.creature;

/** Lightweight scene-change detector for the centered Creature Lab discovery zone. */
public final class CreatureSceneDetector {

  public enum Event {
    IDLE,
    CALIBRATING,
    BASELINE_LEARNED,
    CLEAR,
    OBJECT_MOVING,
    OBJECT_STABLE
  }

  public static final int COLUMNS = 20;
  public static final int ROWS = 15;
  public static final int FINGERPRINT_SIZE = COLUMNS * ROWS * 3;
  public static final int CALIBRATION_FRAME_COUNT = 10;

  private static final double CHANGED_CELL_THRESHOLD = 20.0;
  private static final double CHANGED_CELL_RATIO = 0.012;
  private static final double STABLE_FRAME_DIFFERENCE = 12.0;
  private static final int REQUIRED_STABLE_FRAMES = 7;

  private int calibrationFramesRemaining;
  private long[] calibrationSums;
  private int[] baseline;
  private int[] previousCandidate;
  private int stableCandidateFrames;
  private boolean watching;
  private double latestChangedCellRatio;

  public synchronized void beginCalibration() {
    calibrationFramesRemaining = CALIBRATION_FRAME_COUNT;
    calibrationSums = new long[FINGERPRINT_SIZE];
    baseline = null;
    previousCandidate = null;
    stableCandidateFrames = 0;
    latestChangedCellRatio = 0;
    watching = false;
  }

  public synchronized boolean hasBaseline() {
    return baseline != null;
  }

  public synchronized void setWatching(boolean shouldWatch) {
    watching = shouldWatch && baseline != null;
    previousCandidate = null;
    stableCandidateFrames = 0;
  }

  public synchronized boolean isWatching() {
    return watching;
  }

  public synchronized double getLatestChangedCellRatio() {
    return latestChangedCellRatio;
  }

  public synchronized Event observe(int[] fingerprint) {
    if (fingerprint == null || fingerprint.length != FINGERPRINT_SIZE) return Event.IDLE;

    if (calibrationFramesRemaining > 0) {
      for (int index = 0; index < fingerprint.length; index++) {
        calibrationSums[index] += fingerprint[index];
      }
      calibrationFramesRemaining--;
      if (calibrationFramesRemaining == 0) {
        baseline = new int[FINGERPRINT_SIZE];
        for (int index = 0; index < baseline.length; index++) {
          baseline[index] = (int) (calibrationSums[index] / CALIBRATION_FRAME_COUNT);
        }
        calibrationSums = null;
        return Event.BASELINE_LEARNED;
      }
      return Event.CALIBRATING;
    }

    if (!watching || baseline == null) return Event.IDLE;
    Difference sceneDifference = compare(fingerprint, baseline);
    latestChangedCellRatio = sceneDifference.changedCellRatio;
    if (sceneDifference.changedCellRatio < CHANGED_CELL_RATIO) {
      previousCandidate = null;
      stableCandidateFrames = 0;
      return Event.CLEAR;
    }

    if (previousCandidate == null) {
      stableCandidateFrames = 0;
    } else {
      Difference motionDifference = compare(fingerprint, previousCandidate);
      stableCandidateFrames =
          motionDifference.meanDifference <= STABLE_FRAME_DIFFERENCE
              ? stableCandidateFrames + 1
              : 0;
    }
    previousCandidate = fingerprint.clone();

    if (stableCandidateFrames >= REQUIRED_STABLE_FRAMES) {
      watching = false;
      previousCandidate = null;
      stableCandidateFrames = 0;
      return Event.OBJECT_STABLE;
    }
    return Event.OBJECT_MOVING;
  }

  private static Difference compare(int[] first, int[] second) {
    long totalDifference = 0;
    int changedCells = 0;
    int cellCount = first.length / 3;
    for (int offset = 0; offset < first.length; offset += 3) {
      int red = Math.abs(first[offset] - second[offset]);
      int green = Math.abs(first[offset + 1] - second[offset + 1]);
      int blue = Math.abs(first[offset + 2] - second[offset + 2]);
      int cellDifference = red + green + blue;
      totalDifference += cellDifference;
      if (cellDifference / 3.0 >= CHANGED_CELL_THRESHOLD) changedCells++;
    }
    return new Difference(
        totalDifference / (double) first.length, changedCells / (double) cellCount);
  }

  private static final class Difference {
    final double meanDifference;
    final double changedCellRatio;

    Difference(double meanDifference, double changedCellRatio) {
      this.meanDifference = meanDifference;
      this.changedCellRatio = changedCellRatio;
    }
  }
}
