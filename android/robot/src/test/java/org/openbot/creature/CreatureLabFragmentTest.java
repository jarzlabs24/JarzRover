package org.openbot.creature;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class CreatureLabFragmentTest {

  @Test
  public void normalizesLocalServerAddresses() {
    assertEquals("", CreatureLabFragment.normalizeServerUrl("  "));
    assertEquals(
        "http://192.168.1.10:3000",
        CreatureLabFragment.normalizeServerUrl("192.168.1.10:3000/"));
    assertEquals(
        "https://creatures.example.com",
        CreatureLabFragment.normalizeServerUrl("https://creatures.example.com///"));
  }
}
