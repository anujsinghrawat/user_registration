// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = result.user;
      user?.updateDisplayName(nameController.text);
      // pop the loading circle
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/signIn');
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'weak-password') {
        // show error to user
        print('The password provided is too weak.');
      }

      // WRONG PASSWORD
      else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
              style: TextStyle(color: Color.fromARGB(255, 7, 7, 7)),
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
                  'Register to create a new account',
                  style: TextStyle(
                    color: Color.fromARGB(255, 150, 150, 150),
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 50),

                //
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        prefixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: FaIcon(FontAwesomeIcons.user)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: const Color.fromARGB(255, 53, 53, 53),
                        filled: true,
                        hintText: 'Enter your name here',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),
                const SizedBox(height: 25),

                //
                SizedBox(
                  width: 400,
                  child: TextField(
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
                ),
                const SizedBox(height: 25),

                //
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: FaIcon(FontAwesomeIcons.lock)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: const Color.fromARGB(255, 53, 53, 53),
                      filled: true,
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                //signup button
                const SizedBox(height: 25),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Color.fromARGB(255, 83, 83, 83),
                      minimumSize: const Size(300, 50),
                      textStyle: const TextStyle(fontSize: 22),
                    ),
                    onPressed: signUserUp,
                    child: const Text(
                      "Register",
                      textScaleFactor: 1,
                    )),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
