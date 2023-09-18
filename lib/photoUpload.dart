import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insurtechmobapp/CustomMessageDialog%20.dart';
import 'package:insurtechmobapp/findLocation.dart';
import 'package:insurtechmobapp/models/customer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insurtechmobapp/vehicle.dart';


class PhotoUpload extends StatefulWidget {
  const PhotoUpload({
    super.key,
    required this.camera,
    required this.customer,
  });

  final CameraDescription camera;
  final Customer customer;

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
             Text('Allowed to take five photos only. You have ${_images.length}/5',style:const TextStyle(color: Color.fromARGB(255, 207, 120, 21)),),
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
           
            if(_images.length == 5){
              await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: _images,
                  customer: widget.customer,
                  camera:widget.camera
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
  late Customer customer;
  CameraDescription camera;

  DisplayPictureScreen({super.key, required this.imagePath,required this.customer,required this.camera});


  void saveDataToFirebase(context) async {
    
    final collectionRef = FirebaseFirestore.instance.collection('insu');
    FindLocation findLocation=FindLocation();
    try{

      
      Position location;
      double cLatitude=0.0;
      double cLongitude=0.0;
      if(await findLocation.checkPermission()){

         location =  findLocation.getLocation() as Position;
         cLatitude = location.latitude;
         cLongitude = location.longitude;

         print("location ................");
         print(cLatitude);
         print(cLongitude);
      }

      await collectionRef.add({
            'policyNumber': customer.code,
            'cType': customer.cType,
            'cLatitude': cLatitude,
            'cLongitude': cLongitude,
          });

     imagePath.asMap().forEach((index, val) {
      String nameSet = customer.code+"_$index";

        selectAndUploadImage(val, nameSet);
      });

      showCustomMessageDialog(context, "Save", "Save data Success !", () =>
                                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  
                                Vehicle(camera:camera)),
                              ),       
      );
      Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  
                                Vehicle(camera:camera)),
                              );
    }catch(e){
      print(e);
    }
    
    
    
  }

  Future<void> selectAndUploadImage(imgPath, imgName) async {
 
    if (imgPath != null) {
      //String imagePath = imgPath.path;
      String imageName = '$imgName.jpg'; 
      await uploadImageToFirebaseStorage(imgPath, imageName);
    }
  }

 
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
                            crossAxisCount: 2, //         Number of columns
                          ),
                          itemCount: imagePath.length,
                          itemBuilder: (BuildContext context, int index) {
                             return Stack(
                               children: [
                                
                                    Image.file(
                                    imagePath[index],
                                    ),
                                   //const SizedBox(height: 2.0,),
                                   
                                   Align(
                                    alignment: Alignment.bottomRight,
                                     child: Container(
                                      // margin: const EdgeInsets.all(2.0),
                                      // padding: const EdgeInsets.all(2.0),
                                      padding: const EdgeInsets.all(8),
                                      decoration:  const BoxDecoration(
                                        color: Color.fromARGB(255, 76, 66, 216),
                                        shape: BoxShape.circle
                                      ),
                                      child: Text(
                                        '${index+1}',
                                        style: const TextStyle(
                                          color: Colors.white, // Text color
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold // Adjust the font size as needed
                                        ),
                                      ), 
                                    ),
                                   ),
                               ],
                             );
                          },        
                        ),
                    ),
                     ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green)),
                      child: const Text('Submit my Data'),
                      onPressed: () {
                        
                        saveDataToFirebase(context);
                      },
            ),
          ]
        ),
      ),
    );
  }
  
  Future<void> uploadImageToFirebaseStorage(File imagePath, String imageName) async {
  try {
    Reference storageReference = FirebaseStorage.instance.ref().child(imageName);
    UploadTask uploadTask = storageReference.putFile(imagePath);
    await uploadTask.whenComplete(() => {});
  } catch (e) {
    print('Error uploading image: $e');
  }
  }
  void showCustomMessageDialog(
  BuildContext context,
  String title,
  String messages,
  final VoidCallback onPositivePressed
  ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomMessageDialog(
        title: title,
        message: messages,
        onPositivePressed: onPositivePressed
      );
    },
  );
}
}