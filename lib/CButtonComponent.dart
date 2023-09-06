import 'dart:ui';

import 'package:flutter/material.dart';

class CButtonComponent extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const CButtonComponent({super.key, 
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 80,right: 80),
      // decoration:  BoxDecoration(
      //                           gradient:const LinearGradient(
      //                           colors: [
      //                                     Color.fromRGBO(143, 148, 251, 1),
      //                                     Color.fromRGBO(196, 91, 223, 0.6),
      //                                   ]
      //                           ),
      //                           borderRadius: BorderRadius.circular(16.0),
                                
      //                         ),
      child: TextButton.icon(
        icon: const Icon(Icons.car_crash,size: 50),
        onPressed: onPressed,
        label: Text(text,
        style: const TextStyle(
                    fontSize: 24, // Custom font size
                    fontWeight: FontWeight.bold, // Custom font weight
                    //color: Color.fromARGB(255, 255, 255, 255), // Custom text color
                  )
                  ),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(200, 80)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(color: Color.fromARGB(255, 219, 218, 224))
            ),
          ) ,
        ),
      ),
      
    );
  }
}