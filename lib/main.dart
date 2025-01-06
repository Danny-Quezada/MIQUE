import 'package:flutter/material.dart';
import 'package:mi_que/ui/utils/setting_color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(MaterialApp(
    theme: SettingColor.themeData,
    themeMode: ThemeMode.light,
  ));
}
