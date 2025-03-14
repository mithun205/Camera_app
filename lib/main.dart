import 'dart:io';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/gallery.dart';
import 'package:flutter_application_1/Home_page.dart';

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
  // Future<File> saveImage(XFile image) async {
  //   final downlaodPath = await ExternalPath.getExternalStoragePublicDirectory(
  //       ExternalPath.DIRECTORY_DOWNLOADS);
  //   final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
  //   final file = File('$downlaodPath/$fileName');

  //   try {
  //     await file.writeAsBytes(await image.readAsBytes());
  //   } catch (_) {}

  //   return file;
  // }

  // void takePicture() async {
  //   XFile? image;

  //   if (cameraController.value.isTakingPicture ||
  //       !cameraController.value.isInitialized) {
  //     return;
  //   }

  //   if (isFlashOn == false) {
  //     await cameraController.setFlashMode(FlashMode.off);
  //   } else {
  //     await cameraController.setFlashMode(FlashMode.torch);
  //   }
  //   image = await cameraController.takePicture();

  //   if (cameraController.value.flashMode == FlashMode.torch) {
  //     setState(() {
  //       cameraController.setFlashMode(FlashMode.off);
  //     });
  //   }

  //   final file = await saveImage(image);
  //   setState(() {
  //     imagesList.add(file);
  //   });
  //   MediaScanner.loadMedia(path: file.path);
  // }






// //android 11 code
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:external_path/external_path.dart';
// //import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_1/gallery.dart';
// //import 'package:image_picker/image_picker.dart';
// import 'package:media_scanner/media_scanner.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MainPage extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   const MainPage({super.key, required this.cameras});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
//   late CameraController cameraController;
//   late Future<void> cameraValue;
//   List<File> imagesList = [];
//   bool isFlashOn = false;
//   bool isRearCamera = true;
//   bool isTabBarVisible = false;
//   late TabController _tabController;

//   // ----
//   // 13/25 - directry pick
//   static const platform =
//       MethodChannel("com.example.flutter_application_1/files");
//   List<String> imageFiles = [];
//   List<String> videoFiles = [];
//   List<String> documentFiles = [];

//   Future<void> _requestPermissions() async {
//     if (await Permission.storage.request().isGranted) {
//       _fetchFiles("image");
//       _fetchFiles("video");
//       _fetchFiles("document");
//     } else {
//       print("Permission denied");
//     }
//   }

//   Future<void> _fetchFiles(String fileType) async {
//     try {
//       final List<dynamic> files =
//           await platform.invokeMethod("getFiles", {"fileType": fileType});
//       setState(() {
//         if (fileType == "image") imageFiles = List<String>.from(files);
//         if (fileType == "video") videoFiles = List<String>.from(files);
//         if (fileType == "document") documentFiles = List<String>.from(files);
//       });
//     } catch (e) {
//       print("Error fetching files: $e");
//     }
//   }

//   Widget _buildGridView(List<String> files, String type) {
//     return files.isEmpty
//         ? Center(child: Text("No files found"))
//         : GridView.builder(
//             padding: EdgeInsets.all(10),
//             itemCount: files.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 5,
//               mainAxisSpacing: 5,
//             ),
//             itemBuilder: (context, index) {
//               String path = files[index];
//               if (type == "image") {
//                 return Image.file(File(path), fit: BoxFit.cover);
//               } else if (type == "video") {
//                 return _buildVideoThumbnail(path);
//               }
//               return null;
//               // else {
//               //   return _buildDocumentTile(path);
//               // }
//             },
//           );
//   }

//   Widget _buildVideoThumbnail(String filePath) {
//     return GestureDetector(
//       onTap: () => OpenFilex.open(filePath),
//       child: Container(
//           color: Colors.black26,
//           child: Center(
//               child:
//                   Icon(Icons.play_circle_fill, size: 50, color: Colors.white))),
//     );
//   }

//   Future<File> saveImage(XFile image) async {
//     final downlaodPath = await ExternalPath.getExternalStoragePublicDirectory(
//         ExternalPath.DIRECTORY_DOWNLOADS);
//     final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
//     final file = File('$downlaodPath/$fileName');

//     try {
//       await file.writeAsBytes(await image.readAsBytes());
//     } catch (_) {}

//     return file;
//   }

//   void takePicture() async {
//     XFile? image;

//     if (cameraController.value.isTakingPicture ||
//         !cameraController.value.isInitialized) {
//       return;
//     }

