import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SignUpInfo extends ChangeNotifier{

  String _name='';
  String get name=>_name;
   setName(String name){
     _name=name;
     notifyListeners();
   }
   String _phoneNumber='';
   String get phoneNumber=>_phoneNumber;
   setPhoneNumber(String num){
     _phoneNumber=num;
     notifyListeners();
   }
  String _email='';
  String get email=>_email;
  setEmail(String mail){
    _email=mail;
    notifyListeners();
  }
  String _password='';
  String get password=>_password;
  setPassword(String pass){
    _password=pass;
    notifyListeners();
  }
  String _confirmPassword='';
  String get confirmPassword=>_confirmPassword;
  setConfirmPassword(String confirmPass){
    _confirmPassword=confirmPass;
    notifyListeners();
  }
}