package org.openbot.creature;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.openbot.creature.CreaturePatrolStateMachine.State;

public class CreaturePatrolStateMachineTest {

  @Test
  public void motionIsAllowedOnlyWhilePatrolling() {
    CreaturePatrolStateMachine machine = new CreaturePatrolStateMachine(2);

    assertFalse(machine.allowsMotion());
    machine.startPatrol();
    assertTrue(machine.allowsMotion());

    machine.observeObjectZone(true);
    assertEquals(State.OBJECT_CANDIDATE, machine.getState());
    assertFalse(machine.allowsMotion());

    machine.observeObjectZone(true);
    assertEquals(State.WAITING_FOR_CONFIRMATION, machine.getState());
    assertTrue(machine.confirmCapture());
    assertFalse(machine.allowsMotion());

    assertTrue(machine.captureCompleted());
    assertEquals(State.GENERATING, machine.getState());
    assertFalse(machine.allowsMotion());

    assertTrue(machine.generationCompleted());
    assertTrue(machine.dismissResult());
    assertEquals(State.WAITING_FOR_REMOVAL, machine.getState());
    assertFalse(machine.allowsMotion());
  }

  @Test
  public void unstableObjectDoesNotTriggerCaptureRequest() {
    CreaturePatrolStateMachine machine = new CreaturePatrolStateMachine(3);
    machine.startPatrol();

    machine.observeObjectZone(true);
    machine.observeObjectZone(false);

    assertEquals(State.PATROLLING, machine.getState());
    assertTrue(machine.allowsMotion());
  }

  @Test
  public void patrolResumesOnlyAfterObjectIsStablyRemoved() {
    CreaturePatrolStateMachine machine = new CreaturePatrolStateMachine(2);
    machine.startPatrol();
    machine.observeObjectZone(true);
    machine.observeObjectZone(true);
    machine.cancelCapture();

    machine.observeObjectZone(false);
    assertEquals(State.WAITING_FOR_REMOVAL, machine.getState());
    machine.observeObjectZone(true);
    machine.observeObjectZone(false);
    assertEquals(State.WAITING_FOR_REMOVAL, machine.getState());
    machine.observeObjectZone(false);

    assertEquals(State.PATROLLING, machine.getState());
    assertTrue(machine.allowsMotion());
  }

  @Test
  public void invalidTransitionsDoNotAdvanceState() {
    CreaturePatrolStateMachine machine = new CreaturePatrolStateMachine(2);

    assertFalse(machine.confirmCapture());
    assertFalse(machine.captureCompleted());
    assertFalse(machine.generationCompleted());
    assertFalse(machine.dismissResult());
    assertEquals(State.IDLE, machine.getState());
  }
}
