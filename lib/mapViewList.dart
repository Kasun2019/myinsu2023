
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:insurtechmobapp/mapView.dart';

class MapViewList extends StatefulWidget {
  const MapViewList({super.key});
  
  @override
  State<MapViewList> createState() => _MapViewListState();
}

class _MapViewListState extends State<MapViewList> {


FirebaseFirestore collectionRef = FirebaseFirestore.instance;
late int notificationCount=0;
@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        
      ),
      body: StreamBuilder(
        stream: collectionRef.collection('insu').snapshots(),
        builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('OOPS! : ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No data available');
        }
       
        final documents = snapshot.data!.docs; 
        
        return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final item = documents[index].data();
                    double cLatitude = double.parse(item['cLatitude'].toString());
                    double cLongitude = double.parse(item['cLongitude'].toString());
                    return Card(
                      elevation : 5,
                      child: ListTile(
                        leading: const Icon(Icons.location_pin),
                        title: Text(item['policyNumber']), 
                        subtitle: Text("Vehicle No: "+item['vehicle_no']), 
                        onTap: () {
                           Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  MapLocView(latitude:cLatitude,longitude:cLongitude),
                        ));
                        },
                      ),
                    );
                  },
        
                );
        }
      )
            
    );
  }
  
}

 



