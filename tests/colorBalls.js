var mode = "NONE";

function start() {
  stopRobot();

  // Detection handlers will set mode
  // and start the appropriate action.
}

function forever() {
  while (true) {

    if (mode == "GREEN" && sonarReading() <= 30) {
      stopRobot();
      disableAI();
    }

    if (mode == "RED") {
      stopRobot();
      disableAI();
    }

    pause(100);
  }
}
