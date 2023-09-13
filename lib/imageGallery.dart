import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  List<File> _images = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: 
      Padding(padding: const EdgeInsets.all(16.0),
        child: Column(
           children: [
            const Text('Allowed to select five photos only.',style:TextStyle(color: Color.fromARGB(255, 207, 120, 21)),),
             Expanded(      
                   child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //         Number of columns
                      ),
                      itemCount: _images.length,
                      itemBuilder: (BuildContext context, int index) {
                         return Image.file(_images[index]);
                      },        
                    ),
                ),
              ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: const Text('Select Image from Gallery'),
              onPressed: () {
                getImagesFromGallery();
              },
            ),
              ],
            )
          
        ),
      );
  
  }
  Future getImagesFromGallery() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
 
    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            _images.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Select Photos')));
        }
      },
    );
  }
}