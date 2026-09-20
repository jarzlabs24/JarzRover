package org.openbot.env;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import android.view.KeyEvent;
import org.junit.Test;
import org.openbot.utils.Enums;
import org.openbot.vehicle.Control;

public class GameControllerTest {
  @Test
  public void convertDualToControl_test() {
    GameController gameController = new GameController(Enums.DriveMode.DUAL);
    assertEquals(Enums.DriveMode.DUAL, gameController.getDriveMode());
    Control control = gameController.convertDualToControl(0.5f, -0.5f);
    assertEquals(control.getLeft(), -0.5f, 0.0f);
    assertEquals(control.getRight(), 0.5f, 0.0f);
  }

  @Test
  public void convertGameToControl_test() {
    GameController gameController = new GameController(Enums.DriveMode.GAME);
    assertEquals(Enums.DriveMode.GAME, gameController.getDriveMode());
    Control control;
    control = gameController.convertGameToControl(0.0f, 0.5f, 1.0f);
    assertEquals(control.getLeft(), 1.0f, 0.0f);
    assertEquals(control.getRight(), -0.5f, 0.0f);

    control = gameController.convertGameToControl(0.0f, 0.5f, -1.0f);
    assertEquals(control.getLeft(), -0.5f, 0.0f);
    assertEquals(control.getRight(), 1.0f, 0.0f);

    control = gameController.convertGameToControl(0.0f, 0.5f, 0.0f);
    assertEquals(control.getLeft(), 0.5f, 0.0f);
    assertEquals(control.getRight(), 0.5f, 0.0f);
  }

  @Test
  public void convertJoystickToControl_test() {
    GameController gameController = new GameController(Enums.DriveMode.JOYSTICK);
    assertEquals(Enums.DriveMode.JOYSTICK, gameController.getDriveMode());
    Control control;
    control = gameController.convertJoystickToControl(0.5f, -0.5f);
    assertEquals(control.getLeft(), 1.0f, 0.0f);
    assertEquals(control.getRight(), 0.0f, 0.0f);

    control = gameController.convertJoystickToControl(-0.5f, -0.5f);
    assertEquals(control.getLeft(), 0.0f, 0.0f);
    assertEquals(control.getRight(), 1.0f, 0.0f);
  }

  @Test
  public void identifiesOnlyDpadKeysAsDriveButtons() {
    assertTrue(GameController.isDriveButton(KeyEvent.KEYCODE_DPAD_UP));
    assertTrue(GameController.isDriveButton(KeyEvent.KEYCODE_DPAD_RIGHT));
    assertFalse(GameController.isDriveButton(KeyEvent.KEYCODE_BUTTON_A));
  }

  @Test
  public void detectsStopsAndIgnoresTinyControllerJitter() {
    Control stopped = new Control(0.0f, 0.0f);
    Control forward = new Control(0.7f, 0.7f);
    Control tinyChange = new Control(0.71f, 0.69f);

    assertTrue(GameController.isStopped(stopped));
    assertFalse(GameController.isStopped(forward));
    assertFalse(GameController.materiallyDifferent(forward, tinyChange, 0.03f));
    assertTrue(GameController.materiallyDifferent(forward, stopped, 0.03f));
  }
}
