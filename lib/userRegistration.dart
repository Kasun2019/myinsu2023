import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


class UserRegistor extends StatefulWidget {
  final CameraDescription camera;
  const UserRegistor({super.key,required this.camera});

  @override
  State<UserRegistor> createState() => _UserRegistorState();
}


class _UserRegistorState extends State<UserRegistor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  ImageProvider<Object>? _image;

  void _saveUserData() async{
    if (_formKey.currentState!.validate()) {
    
    try
    {

     

      await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _email.text, password: _password.text);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
      await user.updateDisplayName(_name.text);
      }

        Fluttertoast.showToast(
                msg: "save",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM, 
                timeInSecForIosWeb: 1, 
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0,
              );
    }
    catch(e)
    {
    
        Fluttertoast.showToast(
                msg: e.toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM, 
                timeInSecForIosWeb: 1, 
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0,
              );
     
      print(e);
    }

  
    }
  }
    Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = FileImage(File(pickedFile.path));
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Request'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[300],
                              backgroundImage:// _image == "noImage"?
                              const AssetImage('assets/UserProfile.png')
                             // FileImage(_image), 
                            ),
                        ElevatedButton(
                          onPressed: _getImage,
                          child: const Text('Upload Photo'),
                        ),
                      ],
                    ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  controller: _name,
                 
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  controller: _email,
                 
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  controller: _password,
                  scrollPadding:const EdgeInsets.only(bottom:10),
                ),
                ElevatedButton(
                  onPressed: _saveUserData,
                  child: Text('Request'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
