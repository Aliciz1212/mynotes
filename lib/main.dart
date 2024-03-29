import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/views/login_view.dart';
import 'package:helloworld/views/register_view.dart';
import 'package:helloworld/views/verify_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        "/login/": (context) => const LoginView(),
        "/register/": (context) => const RegisterView()
      }));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  return const NoteView();
                } else {
                  return const LoginView();
                }
              } else {
                return const VerifyEmailView();
              }
            // if (user?.emailVerified ?? false) {
            //   return const Text("Done");
            // } else {
            //   // Navigator.of(context).push(MaterialPageRoute(
            //   //     builder: (context) => const VerifyEmailView()));
            //   return const VerifyEmailView();
            // }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}

enum MenuAction { logout }

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton(
              onSelected: (value) async{
                switch(value){
                case MenuAction.logout:
                    final shouldlogout= await showLogOutdialog(context);
                    if(shouldlogout){
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil("/login/", (route) => false);

                    }
                    break;

              }},
              itemBuilder: (context) => ([
                    const PopupMenuItem<MenuAction>(
                        value: MenuAction.logout, child: Text("log out"))
                  ]))
        ],
      ),
      body: const Text("hi"),
    );
  }
}

Future<bool> showLogOutdialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
              title: const Text("Sign out?"),
              content: const Text("Sure to sign out?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Log out"))
              ])).then((value) => value ?? false);
}
