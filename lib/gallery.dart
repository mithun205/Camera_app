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
