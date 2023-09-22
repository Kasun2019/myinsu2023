//import 'package:cloud_firestore/cloud_firestore.dart';

class Customer{

  String code = "";
  String name = "";
  String address = "";
  String cType = "";

  //late DocumentReference documentref ;

  Customer({required this.code,required this.name,required this.address,required this.cType});

  Customer.fromMap(Map<String,dynamic> map,//{required this.documentref}
  ){

      code = map["code"];
      name = map["name"];
      address = map["address"];
      cType = "Front";
  }
  // Customer.fromSnapshot(DocumentSnapshot snapshot)
  // :this.fromMap(snapshot.data as Map<String, dynamic>, documentref: snapshot.reference);

  // toJson(){

  //   return {'code':code,'name':name,'address':address};

  // }

}