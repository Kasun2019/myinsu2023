

//import 'package:cloud_firestore/cloud_firestore.dart';

class Insu{

  late int id ;
  String policyNumber = "";
  String cType = "";
  late double cLatitude;
  late double cLongitude;
  late String vehicleNumber;
  late String vehicleChassis;
  late String effectiveDate;

  //late DocumentReference documentref ;

  Insu({required this.id,required this.policyNumber,required this.cType,required this.cLatitude,required this.cLongitude,required this.vehicleNumber,required this.vehicleChassis,required this.effectiveDate});

  Insu.fromMap(Map<String,dynamic> map,//{required this.documentref}
  ){
      
      id = map["id"];
      policyNumber = map["policyNumber"];
      cType = map["cType"];
      cLatitude = map["cLatitude"];
      cLongitude = map["cLongitude"];
      cLongitude = map["vehicle_number"];
      cLongitude = map["vehicle_chassis"];
      cLongitude = map["effective_date"];
  }
  // Insu.fromSnapshot(DocumentSnapshot snapshot)
  // :this.fromMap(snapshot.data as Map<String, dynamic>, documentref: snapshot.reference);

  // toJson(){

  //   return {'code':code,'name':name,'address':address};

  // }

}