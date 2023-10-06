

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:insurtechmobapp/component/CTextComponent.dart';

class ViewEvent extends StatelessWidget {
  const ViewEvent({super.key,required this.item});
  final item;

  Future<List<String>> getImagFromFirebaseStorage() async {
  final List<String> imageUrls = [];

  final Reference storageRef = FirebaseStorage.instance.ref().child('');

  final ListResult result = await storageRef.listAll();

  for (final Reference ref in result.items) {
    print(ref.fullPath);
    if(ref.fullPath.contains(item['policyNumber'])){
    final url = await ref.getDownloadURL();
        imageUrls.add(url);
    }
   
  }


  return imageUrls;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Details'),
      ),
      body: 
      Center(
        child: Container(
          padding: const EdgeInsets.all(5), // Set the width of the card
          child:  Column(
            children:[
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 149, 195, 233), Color.fromARGB(255, 214, 119, 218)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16), // Add padding to the card content
                     // width: 300, // Set the width of the card
                      child:  Column(
                        children: [
                            CustomText(cLabel:'Policy Number',cVal:item['policyNumber'],enabled:false),
                            const SizedBox(height:7.00),
                            CustomText(cLabel:'Vehicle Number',cVal:item['vehicle_no'],enabled:false),
                            const SizedBox(height:7.00),
                            CustomText(cLabel:'Chassis Number',cVal:item['chassis_number'],enabled:false),
                            const SizedBox(height:7.00),
                            CustomText(cLabel:'Effective Date',cVal:item['effective_date'],enabled:false),
                            const SizedBox(height:7.00),
                            CustomText(cLabel:'Status',cVal:item['status'],enabled:false)
                        ]
                      )
                  ),
                    
                ),
              ),

             const Text("Document"),
               FutureBuilder(
                future: getImagFromFirebaseStorage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null || snapshot.data == [] ) {
                    return const Text('No Image Found!');
                  } else {
                    final List<String> imageUrls = snapshot.data!;
                    return Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, 
                        ),
                        
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Set the border color here
                                width: 2.0, // Set the border width here
                              ),
                            ),
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
               ),
              
            ]
          )
        ),
      )
    );
  }
}