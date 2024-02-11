import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
class Utils{


  void toastMessage(String message){

      Fluttertoast.showToast(

          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[200],
          textColor:Colors.white,
          fontSize: 16.0,
      );

    }
  int getColorFromHex(String hexColor) {
      hexColor = hexColor.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
          hexColor = "FF" + hexColor;
      }
      return int.parse(hexColor, radix: 16);
  }
  void launchURL(String url) async {
    final Uri _url = Uri.parse("tel://${url}");
    launchUrl (_url);
  }


}
