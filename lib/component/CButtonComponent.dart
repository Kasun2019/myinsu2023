import 'dart:ui';

import 'package:flutter/material.dart';

class CButtonComponent extends StatelessWidget {
  final String text;
  final TextStyle paramTextStyle;
  final Icon paramIcon;
  final Function()? onPressed;

  const CButtonComponent({super.key, 
    required this.text,
    required this.paramTextStyle,
    required this.paramIcon,
    this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 80,right: 80),

      child: TextButton.icon(
        icon: paramIcon,
        //icon: const Icon(Icons.car_crash,size: 50),
        onPressed: onPressed,
        label: Text(text,
        style: paramTextStyle
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