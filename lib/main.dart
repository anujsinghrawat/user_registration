import 'package:flutter/material.dart';
import 'package:user_registration/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_registration/screens/registration_page.dart';
import 'package:user_registration/screens/signup_page.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home:Login(),
      home: Register(),
       routes: {
          '/signIn': (context) => Login(),
          '/signUp': (context) => SignUp(),
          '/register': (context) => Register(),
        }
    );
  }
}
