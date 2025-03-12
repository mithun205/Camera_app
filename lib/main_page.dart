import 'dart:io';

import 'package:camera/camera.dart';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/gallery.dart';
import 'package:image_picker/image_picker.dart';

import 'package:media_scanner/media_scanner.dart';

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainPage({super.key, required this.cameras});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  
  late CameraController cameraController;
  late Future<void> cameraValue;
  List<File> imagesList = [];

  bool isFlashOn = false;
  bool isRearCamera = true;
  
  
  bool isTabBarVisible = false;

  
  late TabController _tabController;

  // for image selection using image_picker
  // File? _SelectedImage;

  // Future pickImage() async {
  //   final returnedImage =
  //       await ImagePicker().pickMedia(

  //       );

  //   if (returnedImage == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Center(child: Text("Please select any image"))),
  //     );
  //     return;
  //   }

  //   setState(() {
  //     _SelectedImage = File(returnedImage.path);
  //     imagesList.add(_SelectedImage!); // Add the selected image to the list
  //   });
  // }

  
  
//for image selection using file_picker
File? _SelectedImage;

Future pickImage() async {
  final result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.image, 
    //allowedExtensions: ["png"]

  );

  if (result == null || result.files.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(child: Text("Please select at least one image"))),
    );
    return;
  }

  setState(() {
    

    for (var file in result.files) {
      if (file.path != null) {
        imagesList.add(File(file.path!));
      }
    }
  });
}

   

  Future<File> saveImage(XFile image) async {
    final downlaodPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('$downlaodPath/$fileName');

    try {
      await file.writeAsBytes(await image.readAsBytes());
    } catch (_) {}

    return file;
  }

  void takePicture() async {
    XFile? image;

    if (cameraController.value.isTakingPicture ||
        !cameraController.value.isInitialized) {
      return;
    }

    if (isFlashOn == false) {
      await cameraController.setFlashMode(FlashMode.off);
    } else {
      await cameraController.setFlashMode(FlashMode.torch);
    }
    image = await cameraController.takePicture();

    if (cameraController.value.flashMode == FlashMode.torch) {
      setState(() {
        cameraController.setFlashMode(FlashMode.off);
      });
    }

    final file = await saveImage(image);
    setState(() {
      imagesList.add(file);
    });
    MediaScanner.loadMedia(path: file.path);
  }

  void startCamera(int camera) {
    cameraController = CameraController(
      widget.cameras[camera],
      ResolutionPreset.high,
      
    );
    cameraValue = cameraController.initialize();
  }

  @override
  void initState() {
    super.initState();
    startCamera(0);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    cameraController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void toggleTabBar() {
    setState(() {
      isTabBarVisible = !isTabBarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () async {
  final updatedList = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GalleryPage(imagesList: imagesList),
    ),
  );

  if (updatedList != null) {
    setState(() {
      imagesList = updatedList; // Update the UI with the new list
    });
  }
},

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        shape: const CircleBorder(),
        onPressed: takePicture,
        child: const Icon(
          Icons.camera_alt,
          size: 30,
          color: Colors.black87,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 100,
                      child: CameraPreview(cameraController),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),

          // Positioned(
          //   bottom: 20,
          //   left: 25,
          //   child: Container(
          //     height: 40,
          //     width: 40,
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.white),
          //       borderRadius: BorderRadius.circular(50)
          //     ),
          //     child: IconButton(
          //       iconSize: 20,
          //       color: Colors.white,
          //         icon: const Icon(Icons.photo_library),
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => GalleryPage(imagesList: imagesList),
          //             ),
          //           );
          //         },
          //       ),
          //   ),
          // ),

          //selfie an light
          // SafeArea(
          //   child: Align(
          //     alignment: Alignment.topRight,
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 5, top: 10),
          //       child: Column(
          //         //mainAxisSize: MainAxisSize.min,
          //         children: [
          //           GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 isFlashOn = !isFlashOn;
          //               });
          //             },
          //             child: Container(
          //               decoration: const BoxDecoration(
                          
          //                 shape: BoxShape.circle,
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(10),
          //                 child: isFlashOn
          //                       ? Container(
          //                       height: 50,
          //                       width: 50,
          //                       decoration: BoxDecoration(
                                 
          //                         border: Border.all(color: Colors.grey),
          //                         borderRadius: BorderRadius.circular(50)
          //                       ),
          //                       child: const Icon(
          //                           Icons.flash_on,
          //                           color: Colors.white,
          //                           size: 30,
          //                         ))
          //                       : Container(
          //                       height: 50,
          //                       width: 50,
          //                       decoration: BoxDecoration(
                                 
          //                         border: Border.all(color: Colors.grey),
          //                         borderRadius: BorderRadius.circular(50)
          //                       ),
          //                       child: const Icon(
          //                           Icons.flash_off,
          //                           color: Colors.white,
          //                           size: 30,
          //                         ),)
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 10,
          //           ),
          //           // Positioned(
          //           //   bottom: 180,
          //           //   child: GestureDetector(
          //           //     onTap: () {
          //           //       setState(() {
          //           //         isRearCamera = !isRearCamera;
          //           //       });
          //           //       isRearCamera ? startCamera(0) : startCamera(1);
          //           //     },
          //           //     child: Padding(
          //           //       padding: const EdgeInsets.all(10),
          //           //       child: isRearCamera
          //           //           ? const Icon(
          //           //               Icons.cameraswitch_outlined,
          //           //               color: Colors.white,
          //           //               size: 30,
          //           //             )
          //           //           : Container(
          //           //             height: 50,
          //           //             width: 50,
          //           //             decoration: BoxDecoration(
          //           //               color: Colors.grey,
          //           //               border: Border.all(color: Colors.grey),
          //           //               borderRadius: BorderRadius.circular(50)
          //           //             ),
          //           //             child: const Icon(
          //           //                 Icons.cameraswitch_sharp,
          //           //                 color: Colors.white,
          //           //                 size: 30,
          //           //               ),
          //           //           ),
          //           //     ),
          //           //   ),
          //           // )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          // flash button
          Positioned(
            bottom: 220,
            left: 280,
            child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFlashOn = !isFlashOn;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: isFlashOn
                                ? Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                 
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                child: const Icon(
                                    Icons.flash_on,
                                    color: Colors.white,
                                    size: 30,
                                  ))
                                : Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                 
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                child: const Icon(
                                    Icons.flash_off,
                                    color: Colors.white,
                                    size: 30,
                                  ),)
                          ),
                        ),
                      ),
          ),
          //camera button
          Positioned(
                      bottom: 8,
                      left: 280,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isRearCamera = !isRearCamera;
                          });
                          isRearCamera ? startCamera(0) : startCamera(1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: isRearCamera
                              ? Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                 
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                child: const Icon(
                                  Icons.cameraswitch_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ))
                              : Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                child: const Icon(
                                    Icons.cameraswitch_sharp,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                              ),
                        ),
                      ),
                    ),

          // tab  bar
          Visibility(
            visible: isTabBarVisible,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    tabs: const [
                      Tab(text: 'Recent Images',),
                      Tab(text: 'System Gallery'),
                    ],
                  ),
                  SizedBox(
                    height: 600,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Recent Images Tab
                        GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                          ),
                          itemCount: imagesList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(imagesList[index].path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                        // System Gallery Tab
                        Center(
                          child: ElevatedButton(
                            onPressed: pickImage,
                            child: const Text("Access Gallery"),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // arrow button
          Positioned(
            bottom: 180,
            left: 0,
            right: 0,
            child: IconButton(
              onPressed: toggleTabBar,
              icon: Icon(
                isTabBarVisible
                    ? Icons.keyboard_arrow_down_outlined
                    : Icons.keyboard_arrow_up_outlined,
                color: Colors.white,
              ),
            ),
          ),

          //draggable preview...
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7, bottom: 75),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: imagesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                height: 100,
                                width: 100,
                                opacity: const AlwaysStoppedAnimation(07),
                                image: FileImage(
                                  File(imagesList[index].path),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
