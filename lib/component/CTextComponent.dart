import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  const CustomText({super.key,required this.cLabel,required this.cVal,required this.enabled});
  final String cLabel,cVal;
  final bool enabled;

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
TextEditingController txt1 = TextEditingController();

@override
  void initState() {
    super.initState();
    txt1.text = widget.cVal;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // You can adjust the width as needed
      child:  TextField(
        decoration: InputDecoration(
          labelText: widget.cLabel,
          border: const OutlineInputBorder(), // This creates the outline
        ),
        controller: txt1,
        enabled: false,
      ),
    );
  }
}