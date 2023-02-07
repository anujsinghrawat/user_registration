// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_registration/components/my_button.dart';
import 'package:user_registration/components/my_textfield.dart';

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
                  child: MyTextField(
                    controller: nameController,
                    hintText: 'Enter your name',
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 25),

                //
                SizedBox(
                  width: 400,
                  child: MyTextField(
                    controller: emailController,
                    hintText: 'Enter your email',
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 25),

                //
                SizedBox(
                  width: 400,
                  child: MyTextField(
                    controller: passwordController,
                    obscureText: true,
                    hintText: 'Enter your password',
                  ),
                ),

                const SizedBox(height: 10),

                //signup button
                const SizedBox(height: 25),
                MyButton(
                    text: "Sign Up",
                    onTap: signUserUp,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
