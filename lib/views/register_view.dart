import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("REGISTER"),
        ),
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    children: [
                      TextField(
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        decoration: const InputDecoration(
                            hintText: "Enter your email here"),
                      ),
                      TextField(
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: _password,
                        decoration: const InputDecoration(
                            hintText: "Enter your password here"),
                      ),
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try{final UserCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          print(UserCredential);
                          }on FirebaseAuthException catch (e) {
                            final error= e.code;
                            if(error=="weak-password"){
                              print("Weak password");
                            }else if(error=="email-already-in-use"){
                              print("Email already in use");
                            }else if(error==""){
                              print("");
                            }

                          }
                        },
                        child: const Text("Register"),
                      ),
                    ],
                  );
                default:
                  return const Text("Loading ~");
              }
            }));
  }
}