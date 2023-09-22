import 'package:connectivity/connectivity.dart';

class ConnectivityCheck{

ConnectivityCheck._privateConstructor();
  static final ConnectivityCheck instance = ConnectivityCheck._privateConstructor();

 
  Future<bool> get status async {
    
    //if (_status != null)return _status;

    
    return  await checkInternetConnectivity();
  }  



checkInternetConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
  
    return true;
  } else {
   
    return false;
  }
}


}


