import 'package:flutter/material.dart';

class SignInInfo extends ChangeNotifier{

  String _phoneNumber='';
  String get phoneNumber => _phoneNumber;
  setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }
  String _password='';
  String get password => _password;
  setPassword(String pass) {
    _password = pass;
    notifyListeners();
  }

}