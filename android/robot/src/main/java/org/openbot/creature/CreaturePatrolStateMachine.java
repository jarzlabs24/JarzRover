package org.openbot.creature;

/**
 * Coordinates the high-level Creature Patrol flow without directly controlling hardware.
 *
 * <p>Motor code must consult {@link #allowsMotion()} before sending a non-zero command. This keeps
 * capture, generation, and visitor interaction states stationary by construction.
 */
public final class CreaturePatrolStateMachine {

  public enum State {
    IDLE,
    PATROLLING,
    OBJECT_CANDIDATE,
    WAITING_FOR_CONFIRMATION,
    CAPTURING,
    GENERATING,
    SHOWING_RESULT,
    WAITING_FOR_REMOVAL,
    ERROR
  }

  private final int stableObservationCount;
  private State state = State.IDLE;
  private int consecutiveObjectObservations;
  private int consecutiveClearObservations;

  public CreaturePatrolStateMachine(int stableObservationCount) {
    if (stableObservationCount < 1) {
      throw new IllegalArgumentException("stableObservationCount must be at least 1");
    }
    this.stableObservationCount = stableObservationCount;
  }

  public State getState() {
    return state;
  }

  public boolean allowsMotion() {
    return state == State.PATROLLING;
  }

  public void startPatrol() {
    if (state == State.IDLE) {
      resetObservations();
      state = State.PATROLLING;
    }
  }

  public void stop() {
    resetObservations();
    state = State.IDLE;
  }

  /** Supplies one object-zone observation from the camera pipeline. */
  public void observeObjectZone(boolean objectPresent) {
    if (state == State.PATROLLING) {
      if (objectPresent) {
        consecutiveObjectObservations = 1;
        state =
            stableObservationCount == 1
                ? State.WAITING_FOR_CONFIRMATION
                : State.OBJECT_CANDIDATE;
      }
      return;
    }

    if (state == State.OBJECT_CANDIDATE) {
      if (!objectPresent) {
        consecutiveObjectObservations = 0;
        state = State.PATROLLING;
        return;
      }

      consecutiveObjectObservations++;
      if (consecutiveObjectObservations >= stableObservationCount) {
        state = State.WAITING_FOR_CONFIRMATION;
      }
      return;
    }

    if (state == State.WAITING_FOR_REMOVAL) {
      if (objectPresent) {
        consecutiveClearObservations = 0;
        return;
      }

      consecutiveClearObservations++;
      if (consecutiveClearObservations >= stableObservationCount) {
        resetObservations();
        state = State.PATROLLING;
      }
    }
  }

  public boolean confirmCapture() {
    if (state != State.WAITING_FOR_CONFIRMATION) return false;
    state = State.CAPTURING;
    return true;
  }

  public void cancelCapture() {
    if (state == State.WAITING_FOR_CONFIRMATION) {
      consecutiveClearObservations = 0;
      state = State.WAITING_FOR_REMOVAL;
    }
  }

  public boolean captureCompleted() {
    if (state != State.CAPTURING) return false;
    state = State.GENERATING;
    return true;
  }

  public boolean generationCompleted() {
    if (state != State.GENERATING) return false;
    state = State.SHOWING_RESULT;
    return true;
  }

  public void generationFailed() {
    if (state == State.GENERATING) state = State.ERROR;
  }

  public boolean dismissResult() {
    if (state != State.SHOWING_RESULT && state != State.ERROR) return false;
    consecutiveClearObservations = 0;
    state = State.WAITING_FOR_REMOVAL;
    return true;
  }

  private void resetObservations() {
    consecutiveObjectObservations = 0;
    consecutiveClearObservations = 0;
  }
}
