import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {

  static ConnectivityResult ?connectivityResult;
  StreamSubscription<List<ConnectivityResult>> ?connectionStream;

  //
  bool isConnected(){

    Connectivity().checkConnectivity().then((value){
      connectivityResult = value[0];
    });
    if(connectivityResult!=ConnectivityResult.none){
      return true;
    }
    return false;
  }

  //
  Future<bool> checkConnection() async {

    await Connectivity().checkConnectivity().then((value){
      connectivityResult = value[0];
    });
    if(connectivityResult!=ConnectivityResult.none){
      return true;
    }
    return false;
  }

  //
  listenForConnectionChanges(){

    Connectivity connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((event) {
      connectivityResult = event[0];
    });
  }

}