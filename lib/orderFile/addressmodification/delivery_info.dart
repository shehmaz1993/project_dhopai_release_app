import 'package:dhopai/Repository/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryInfo extends ChangeNotifier{
  Repository _repo=Repository();
  Map<String,dynamic>? map;
  List<dynamic> _serviceArea =[];
  List<dynamic> _label =[];
  List<dynamic> _zones=[];
  bool _isSelectedArea=false;
  bool _isSelectedZone=false;
  bool _isSelectedLabel=true;
  int? _selectedAreaId;
  int? _selectedZoneId;
  int? _labelId;
  int? _addressId;
  String _labelName='';
  String? _zone;
  String? _selectedAreaName;
  List  get serviceArea => _serviceArea;
  List get label =>_label;
  List get zones=>_zones;
  setZones(List<dynamic> lst){
    _zones=lst;
    notifyListeners();
  }
  bool get isSelectedArea =>_isSelectedArea;
  setIsSelectedArea(bool val){
    _isSelectedArea=val;
    notifyListeners();
  }
  bool get isSelectedZone =>_isSelectedZone;
  setIsSelectedZone(bool val){
    _isSelectedZone=val;
    notifyListeners();
  }
  bool get isSelectedLabel =>_isSelectedLabel;
  setIsSelectedLabel(bool val){
    _isSelectedLabel=val;
    notifyListeners();
  }
  int? get selectedAreaId =>_selectedAreaId;
  setAreaId(int id){
    _selectedAreaId=id;
    notifyListeners();
  }
  int? get selectedZoneId =>_selectedZoneId;
  setZoneId(int id){
    _selectedZoneId=id;
    notifyListeners();
  }
  int? get labelId =>_labelId;
  setLabelId(int id){
    _labelId=id;
    notifyListeners();
  }
  int? get addressId =>_addressId;
  setAddressId(int id){
    _addressId=id;
    notifyListeners();
  }
  String? get labelName=>_labelName;
  setLabelName(String arName){
    _labelName=arName;
    notifyListeners();
  }
  String? get selectedAreaName=>_selectedAreaName;
  setAreaName(String? arName){
    _selectedAreaName=arName;
    notifyListeners();
  }
  String? get zone=>_zone;
  setZoneName(String? zName){
    _zone=zName;
    notifyListeners();
  }
  String _city='';
  String get city => _city;
  setCity(String cityInfo) {
    _city = cityInfo;
    notifyListeners();
  }
  String _postCode='';
  String get postCode => _postCode;
  setPostCode(String pass) {
    _postCode = pass;
    notifyListeners();
  }
  String _street='';
  String get street => _street;
  setStreet(String pass) {
    _street='';
    notifyListeners();
    _street = pass;
    notifyListeners();
    print('after modify delivery $_street');
  }

  Future getAllServiceAreasAndZones() async {
    final response= await _repo.getServiceAreaData();
    _serviceArea=response;
    notifyListeners();
    print('service areas are ${_serviceArea=response}');
  }
  Future getLabels() async {
    final response= await _repo.getLabelData();
    _label=response;
    notifyListeners();
    print('labels are $_label');
  }
  Future getInitialDropDownValues(context) async{


    try {
      final response  = await _repo.deliveryAddressShow();
      map = response;
      print(map);
      print(map.runtimeType);
      notifyListeners();
      print('map data are $map ');
    }
    on Exception {
      rethrow;
    }


    if(serviceArea.isNotEmpty){
      for(int i=0;i<serviceArea.length;i++){
        if(serviceArea[i]['name']==map!['area']['name']){

          setAreaId(map!['area']['id']);;
          notifyListeners();
          setAreaName(map!['area']['name']);
          notifyListeners();
          setIsSelectedArea(true);
          setZones(serviceArea[i]['zones']);
          print('Zones are ${zones}');
        }
      }

      setIsSelectedArea(true);
    }
    if(zones.isNotEmpty){
      for(int i=0;i<zones.length;i++){
        if(zones[i]['title']==map!['zone']['title']){

          setZoneId(map!['zone']['id']);
          notifyListeners();
          print(selectedZoneId);
          setZoneName(map!['zone']['title']);
          notifyListeners();
          print(zone);
          break;
        }
      }
      setIsSelectedZone(true);
    }
   // setZoneName(map!['zone']['title']);
    //notifyListeners();
    //print(zone);
    //setZoneId(map!['zone']['id']);
    //notifyListeners();
    //print(selectedZoneId);

    setCity(map!['city']);
    notifyListeners();
    print(city);
    setPostCode(map!['zip'].toString());
    notifyListeners();
    print(postCode);
    setStreet(map!['address_line_1']);
    notifyListeners();
    print(street);
    
  }

  settingInitialDropdownValues(){
    setLabelName(map!['labels']['lable']);
    notifyListeners();
    print(labelName);
    setLabelId(map!['labels']['id']);
    notifyListeners();
    print(labelId);
    setIsSelectedLabel(true);
    if(serviceArea.isNotEmpty){
      for(int i=0;i<serviceArea.length;i++){
        if(serviceArea[i]['name']==map!['area']['name']){
          setAreaId(serviceArea[i]['id']);
          notifyListeners();
          setAreaName(serviceArea[i]['name']);
          notifyListeners();
          setZones(serviceArea[i]['zones']);
          notifyListeners();
          print('Zones are ${zones}');
        }
      }

      setIsSelectedArea(true);
    }
    if(zones.isNotEmpty){
      for(int i=0;i<zones.length;i++){
        if(zones[i]['title']==map!['zone']['title']){
          setZoneId(zones[i]['id']);
          notifyListeners();
          print(selectedZoneId);
          setZoneName((zones[i]['title']));
          notifyListeners();
          print(zone);
          break;
        }
      }
      setIsSelectedZone(true);
    }
    setCity(map!['city']);
    notifyListeners();
    print(city);
    setPostCode(map!['zip'].toString());
    notifyListeners();
    print(postCode);
    setStreet('');
    notifyListeners();
    setStreet(map!['address_line_1']);
    notifyListeners();
    print(street);

  }


}