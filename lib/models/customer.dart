import 'package:cloud_firestore/cloud_firestore.dart';

class Customer{

  String code = "";
  String name = "";
  String address = "";

  late DocumentReference documentref ;

  Customer({required this.code,required this.name,required this.address});

  Customer.fromMap(Map<String,dynamic> map,{required this.documentref}){

      code = map["code"];
      name = map["name"];
      address = map["address"];
  }
  Customer.fromSnapshot(DocumentSnapshot snapshot)
  :this.fromMap(snapshot.data as Map<String, dynamic>, documentref: snapshot.reference);

  toJson(){

    return {'code':code,'name':name,'address':address};

  }

}