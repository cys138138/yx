import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
class TsUtils{
  static showShort(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: const Color(0xFF000000),
        textColor: const Color(0xFFffffff)
    );
  }
}