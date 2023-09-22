
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:insurtechmobapp/SqlLiteDB.dart';
import 'package:insurtechmobapp/conectivityInt.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Mycart extends StatefulWidget {
  const Mycart({super.key});
  
  @override
  State<Mycart> createState() => _MycartState();
}

class _MycartState extends State<Mycart> {

late Connectivity _connectivity;
late Stream<ConnectivityResult> _connectivityStream;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
      updateWhenOnline();
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
             
          }
    }               
 

}

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      fetchData();
    });
  }

  void deleteInsu(String docId) async {
  final collectionRef = FirebaseFirestore.instance.collection('insu');
  Database? db =  await SqlLiteDB.instance.db;
  try {

    await db!.delete(
      'insu',
      where: 'id = ?',
      whereArgs: [docId],
    );
    await collectionRef.doc(docId).delete();

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
    });

    print('Record deleted successfully.');
  } catch (e) {
    print('Error deleting  $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
            // Add your sync button here
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: () {
                updateWhenOnline();
              },
            ),
          ],
      ),
      body: RefreshIndicator(
          onRefresh: _handleRefresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('OOPS ! : ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return Card(
                    elevation : 5,
                    child: ListTile(
                      leading: item['offline'] == 1 ? Icon(Icons.car_repair,color: Colors.red,):Icon(Icons.car_repair,color: Colors.green,),
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
                             deleteInsu(item['id']);
                            },
                            icon: const Icon(Icons.delete,color: Color.fromARGB(255, 177, 124, 120),),
                          ),
                        ),
                        ]
                      ),
                      onTap: () {

                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchData() async {

  try {
    //bool conStatus = await ConnectivityCheck.instance.status;
   /// List<Map<String, dynamic>> dummy;
   /// 
    Database? db =  await SqlLiteDB.instance.db;
    

    return await db!.rawQuery('select i.* from insu i'); 

  } catch (e) {
    print('Error fetching data: $e');
    return [];
  }
}



