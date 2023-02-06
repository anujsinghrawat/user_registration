import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_registration/services/auth_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void register() {
    Navigator.pushNamed(context, '/signUp');
  }

  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/register');
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    }
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                //welcome Back

                const Text(
                  'welcome Back,you\'ve been missed!',
                  style: TextStyle(
                    color: Color.fromARGB(255, 150, 150, 150),
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 50),

                //
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: FaIcon(FontAwesomeIcons.envelope)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: const Color.fromARGB(255, 53, 53, 53),
                      filled: true,
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.grey[500])),
                ),
                const SizedBox(height: 25),

                //
                TextField(
                  obscureText: true,
                  autocorrect: false,
                  controller: passwordController,
                  decoration: InputDecoration(
                      prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: FaIcon(FontAwesomeIcons.user)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: const Color.fromARGB(255, 53, 53, 53),
                      filled: true,
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.grey[500])),
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                //signin button
                const SizedBox(height: 25),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Color.fromARGB(255, 83, 83, 83),
                      minimumSize: const Size(350, 50),
                      textStyle: const TextStyle(fontSize: 22),
                    ),
                    onPressed: signUserIn,
                    child: const Text("SignIn")),

                //Signin with Google account
                // const SizedBox(height: 25),
                // ElevatedButton.icon(
                //   // icon: const Icon(Icons.login),
                //   icon: const FaIcon(FontAwesomeIcons.google),
                //   label: const Text("SignIn with Google account"),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.amber,
                //     foregroundColor: Color.fromARGB(255, 83, 83, 83),
                //     minimumSize: const Size(300, 50),
                //     textStyle: const TextStyle(fontSize: 22),
                //   ),
                //   onPressed: () {
                //     // AuthService().signInWithGoogle();
                //     AuthService().handleAuthState();
                //     // print('auth.google.com');
                //   },
                // ),
                const SizedBox(height: 50),

                //not a member , Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                        onPressed: register,
                        child: const Text(
                          'register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
