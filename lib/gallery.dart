import 'dart:io';
import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  final List<File> imagesList;

  const GalleryPage({super.key, required this.imagesList});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  void _deleteImage(int index) {
    setState(() {
      widget.imagesList.removeAt(index);
    });
    Navigator.pop(context,widget.imagesList); // Close FullScreenImage after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
      ),
      body: widget.imagesList.isEmpty
          ? const Center(
              child: Text(
                'No images',
                style: TextStyle(fontSize: 12),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: widget.imagesList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            imageFile: widget.imagesList[index],
                            onDelete: () => _deleteImage(index),
                          ),
                        ),
                      );
                    },
                    child: Image.file(
                      widget.imagesList[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final File imageFile;
  final VoidCallback onDelete;

  const FullScreenImage({super.key, required this.imageFile, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.grey,
        onPressed: onDelete,
        child: Icon(Icons.delete_outline_rounded),
        ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(imageFile),
        ),
      ),
    );
  }
}


//android 13 code
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:external_path/external_path.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_1/gallery.dart';
// import 'package:media_scanner/media_scanner.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:permission_handler/permission_handler.dart';
//   import 'dart:typed_data';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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

//   // Method channel for fetching files
//   static const platform = MethodChannel("com.example.flutter_application_1/files");

//   // Lists to store URIs of images, videos, and documents
//   List<String> imageFiles = [];
//   List<String> videoFiles = [];
//   List<String> documentFiles = [];

//   // Request permissions
// Future<void> _requestPermissions() async {
//   final photosStatus = await Permission.photos.status;
//   final videosStatus = await Permission.videos.status;

//   if (photosStatus.isDenied || videosStatus.isDenied) {
//     final photosPermission = await Permission.photos.request();
//     final videosPermission = await Permission.videos.request();

//     if (photosPermission.isPermanentlyDenied || videosPermission.isPermanentlyDenied) {
//       await openAppSettings();
//     }
//   }

//   if (await Permission.photos.isGranted && await Permission.videos.isGranted) {
//     _fetchFiles("image");
//     _fetchFiles("video");
//     _fetchFiles("document");
//   } else {
//     print("Photos or Videos permission denied.");
//   }
// }

//   // Fetch files using the method channel
//   Future<void> _fetchFiles(String fileType) async {
//     try {
//       final List<dynamic> files = await platform.invokeMethod("getFiles", {"fileType": fileType});
//       setState(() {
//         if (fileType == "image") imageFiles = List<String>.from(files);
//         if (fileType == "video") videoFiles = List<String>.from(files);
//         if (fileType == "document") documentFiles = List<String>.from(files);
//       });
//     } catch (e) {
//       print("Error fetching files: $e");
//     }
//   }



// Future<Uint8List?> _loadImageFromUri(String uri) async {
//   try {
//     final fileInfo = await DefaultCacheManager().getFileFromCache(uri);
//     if (fileInfo != null) {
//       return await fileInfo.file.readAsBytes();
//     } else {
//       final file = await DefaultCacheManager().downloadFile(uri);
//       return await file.file.readAsBytes();
//     }
//   } catch (e) {
//     print("Error loading image from URI: $e");
//     return null;
//   }
// }

//   // Build GridView for displaying files
// Widget _buildGridView(List<String> files, String type) {
//   return files.isEmpty
//       ? Center(child: Text("No files found", style: TextStyle(color: Colors.white)))
//       : GridView.builder(
//           padding: EdgeInsets.all(10),
//           itemCount: files.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 5,
//             mainAxisSpacing: 5,
//           ),
//           itemBuilder: (context, index) {
//             String uri = files[index];
//             if (type == "image") {
//               // Load image from content URI
//               return FutureBuilder<Uint8List?>(
//                 future: _loadImageFromUri(uri),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text("Failed to load image"));
//                   } else if (snapshot.hasData) {
//                     return Image.memory(snapshot.data!, fit: BoxFit.cover);
//                   } else {
//                     return Image.memory(snapshot.data!, fit: BoxFit.cover);
//                   }
//                 },
//               );
//             } else if (type == "video") {
//               // Build video thumbnail
//               return _buildVideoThumbnail(uri);
//             }
//             return null; // Handle documents if needed
//           },
//         );
// }

//   // Build video thumbnail
// Widget _buildVideoThumbnail(String uri) {
//   return GestureDetector(
//     onTap: () => OpenFilex.open(uri), // Open video using content URI
//     child: Container(
//       color: Colors.black26,
//       child: Center(
//         child: Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
//       ),
//     ),
//   );
// }

//   // Save image to Downloads directory
//   Future<File> saveImage(XFile image) async {
//     final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
//     final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
//     final file = File('$downloadPath/$fileName');
//     try {
//       await file.writeAsBytes(await image.readAsBytes());
//     } catch (_) {}
//     return file;
//   }

//   // Take a picture using the camera
//   void takePicture() async {
//     XFile? image;
//     if (cameraController.value.isTakingPicture || !cameraController.value.isInitialized) {
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

//   // Initialize the camera
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
//     _requestPermissions();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     cameraController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }

//   // Toggle visibility of the tab bar
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
//                   padding: const EdgeInsets.all(10),
//                   child: isFlashOn
//                       ? Container(
//                           height: 50,
//                           width: 50,
//                           decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(50)),
//                           child: const Icon(
//                             Icons.flash_on,
//                             color: Colors.white,
//                             size: 30,
//                           ))
//                       : Container(
//                           height: 50,
//                           width: 50,
//                           decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(50)),
//                           child: const Icon(
//                             Icons.flash_off,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
//                 ),
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
//               onPressed: () {
//                 _requestPermissions();
//                 toggleTabBar();
//               },
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