//     if (isFlashOn == false) {
//       await cameraController.setFlashMode(FlashMode.off);
//     } else {
//       await cameraController.setFlashMode(FlashMode.torch);
//     }
//     image = await cameraController.takePicture();

//     if (cameraController.value.flashMode == FlashMode.torch) {
//       setState(() {
//         cameraController.setFlashMode(FlashMode.off);
//       });
//     }

//     final file = await saveImage(image);
//     setState(() {
//       imagesList.add(file);
//     });
//     MediaScanner.loadMedia(path: file.path);
//   }

//   void startCamera(int camera) {
//     cameraController = CameraController(
//       widget.cameras[camera],
//       ResolutionPreset.high,
//     );
//     cameraValue = cameraController.initialize();
//   }

//   @override
//   void initState() {
//     super.initState();
   
//     startCamera(0);
//      _requestPermissions();
//     _tabController = TabController(length: 2, vsync: this);
    
//   }

//   @override
//   void dispose() {
//     cameraController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }

//   void toggleTabBar() {
//     setState(() {
//       isTabBarVisible = !isTabBarVisible;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Camera App'),
//         centerTitle: true,
//         backgroundColor: Colors.lightBlue[100],
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.photo_library),
//             onPressed: () async {
//               final updatedList = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => GalleryPage(imagesList: imagesList),
//                 ),
//               );
//               if (updatedList != null) {
//                 setState(() {
//                   imagesList = updatedList; // Update the UI with the new list
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.grey,
//         shape: const CircleBorder(),
//         onPressed: takePicture,
//         child: const Icon(
//           Icons.camera_alt,
//           size: 30,
//           color: Colors.black87,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       body: Stack(
//         children: [
//           FutureBuilder(
//             future: cameraValue,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return SizedBox(
//                   width: size.width,
//                   height: size.height,
//                   child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: 100,
//                       child: CameraPreview(cameraController),
//                     ),
//                   ),
//                 );
//               } else {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//           Positioned(
//             bottom: 220,
//             left: 280,
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isFlashOn = !isFlashOn;
//                 });
//               },
//               child: Container(
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                 ),
//                 child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: isFlashOn
//                         ? Container(
//                             height: 50,
//                             width: 50,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey),
//                                 borderRadius: BorderRadius.circular(50)),
//                             child: const Icon(
//                               Icons.flash_on,
//                               color: Colors.white,
//                               size: 30,
//                             ))
//                         : Container(
//                             height: 50,
//                             width: 50,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey),
//                                 borderRadius: BorderRadius.circular(50)),
//                             child: const Icon(
//                               Icons.flash_off,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                           )),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 8,
//             left: 280,
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isRearCamera = !isRearCamera;
//                 });
//                 isRearCamera ? startCamera(0) : startCamera(1);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: isRearCamera
//                     ? Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(50)),
//                         child: const Icon(
//                           Icons.cameraswitch_outlined,
//                           color: Colors.white,
//                           size: 30,
//                         ))
//                     : Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                             color: Colors.grey,
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(50)),
//                         child: const Icon(
//                           Icons.cameraswitch_sharp,
//                           color: Colors.white,
//                           size: 30,
//                         ),
//                       ),
//               ),
//             ),
//           ),
//           Visibility(
//             visible: isTabBarVisible,
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TabBar(
//                     controller: _tabController,
//                     indicatorColor: Colors.white,
//                     labelColor: Colors.white,
//                     tabs: [
//                       Tab(icon: Icon(Icons.image), text: "Images"),
//                       Tab(icon: Icon(Icons.video_library), text: "Videos"),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 550, 
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         _buildGridView(imageFiles, "image"),
//                         _buildGridView(videoFiles, "video"),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 180,
//             left: 0,
//             right: 0,
//             child: IconButton(
//             onPressed: (){
//               _requestPermissions();
//               toggleTabBar();
//             },
//               icon: Icon(
//                 isTabBarVisible
//                     ? Icons.keyboard_arrow_down_outlined
//                     : Icons.keyboard_arrow_up_outlined,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 7, bottom: 75),
//                     child: Container(
//                       height: 100,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: imagesList.length,
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Padding(
//                             padding: const EdgeInsets.all(2),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image(
//                                 height: 100,
//                                 width: 100,
//                                 opacity: const AlwaysStoppedAnimation(0.7),
//                                 image: FileImage(
//                                   File(imagesList[index].path),
//                                 ),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }