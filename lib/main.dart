import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insurtechmobapp/SqlLiteDB.dart';
import 'package:insurtechmobapp/findLocation.dart';
import 'package:insurtechmobapp/home.dart';
import 'package:camera/camera.dart';
import 'package:sqflite/sqflite.dart';


import 'CustomMessageDialog .dart';

void main() async {

    WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  
    Database? db =  await SqlLiteDB.instance.database;

    print("db?.isOpen");
    print(db?.isOpen);

  runApp(MyInsuApp(camera: firstCamera));
}

class MyInsuApp extends StatefulWidget {
  const MyInsuApp({
    super.key,
    required this.camera
  });
final CameraDescription camera;
  @override
  State<MyInsuApp> createState() => _MyInsuAppState();
  
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

class _MyInsuAppState extends State<MyInsuApp> {

  Future<FirebaseApp> _initializeFireBsa() async{
    FirebaseApp firebaseApp= await Firebase.initializeApp();
    return firebaseApp;
  }

 



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFireBsa(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
            return  MaterialApp(
                debugShowCheckedModeBanner: false,
                home: LoginPage(camera:widget.camera));
        }
      
       return const Center(
         child: CircularProgressIndicator(),
          
       );
      }
      );
  }

} 





class LoginPage extends StatefulWidget {
  const LoginPage({super.key,required this.camera});
  
final CameraDescription camera;
  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
 TextEditingController emailContoller = TextEditingController();
    TextEditingController passwordContoller = TextEditingController();
   // final  _liteDB = SqlLiteDB.internal();
    
TextEditingController _textFieldController = TextEditingController();
   
    
  static Future<User?> loginWithCredential(
    {
      required String email,
      required String password,
      required BuildContext context
    }
  )async{
    FirebaseAuth auth=FirebaseAuth.instance;
    User? user;
      FindLocation findLocation = FindLocation();
      findLocation.checkPermission();

        if(await findLocation.checkPermission()){

         Position location =  await findLocation.getLocation();
         double cLatitude = location.latitude;
         double cLongitude = location.longitude;

         print("location ................");
         print(cLatitude);
         print(cLongitude);
      }
    
    try
    {
      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email, password: password);
      user = credential.user;
       print(credential.user);
    } on FirebaseAuthException catch(e)
    {
      print(e.code);
      if(e.code == "user-not-found")
      {
        print("No User Found!");
        showCustomMessageDialog(
          context,
          "Error!",
          "No User Found!",
          ()=>{}
          );
      }else if(e.code == "network-request-failed"){
        showCustomMessageDialog(
          context,
          "Network Error!",
          "You are running on offline mode!",
          ()=>{
            
            
          }
          );
          
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {

   


    return  SafeArea(
        
        child: Scaffold(
          
          backgroundColor: Colors.white,
          body:SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
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
                        padding: EdgeInsets.only(top: 50,left: 15),
                        child: Text("hi ! welcome to myinsu ",
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        ),
                        //textAlign: TextAlign.center,
                        ),
                      ),
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.only(left: 50,right: 50),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                        decoration:  BoxDecoration(
                         color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(167, 125, 154, 0.2),
                                        blurRadius: 50.0,
                                        offset: Offset(0, 10)
                                      )
                                    ]
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email or Phone number",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: const Icon(Icons.mail,color: Color.fromARGB(255, 128, 93, 224),),
                        ),
                        scrollPadding: const EdgeInsets.only(bottom:40),
                        controller: emailContoller,
                      ),
                      
                    ),
                    ),
               
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 50,right: 50,top: 10),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                          decoration:  BoxDecoration(
                           color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                  BoxShadow(
                                  color: Color.fromRGBO(167, 125, 154, 0.2),
                                  blurRadius: 50.0,
                                  offset: Offset(0, 10)
                                  )
                              ]
                        ),
                        child: TextField(
                            decoration:const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                                    hintStyle: TextStyle(color: Color.fromARGB(255, 189, 189, 189)),
                            prefixIcon: Icon(Icons.lock,color: Color.fromARGB(255, 128, 93, 224),),
                          ),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          scrollPadding:const EdgeInsets.only(bottom:10),
                          controller: passwordContoller,
                        ),
                        
                      ),
                    ),
                    const SizedBox(height: 32,),
                    Container(
                      child: RawMaterialButton(
                        
                        onPressed:() async{
                          User? login = await loginWithCredential(
                            email: emailContoller.text, 
                            password: passwordContoller.text, 
                            context: context);
                            print("login");
                            print(login);
                            if(login != null)
                            {

                              if(login.displayName==null){
                                  displayInputDialog(context);

                              }else{
                                 Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home(camera:widget.camera)),
                              );
                              }
                              
                             // // Navigator.of(context).
                            //  // pushReplacement(
                            //  //   MaterialPageRoute(builder: ((context) => const Home())));
                             }
                        },
                        
                        elevation: 0.0,
                        child: Container(
                          margin: const EdgeInsets.only(left: 47,right: 47),
                          padding: const EdgeInsets.all(20),
                              decoration:  BoxDecoration(
                                gradient:const LinearGradient(
                                colors: [
                                          Color.fromRGBO(143, 148, 251, 1),
                                          Color.fromRGBO(196, 91, 223, 0.6),
                                        ]
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                                
                              ),
                             
                        child: const Center(
                              child: Text("Login", 
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                        ),
                        
                      ),
                     ),
                                      
                                          
                                        
                    ),
                    const SizedBox(height: 10,), 
                    const Text("forgot password",
                    style: TextStyle(color: Color.fromARGB(255, 54, 51, 218)),
                    ),
                    const SizedBox(height: 10,),
                    const Icon(
                      Icons.fingerprint,
                      color: Colors.green,
                      size: 45.0,
                    ),
                  
                
                 
               
                   
                  
                ],
                
              ),
            ),
          )
        ),
      );
    
  }
  void updateDisplayName(String newName) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updateDisplayName(newName);
      user = FirebaseAuth.instance.currentUser; 

      print('Display name updated to: ${user?.displayName}');
    } else {

    }
  } catch (e) {
    print('Error updating display name: $e');
  }
}
Future<void> displayInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Display Name'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Enter your name"),
          ),
          actions: <Widget>[
            RawMaterialButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home(camera:widget.camera)),
                              );
              },
            ),
            RawMaterialButton(
              child: const Text('OK'),
              onPressed: () {
                updateDisplayName(_textFieldController.text);
                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home(camera:widget.camera)),
                              );
              },
            ),
          ],
        );
      },
    );
  }
}