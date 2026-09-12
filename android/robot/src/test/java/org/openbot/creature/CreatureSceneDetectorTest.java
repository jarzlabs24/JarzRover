package org.openbot.creature;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.openbot.creature.CreatureSceneDetector.Event;

public class CreatureSceneDetectorTest {

  @Test
  public void learnsBaselineThenFindsStableObject() {
    CreatureSceneDetector detector = new CreatureSceneDetector();
    int[] empty = new int[CreatureSceneDetector.FINGERPRINT_SIZE];
    detector.beginCalibration();

    for (int frame = 0; frame < CreatureSceneDetector.CALIBRATION_FRAME_COUNT - 1; frame++) {
      assertEquals(Event.CALIBRATING, detector.observe(empty));
    }
    assertEquals(Event.BASELINE_LEARNED, detector.observe(empty));
    assertTrue(detector.hasBaseline());

    detector.setWatching(true);
    int[] object = empty.clone();
    for (int cell = 0; cell < 8; cell++) {
      int offset = cell * 3;
      object[offset] = 80;
      object[offset + 1] = 80;
      object[offset + 2] = 80;
    }

    assertEquals(Event.OBJECT_MOVING, detector.observe(object));
    Event event = Event.IDLE;
    for (int frame = 0; frame < 7; frame++) event = detector.observe(object);
    assertEquals(Event.OBJECT_STABLE, event);
    assertFalse(detector.isWatching());
  }

  @Test
  public void ignoresVerySmallSceneChanges() {
    CreatureSceneDetector detector = new CreatureSceneDetector();
    int[] empty = new int[CreatureSceneDetector.FINGERPRINT_SIZE];
    detector.beginCalibration();
    for (int frame = 0; frame < CreatureSceneDetector.CALIBRATION_FRAME_COUNT; frame++) {
      detector.observe(empty);
    }
    detector.setWatching(true);

    int[] tinyChange = empty.clone();
    for (int cell = 0; cell < 3; cell++) {
      int offset = cell * 3;
      tinyChange[offset] = 80;
      tinyChange[offset + 1] = 80;
      tinyChange[offset + 2] = 80;
    }

    assertEquals(Event.CLEAR, detector.observe(tinyChange));
    assertTrue(detector.isWatching());
  }
}
