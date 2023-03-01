import 'dart:io';

import 'package:comic_reader/screens/chapter_screen.dart';
import 'package:comic_reader/screens/read_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/homepage-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: "comic_reader",
    options: Platform.isMacOS || Platform.isIOS
        ? FirebaseOptions(
            //google_services.json - "current_key"
            apiKey: 'AIzaSyB5FIggH_IYyR2v1vAe22Zt5BK098tDO9w',
            appId: 'IOS KEY',
            //google_services.json - "project_number"
            messagingSenderId: '409431075617',
            //google_services.json - "project_id"
            projectId: 'comicreader-68a94',
            //google_services.json - "firebase_url"
            databaseURL:
                'https://comicreader-68a94-default-rtdb.asia-southeast1.firebasedatabase.app/',
          )
        : FirebaseOptions(
            apiKey: 'AIzaSyB5FIggH_IYyR2v1vAe22Zt5BK098tDO9w',
            //google_services.json - "mobilesdk_app_id"
            appId: '1:409431075617:android:d31bd38d00e96d3bb72c60',
            messagingSenderId: '409431075617',
            projectId: 'comicreader-68a94',
            databaseURL:
                'https://comicreader-68a94-default-rtdb.asia-southeast1.firebasedatabase.app/',
          ),
  );

  // Adding ProviderScope enables Riverpod for the entire project
  runApp(ProviderScope(
      child: MyApp(
    app: app,
  )));
}

class MyApp extends StatelessWidget {
  late final FirebaseApp app;
  MyApp({required this.app});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/chapters': (context) => ChapterScreen(),
        '/read': (context) => ReadScreen(),
      },
      home: MyHomePage(
        title: 'Comic Reader',
        app: app,
      ),
    );
  }
}
