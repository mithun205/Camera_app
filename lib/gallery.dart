import 'dart:io';
import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  final List<File> imagesList;

  GalleryPage({super.key, required this.imagesList});

  File? _SelectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
      ),
      body: imagesList.isEmpty
          ? const Center(
              child: Text(
                'No images available',
                style: TextStyle(fontSize: 20),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    shrinkWrap: true,
                    itemCount: imagesList.length,
                    itemBuilder: (context, index) {
                      return Image.file(
                        imagesList[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                // Text(" Selected Images"),
                // Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: GridView.builder(
                //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 3,
                //         crossAxisSpacing: 5,
                //         mainAxisSpacing: 5,
                //       ),
                //       itemCount: imagesList.length,
                //       itemBuilder: (context, index) {
                //         return  _SelectedImage != null ? FileImage(_SelectedImage!) : null;
                //       },
                //     ),
                // ),
              ],
            ),
    );
  }
}
