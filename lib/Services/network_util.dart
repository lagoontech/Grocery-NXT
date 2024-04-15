import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {

  static ConnectivityResult ?connectivityResult;
  StreamSubscription<List<ConnectivityResult>> ?connectionStream;

  //
  bool isConnected(){

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