import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/app/landing_page.dart';
import 'package:flutter_livechat_app/locator.dart';
import 'package:flutter_livechat_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel(),
      child: MaterialApp(
        title: 'Live Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.blue, secondaryHeaderColor: Colors.white),
        home: LandingPage(),
      ),
    );
  }
}
