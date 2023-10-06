
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:insurtechmobapp/controller/SqlLiteDB.dart';
import 'package:insurtechmobapp/controller/conectivityInt.dart';
import 'package:insurtechmobapp/viewEvent.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';

class Mycart extends StatefulWidget {
  const Mycart({super.key});
  
  @override
  State<Mycart> createState() => _MycartState();
}

class _MycartState extends State<Mycart> {

FirebaseFirestore collectionRef = FirebaseFirestore.instance;
late int notificationCount=0;
@override
  void initState() {
   
    super.initState();
      updateWhenOnline();
   
   collectionRef.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
    checkOfflineCount();
  }

  
void checkOfflineCount() async{

  Database? db =  await SqlLiteDB.instance.db;
  List<Map<String, dynamic>> localData =  await db!.rawQuery('select * from insu where offline=1');
 setState(() {
   notificationCount = localData.length;
  print("notificationCount");
  print(notificationCount);
 });
  
}
  

void updateWhenOnline() async{
  bool conStatus = await ConnectivityCheck.instance.status;
 Fluttertoast.showToast(
                msg: "Sync Start",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM, 
                timeInSecForIosWeb: 1, 
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0,
              );
 
    if(conStatus){
      Database? db =  await SqlLiteDB.instance.db;
      List<Map<String, dynamic>> localData =  await db!.rawQuery('select * from insu where offline=1'); 
      DateTime now = DateTime.now();
      String currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);  
        final collectionRef = FirebaseFirestore.instance.collection('insu');

        

          if(localData.isNotEmpty){
            
            for(final mp in localData ){
            await collectionRef.add({
                          'policyNumber': mp['policyNumber'],
                          'cType': mp['cType'],
                          'cLatitude': mp['cLatitude'],
                          'cLongitude': mp['cLongitude'],
                          'vehicle_no':mp['vehicle_no'],
                          'chassis_number':mp['chassis_number'],
                          'effective_date':mp['effective_date'],
                          'submit_date':currentTime,
                          'status': "pending",
                          'dType': 0,
                        });
            }
            await db.delete('insu',
              where: 'offline = ?',
              whereArgs: [1],);

            Fluttertoast.showToast(
                msg: "Data sync success!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM, 
                timeInSecForIosWeb: 1, 
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0,
              );
             checkOfflineCount();
          }
    }               
 

}

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      //fetchData();
    });
  }

  void deleteInsu(String docId) async {
  
  final deleteData = collectionRef.collection('insu');
  Database? db =  await SqlLiteDB.instance.db;
  List<String> dataList = [];
  try {

    await db!.delete(
      'insu',
      where: 'id = ?',
      whereArgs: [docId],
    );
    await deleteData.doc(docId).delete();

      Fluttertoast.showToast(
                msg: "Record deleted successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM, 
                timeInSecForIosWeb: 1, 
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0,
              );
    setState(() {
      _handleRefresh();
      checkOfflineCount();
    });

    print('Record deleted successfully.');
  } catch (e) {
    print('Error deleting  $e');
  }
}

  // Stream<Object?>? fetchData() {
  //     final collectionRefs = collectionRef.collection('insu');
          
  //     final querySnapshot =  collectionRefs.snapshots();
    

  //   return querySnapshot; 
  // }


  @override
  Widget build(BuildContext context) {
    print("notificationCount2222222");
  print(notificationCount);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
            // Add your sync button here
             Column(
              children: [
               Stack(
                 children: [
                   IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed: () {
                      updateWhenOnline();
                    },
                    ),
                 
                    if (notificationCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              notificationCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                        ),
                  ]
               ),
              ]
             ),
          ],
          
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
                    print(item);
                    return Card(
                      elevation : 5,
                      child: ListTile(
                        leading: checkDamageType(item['dType']),
                        title: Text(item['policyNumber']), 
                        subtitle: Text("Policy No: "+item['vehicle_no']+" ,\nChassis No: "+item['chassis_number']+",\nDate Submit: "+item['effective_date']), 
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:[ Text(item['status'],style:TextStyle(
                            color:item['status']=="pending"?Colors.amber:Colors.green
                            )
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                               deleteInsu(documents[index].id);
                              },
                              icon: const Icon(Icons.delete,color: Color.fromARGB(255, 177, 124, 120),),
                            ),
                          ),
                          ]
                        ),
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  ViewEvent(item:item),
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
  Icon checkDamageType(int dType){

   
     
   

    switch (dType) {

      case 1 :
        return Icon(Icons.car_repair,color: Colors.red,);
      case 2 :
        return Icon(Icons.car_repair,color: Colors.amber,);
      case 3 :
        return Icon(Icons.car_repair,color: Colors.green,);

      default:
        return Icon(Icons.car_repair,color: Color.fromARGB(255, 170, 171, 172),);

    }
  }
}

 



