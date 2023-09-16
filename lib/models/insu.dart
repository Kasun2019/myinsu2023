import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Insu{

  late Int id ;
  String policyNumber = "";
  String cType = "";
  late double cLatitude;
  late double cLongitude;

  late DocumentReference documentref ;

  Insu({required this.id,required this.policyNumber,required this.cType,required this.cLatitude,required this.cLongitude});

  Insu.fromMap(Map<String,dynamic> map,{required this.documentref}){
      
      id = map["id"];
      policyNumber = map["policyNumber"];
      cType = map["cType"];
      cLatitude = map["cLatitude"];
      cLongitude = map["cLongitude"];
  }
  Insu.fromSnapshot(DocumentSnapshot snapshot)
  :this.fromMap(snapshot.data as Map<String, dynamic>, documentref: snapshot.reference);

  // toJson(){

  //   return {'code':code,'name':name,'address':address};

  // }

}