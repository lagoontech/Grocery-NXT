import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil{

  showToast({
    Color ?color,
    String message = "",
    bool noInternet = false}){
    Fluttertoast.showToast(
        msg: noInternet?"No Internet Connection" :message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: noInternet?Colors.black:color ?? Colors.red,
        textColor: Colors.white,
        fontSize: 14
    );
  }

}