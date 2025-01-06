import 'package:flutter/material.dart';
import 'package:mi_que/ui/pages/initial_page.dart';
import 'package:mi_que/ui/pages/login_page.dart';
import 'package:mi_que/ui/pages/sign_up_page.dart';
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
    debugShowCheckedModeBanner: false,
    theme: SettingColor.themeData,
    themeMode: ThemeMode.light,
    initialRoute: "/",
    routes: {
      "/": (context) => const InitialPage(),
      "/login": (context) => LoginPage(),
      "/signup": (context) => SignUpPage(),
    },
  ));
}
