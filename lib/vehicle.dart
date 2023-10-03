
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insurtechmobapp/component/CustomMessageDialog%20.dart';
import 'package:insurtechmobapp/controller/SqlLiteDB.dart';
import 'package:insurtechmobapp/controller/conectivityInt.dart';
import 'package:insurtechmobapp/home.dart';
import 'package:insurtechmobapp/imageGallery.dart';
import 'package:insurtechmobapp/models/customer.dart';
import 'package:insurtechmobapp/models/insu.dart';
import 'package:insurtechmobapp/photoUpload.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:intl/intl.dart';


class Vehicle extends StatefulWidget {
  const Vehicle({super.key,required this.camera});
final CameraDescription camera;
  @override
  State<Vehicle> createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //List<String> itemsList = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  String _dropDownValue = "Front";
  TextEditingController customerCode = TextEditingController();
  TextEditingController customerName = TextEditingController();
  TextEditingController customerAddress = TextEditingController();
  TextEditingController vehicleNumber = TextEditingController();
  TextEditingController vehicleChassis = TextEditingController();
  TextEditingController effectiveDate = TextEditingController();


  String collectionName = "Customer";
  late Customer customer;

  void findCustomer(String userInput) async{

    bool conStatus = await ConnectivityCheck.instance.status;
    Database? db =  await SqlLiteDB.instance.db;

    if(conStatus){
          final collectionRef = FirebaseFirestore.instance.collection(collectionName);
          
                final querySnapshot = await collectionRef
                  .where('code', isEqualTo: userInput)
                  .get();

                if (querySnapshot.docs.isNotEmpty) {
                final data = querySnapshot.docs.first.data();
                final customerNameData = data['name'];
                final customerAddressData = data['address'];
              
                setState(() {
                  customerName.text = customerNameData;
                  customerAddress.text = customerAddressData;
                  customer = Customer(code: userInput, name: customerNameData, address: customerAddressData,cType:_dropDownValue);
                });
              }
    }else if(db!.isOpen){
              String query = 'SELECT * FROM customers WHERE code = ? LIMIT 1';

             
              List<Map<String, dynamic>>? result = await db.rawQuery(query, [userInput]);

              if (result.isNotEmpty) {
                Map<String, dynamic> raw = result.first;
                
                final customerNameData1 = raw['name'];
                final customerAddressData1 = raw['address'];
              
                // Update the output TextField with the fetched data.
                setState(() {
                  customerName.text = customerNameData1;
                  customerAddress.text = customerAddressData1;
                  customer = Customer(code: userInput, name: customerNameData1, address: customerAddressData1,cType:_dropDownValue);
                });
              }
      
    }
    else {
      // Clear the output TextField if no data is found.
      customer = Customer(code: "", name: "", address: "",cType :"");
      setState(() {
        customerName.text = "";
        customerAddress.text = "";
        customer = Customer(code: "", name: "", address: "",cType :"");
      });
    }

  
  }
   Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

    if (picked != null && picked != DateTime.now()) {
      // Update the text field with the selected date
      setState(() {
        effectiveDate.text = DateFormat('yyyy-MM-dd').format(picked); // Format the date as needed
      });
    }
  }
  


  @override
  Widget build(BuildContext context) {
   
    return  SafeArea(
      child: Scaffold(
          appBar: AppBar(
          title: const Text('Vehicle'),
          // Add a back button to the app bar
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Home(camera: widget.camera)),
              );
              
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
               key: _formKey, 
                child:Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Policy Number"),
                    controller: customerCode,
                    onChanged: (value) {
                      findCustomer(value);
                    },
                    // validator: (value) {
                    // if (value!.isEmpty) {
                    //   return 'Please enter your name';
                    // }
                    // return null;
                  //},
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Full Name"),
                    enabled: false,
                    controller: customerName,
                 
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Address"),
                    enabled: false,
                    controller: customerAddress,
                  ),
                  DropdownButton(
                          hint: _dropDownValue == null? Text('Dropdown'): Text(
                          _dropDownValue,
                          style: const TextStyle(color: Colors.blue),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: const TextStyle(color: Colors.blue),
                  items: ['Front', 'Rear', 'Right','Left','All'].map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        _dropDownValue = val!;
                      },
                    );
                  },
                  ),
                   Column(
                    children: [
                      Container(
                        width: 150,
                        child: TextFormField(
                              decoration: const InputDecoration(labelText: "Vehicle Number"),
                              controller: vehicleNumber,
                                            
                        ),
                      ),
                      Container(
                        width: 150,
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Chassis Number"),
                          controller: vehicleChassis,
                                          
                        ),
                      ),
                      Container(
                        width: 150,
                        child: TextField(
                        controller: effectiveDate,
                        onTap: () => selectDate(context), // Display date picker when the field is tapped
                        readOnly: true, // Prevent manual text input
                        decoration: const InputDecoration(
                          hintText: 'Select a Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                                          ),
                      ),
                    ],
                   
                  ),
                  const SizedBox(height:17.0),
                  RawMaterialButton(
                        
                        onPressed:() async{
                          
                          try{
                            if(customer.name != ""){
                              Insu insu = Insu(id: 1, policyNumber: "", cType: "", cLatitude: 0, cLongitude: 0, vehicleNumber: vehicleNumber.text, vehicleChassis: vehicleChassis.text, effectiveDate: effectiveDate.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  PhotoUpload(camera: widget.camera,customer:customer,insu:insu)),
                              );
                            }
                          }catch(e){
                            showCustomMessageDialog(context, "warning!", "Enter Valied Policy Number!", ()=>{ });
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
                             
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined,color: Colors.white,),
                            SizedBox(width: 8.0),
                           Text("Pick From Camera", 
                                style: TextStyle(color: Colors.white, fontWeight: 
                                FontWeight.bold,fontSize: 17)),
                          ],  
                          ),
                        ),
                        
                      ),
                      const SizedBox(height:10.0),

                      RawMaterialButton(
                        
                        onPressed:() async{
                           Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  const ImageGallery()),
                              );   
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
                             
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_rounded,color: Colors.white,),
                            SizedBox(width: 8.0),
                           Text("Pick From Gallery", 
                                style: TextStyle(color: Colors.white, fontWeight: 
                                FontWeight.bold,fontSize: 17)),
                          ],  
                          ),
                        ),
                        
                      ),
                     
                     
                ],
              ),
              ),
            ),
        ),
      ),
    );
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


// listData(BuildContext context){
//   return StreamBuilder<QuerySnapshot>(
//     stream:findCustomer(),
//     builder: (context,snapshot){

//     }
//   );

// }
  
}