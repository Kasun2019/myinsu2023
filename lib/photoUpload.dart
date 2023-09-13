import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


class PhotoUpload extends StatefulWidget {
  const PhotoUpload({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<PhotoUpload> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
   List<File> _images = [];
  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),

      body: 
      Padding(padding: const EdgeInsets.all(16.0),
        child: Column(
           children: [
            const Text('Allowed to take five photos only.',style:TextStyle(color: Color.fromARGB(255, 207, 120, 21)),),
            FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
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
                
              ],
            )
          
        ),
        
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            if (!mounted) return;
           // _images.add(File(image.path));
            
              
            setState(() => _images.add(File(image.path)));
            print("_images.length");
            print(_images.length);
            if(_images.length == 5){
              await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: _images,
                ),
              ),
            );
            }

       
             

            // await Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => DisplayPictureScreen(
            //       imagePath: image.path,
            //     ),
            //   ),
            // );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final List<File> imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      //body: Image.file(File(imagePath)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children:[ Expanded(      
                       child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, //         Number of columns
                          ),
                          itemCount: imagePath.length,
                          itemBuilder: (BuildContext context, int index) {
                             return Image.file(imagePath[index]);
                          },        
                        ),
                    ),
                     ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green)),
                      child: const Text('Save'),
                      onPressed: () {
                        
                      },
            ),
          ]
        ),
      ),
    );
  }
}