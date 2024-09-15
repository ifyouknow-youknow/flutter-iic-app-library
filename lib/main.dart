import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nothing_bagel_app_template/MODELS/DATAMASTER/datamaster.dart';
import 'package:nothing_bagel_app_template/MODELS/firebase.dart';
import 'package:nothing_bagel_app_template/VIEWS/playground.dart';
import 'package:nothing_bagel_app_template/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "lib/.env");

  runApp(
    MaterialApp(
      home: PlaygroundView(dm: DataMaster()),
    ),
    // initialRoute: "/",
    // routes: {
    //   // "/": (context) => const PlaygroundView(),
    // },
  );
}
