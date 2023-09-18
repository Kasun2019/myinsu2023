import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insurtechmobapp/vehicle.dart';
import 'CButtonComponent.dart';

class Home extends StatelessWidget {
  const Home({super.key,required this.camera});
  final CameraDescription camera;
  

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    User? user = FirebaseAuth.instance.currentUser;
    String greeting = getGreeting(currentTime)+" ${user?.displayName}";
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
                        child: Padding(
                        padding: const EdgeInsets.only(top: 20,left: 15),
                        child: Text(greeting,
                        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255),
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
                      paramTextStyle:const TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold, 
                                    color: Color.fromARGB(255, 35, 94, 161), 
                      ),
                      paramIcon: const Icon(Icons.car_crash,size: 50),
                      onPressed: () {
                         Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Vehicle(camera:camera),
                              ));

                      },
                    ),
                    ),
              const SizedBox(),
              Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: double.infinity,
                  padding: const EdgeInsets.all(2),
                      child: CButtonComponent(
                      text: 'Claim',
                      paramTextStyle:const TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold, 
                                    color: Color.fromARGB(255, 185, 69, 60), 
                      ),
                      paramIcon: const Icon(Icons.back_hand_sharp,size: 50,color: Color.fromARGB(255, 185, 69, 60),),
                      onPressed: () {
                        // Handle button press here
                        print('Button pressed!');
                      },
                    ),
                    ), 
                    const SizedBox(),
              Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: double.infinity,
                  padding: const EdgeInsets.all(2),
                      child: CButtonComponent(
                      text: 'My Cart',
                      paramTextStyle:const TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold, 
                                    color: Color.fromARGB(255, 82, 107, 22), 
                      ),
                      paramIcon: const Icon(Icons.add_shopping_cart_outlined,size: 50,color: Color.fromARGB(255, 82, 107, 22),),
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
  String getGreeting(DateTime time) {
    final hour = time.hour;
    if (hour >= 6 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  } 
}