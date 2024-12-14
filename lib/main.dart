import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/einkaufslisten_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EinkaufslistenApp());
}

class EinkaufslistenApp extends StatelessWidget {
  const EinkaufslistenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Einkaufslisten App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EinkaufslistenPage(),
    );
  }
}
