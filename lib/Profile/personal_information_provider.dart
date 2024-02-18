import 'package:flutter/material.dart';

import '../Products/search_product.dart';
import '../Repository/log_debugger.dart';
import '../Repository/repository.dart';

class PersonalUpdateInfo extends ChangeNotifier{
  Map<String,dynamic>? map;


  String _phoneNumber='';
  String get phoneNumber => _phoneNumber;
  setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }
  String _firstName='';
  String get firstName => _firstName;
  setFirstName(String pass) {
    _firstName = pass;
    notifyListeners();
  }
  String _lastName='';
  String get lastName => _lastName;
  setLastName(String pass) {
    _lastName = pass;
    notifyListeners();
  }

  Future updateInfo() async {
    Repository _repo=Repository();
    try{

      final response  = await _repo.userInfo();
      map = response;
      notifyListeners();
      LogDebugger.instance.i(map);
      print(map);


    }on Exception {
      rethrow;
    }
    print(map!['data']['f_name']);
    setFirstName(map!['data']['f_name']);
    notifyListeners();
    print(phoneNumber);
    setLastName(map!['data']['l_name']);
    notifyListeners();
    print(firstName);
    setPhoneNumber(map!['data']['phone']);
    notifyListeners();
    print(lastName);

  }

}