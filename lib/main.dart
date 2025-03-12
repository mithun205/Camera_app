import 'dart:io';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/gallery.dart';
import 'package:flutter_application_1/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  
  final List<CameraDescription> cameras;
   MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(
        cameras: cameras,
      ),
      // routes: {
      //   "/gallery":(context)=> GalleryPage(imagesList:imagesList )
      // },
    );
    
  }
}
