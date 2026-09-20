import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openbot_controller/screens/controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

  // Do not make app startup depend on the orientation request completing.
  // Recent iOS versions may delay or reject that request while launching.
  runApp(const Controller());
}
