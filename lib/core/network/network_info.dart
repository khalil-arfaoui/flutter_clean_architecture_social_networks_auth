import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      ConnectivityResult connectivityResult =
          await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        final result = await InternetAddress.lookup('example.com');
        print(result);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          return true;
        }
        return false;
      } else
        return false;
    } on PlatformException catch (e) {
      print(e.toString());
      return false;
    } on SocketException catch (e) {
      print(e.toString());
      print('not connected');
      return false;
    }
  }
}
