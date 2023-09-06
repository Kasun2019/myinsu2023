import 'package:flutter/material.dart';
import 'CButtonComponent.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Home Page'),
        // ),
        body: SingleChildScrollView(
          child: Column(
          
            children: [
              Container(
                width: double.infinity,
                height: 400,
                      decoration:const BoxDecoration(
                        image:  DecorationImage(
                          image: AssetImage("assets/image_header.png"),
                          
                          ),
                                    
                        ),
                        child: const Padding(
                        padding: EdgeInsets.only(top: 20,left: 15),
                        child: Text("Good Morning kasun",
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        ),
                        //textAlign: TextAlign.center,
                        ),
                      ),
              ),
               Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: double.infinity,
                  padding: const EdgeInsets.all(2),
                      child: CButtonComponent(
                      text: 'Vehicle',
                      onPressed: () {
                        // Handle button press here
                        print('Button pressed!');
                      },
                    ),
                    ), 
               
            ],
          )
        ),
      ),
    );
  }
  
}