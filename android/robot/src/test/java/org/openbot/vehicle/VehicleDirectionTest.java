package org.openbot.vehicle;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class VehicleDirectionTest {

  @Test
  public void reversesBothHardwareMotorCommands() {
    assertEquals(-192, Vehicle.applyMotorDirection(192, true));
    assertEquals(192, Vehicle.applyMotorDirection(-192, true));
    assertEquals(0, Vehicle.applyMotorDirection(0, true));
  }

  @Test
  public void preservesCommandsWhenReversalIsDisabled() {
    assertEquals(192, Vehicle.applyMotorDirection(192, false));
    assertEquals(-192, Vehicle.applyMotorDirection(-192, false));
  }
}
