import 'package:dhopai/orderFile/order_track_folder/customer_products/customer_product_model_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Repository/log_debugger.dart';
import '../../Repository/repository.dart';

class OrderTrackProvider extends ChangeNotifier{

  Repository _repo=Repository();
  Map<String,dynamic>? map;
  int? _id;
  String? _ref;
  String? _orderId;
  String? _staffIdP;
  String? _charge;
  String? _status;
  String? _otk;
  String? _createDate;
  String? _updateDate;
  int? _staffId;
  String? _fName;
  String? _lName;
  String? _nid;
  String? _phone;
  String? _typeId;
  String? _deviceToken;
  String? _rfName;
  String? _rlName;
  String? _rnid;
  String? _rphone;
  List _statusList=[];
  List<CustomerProducts> _items=[];
  String? _amount;
  //String? charge;
  String? _discount;
  String? _pickUp;
  String? _delivery;
  String? _hPrice;
  int? get id =>_id;
  String? get ref => _ref;
  String? get orderId => _orderId;
  String? get staffIdp => _staffIdP;
  String? get charge => _charge;
  String? get status => _status;
  String? get otk => _otk;
  String? get createDate => _createDate;
  String? get updateDate => _updateDate;
  int? get staffId => _staffId;
  String? get lName => _lName;
  String? get fName => _fName;
  String? get nid => _nid;
  String? get phone => _phone;

  String? get typeId => _typeId;
  String? get deviceToken => _deviceToken;

  String? get rlName => _rlName;
  String? get rfName => _rfName;
  String? get rnid => _rnid;
  String? get rphone => _rphone;

  String? get amount => _amount;
  String? get hPrice => _hPrice;
  String? get discount => _discount;
  String? get pickUp => _pickUp;
  String? get delivery => _delivery;
  List? get statusList => _statusList;
  List? get items => _items;

  setId(int id) {
    _id = id;
    notifyListeners();
  }
  setRef(String ref) {
    _ref = ref;
    notifyListeners();
  }
  setOrderId(String oid) {
    _orderId = oid;
    notifyListeners();
  }
  setStaffIdp(String idp) {
    _staffIdP = idp;
    notifyListeners();
  }
  setCharge(String charge) {
    _charge = charge;
    notifyListeners();
  }
  setStatus(String status) {
    _status = status;
    notifyListeners();
  }
  setOtk(String otk) {
    _otk = otk;
    notifyListeners();
  }
  setCreateDate(String date) {
    var mod=formatDateTime(date);
    _createDate = mod;
    notifyListeners();
  }
  setUpdateDate(String date) {
    var mod=formatDateTime(date);
    _updateDate = mod;
    notifyListeners();
  }
  setStaffId(int sid) {
    _staffId = sid;
    notifyListeners();
  }
  setfName(String fname) {
    _fName = fname ;
    notifyListeners();
  }
  setlName(String lname) {
    _lName = lname;
    notifyListeners();
  }
  setNid(String nid) {
    _nid = nid;
    notifyListeners();
  }
  setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }
  setTypeId(String tid) {
    _typeId = tid;
    notifyListeners();
  }
  setDeviceToken(String dk) {
    _deviceToken = dk;
    notifyListeners();
  }
  setAmount(String amount) {
    _amount = amount;
    notifyListeners();
  }
  setHPrice(String amount) {
    _hPrice = amount;
    notifyListeners();
  }
  setDiscount(String discount) {
    _discount = discount;
    notifyListeners();
  }
  setPickUp(String pick) {
    _pickUp = pick;
    notifyListeners();
  }
  setDelivery(String delivery) {
    _delivery = delivery;
    notifyListeners();
  }
  setRfName(String fname) {
    _rfName = fname ;
    notifyListeners();
  }
  setRlName(String lname) {
    _rlName = lname;
    notifyListeners();
  }
  setRNid(String nid) {
    _rnid = nid;
    notifyListeners();
  }
  setRPhone(String phone) {
    _rphone = phone;
    notifyListeners();
  }
  String formatDateTime(String date){
    var parsedDate = DateTime.parse(date);
    String formattedDate = DateFormat.yMMMEd().format(parsedDate);
    return formattedDate;
  }

  Future updateOrderInfo(int? orderId) async {
    try{

      final response  = await _repo.orderStatus(orderId);
      map = response;
      notifyListeners();
      LogDebugger.instance.i(map);
      print(map);

    }on Exception {
      rethrow;
    }
    setId(map!['data']['courier']['id']??0);
    print(id);
    setRef(map!['data']['courier']['ref']??'');
    print(ref);
    setOrderId(map!['data']['courier']['order_id']??'');
    print(orderId);
    setStaffIdp(map!['data']['courier']['staff_id_p']??'');
    print(staffIdp);
    setCharge(map!['data']['courier']['charge']??'');
    print(charge);
    setStatus(map!['data']['courier']['status']??'');
   // statusList!.add(status);
    notifyListeners();
    print(status);
    setOtk(map!['data']['courier']['otk']??'');
    print(otk);
    setCreateDate(map!['data']['courier']['created_at']??'');
    print(createDate);
    setUpdateDate(map!['data']['courier']['updated_at']??'');
    print(updateDate);
    if(map!['data']['courier']['staff_p']!=null){
      setStaffId(map!['data']['courier']['staff_p']['id']??0);
      print(staffId);
      setfName(map!['data']['courier']['staff_p']['f_name']??' ');
      print(fName);
      setlName(map!['data']['courier']['staff_p']['l_name']??' ');
      print(lName);
      setNid(map!['data']['courier']['staff_p']['nid']??' ');
      print(nid);
      setPhone(map!['data']['courier']['staff_p']['phone']??' ');
      print(phone);
      setTypeId(map!['data']['courier']['staff_p']['type_id']??' ');
      print(typeId);
      setDeviceToken(map!['data']['courier']['staff_p']['device_token']??' ');
      print(deviceToken);
    }
    if(map!['data']['courier']['staff_d']!=null){
      setRfName(map!['data']['courier']['staff_d']['f_name']??' ');
      print(rfName);
      setRlName(map!['data']['courier']['staff_d']['l_name']??' ');
      print(rlName);
      setRNid(map!['data']['courier']['staff_d']['nid']??' ');
      print(rnid);
      setRPhone(map!['data']['courier']['staff_d']['phone']??' ');
      print(rphone);

    }
    _statusList.clear();
    for(int i=0;i<map!['data']['courier']['clogs'].length;i++){
      _statusList.add(map!['data']['courier']['clogs'][i]['courier_status_id']);
      notifyListeners();
    }
    LogDebugger.instance.i(statusList);
    if(map!['data']['order']!=null){
      setAmount(map!['data']['order']['amount']);
      print(amount);
      setDiscount(map!['data']['order']['discount']==null||map!['data']['order']['discount']=='0'?0:map!['data']['order']['discount']);
      print(discount);
      setPickUp(map!['data']['order']['pickup_address']);
      print(pickUp);
      setDelivery(map!['data']['order']['delivery_address']);
      print(delivery);
    }
    print(map!['data']['items']);
    List<dynamic> ls = map!['data']['items'];
    LogDebugger.instance.i(ls);
    _items= await ls.map((element) => CustomerProducts.fromJson(element)).toList();
    notifyListeners();
    print('items are $items');

  }

 /*Future<List<CustomerProducts>>  fetchPosts(List<dynamic> ls)async{
    try{
      //log(response.data);
      List<dynamic> lst= await ls;
      return lst.map((element) => CustomerProducts.fromJson(element)).toList();
    }
    catch(ex){
      throw  ex;
    }
  }*/



}