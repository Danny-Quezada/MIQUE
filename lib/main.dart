import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mi_que/domain/interfaces/ai_model.dart';
import 'package:mi_que/domain/interfaces/ibook_model.dart';
import 'package:mi_que/domain/interfaces/iuser_model.dart';
import 'package:mi_que/infraestructure/repository/ai_repository.dart';
import 'package:mi_que/infraestructure/repository/book_repository.dart';
import 'package:mi_que/infraestructure/repository/user_repository.dart';
import 'package:mi_que/providers/ai_provider.dart';
import 'package:mi_que/providers/book_provider.dart';
import 'package:mi_que/providers/user_provider.dart';
import 'package:mi_que/ui/pages/bottom_navigation_page.dart';
import 'package:mi_que/ui/pages/initial_page.dart';
import 'package:mi_que/ui/pages/login_page.dart';
import 'package:mi_que/ui/pages/sign_up_page.dart';
import 'package:mi_que/ui/utils/setting_color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(MultiProvider(
    providers: [
      Provider<IUserModel>(create: (_) => UserRepository()),
      ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(
              iUserModel: Provider.of<IUserModel>(context, listen: false))),
      Provider<IBookModel>(create: (_) => BookRepository()),
      ChangeNotifierProvider<BookProvider>(
          create: (context) => BookProvider(
              iBookModel: Provider.of<IBookModel>(context, listen: false))),
      Provider<AiModel>(
        create: (_) => AiRepository(),
      ),
      ChangeNotifierProvider<AiProvider>(
          create: (context) =>
              AiProvider(aiModel: Provider.of<AiModel>(context, listen: false)))
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: SettingColor.themeData,
      themeMode: ThemeMode.light,
      initialRoute: "/",
      routes: {
        "/": (context) =>
            Consumer<UserProvider>(builder: (context, userProvider, _) {
              return StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return FutureBuilder(
                          future: userProvider.loadCurrentUser(),
                          builder: (context, userSnapshot) {
                            return const BottomNavigationPage();
                          });
                    } else {
                      return const InitialPage();
                    }
                  });
            }),
        "/login": (context) => LoginPage(),
        "/signup": (context) => SignUpPage(),
      },
    ),
  ));
}
