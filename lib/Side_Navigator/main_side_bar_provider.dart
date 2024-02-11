import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import '../Repository/log_debugger.dart';
import '../Repository/repository.dart';
class MainSideBarInfo extends ChangeNotifier{

  Repository _repo=Repository();
  Map<String,dynamic>? map;
  String _fullName ='';
  String _phone='';
  String _imgString ='';
  String get fullName =>_fullName;
  String get imgString => _imgString;
  String get phone => _phone;

  setFullName(String fn,String ln){
    _fullName = '${fn} ${ln}';
    notifyListeners();
  }
  setPhone(String n){
    _phone=n;
    notifyListeners();
  }
  setImgString(String n){
    _imgString=n;
    notifyListeners();
  }
  Future updateInfo() async {
    try{

      final response  = await _repo.userInfo();
      map = response;
      notifyListeners();
      LogDebugger.instance.i(map);
      print(map);


    }on Exception {
      rethrow;
    }

    setPhone(map!['data']['phone']);
    notifyListeners();
    setImgString(map!['data']['image']);
    notifyListeners();
    print('image string is ${imgString}');
    setFullName(map!['data']['f_name'], map!['data']['l_name']);
    notifyListeners();
  }
}