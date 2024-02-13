import 'dart:convert';
import 'dart:io';

import 'package:dhopai/Products/search_model_class.dart';
import 'package:dhopai/Repository/log_debugger.dart';
import 'package:dhopai/promotion/promo_model_class/offer_model_class.dart';
import 'package:dhopai/promotion/promo_model_class/support_catagory_model.dart';
import 'package:dhopai/utils/helper_class.dart';
import 'package:dhopai/orderFile/DeliveyModelClasses/deliveryModelClass.dart';
import 'package:dhopai/orderFile/addressmodification/addressmodificationfordeliveryUPDATE.dart';
import 'package:dhopai/orderFile/cartProductModel.dart';
import 'package:dhopai/orderFile/order_model_classes/all_order_model_class.dart';
import 'package:dhopai/orderFile/order_model_classes/top_five_order.dart';
import 'package:dhopai/promotion/promo_model_class/promotional_model_class.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../orderFile/order_model_classes/past_order_view_model_class.dart';
import '../promotion/promo_model_class/support_model_class.dart';
import '../push-notification_services/firebase.dart';



class Repository {


  Future<bool> registerInfo(String phoneNumber, String password) async {
    print('inside function');
    final response = await http.post(
        Uri.parse('https://api.dhopai.com/api-customer/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phoneNumber,
          'password': password
        })

    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var user_info = json.decode(response.body);
        LogDebugger.instance.i(user_info);

        print('received data $user_info');
        /* dbHelper?.insert(
          UserModel(
            token: user_info['token'],
            customerId: user_info['customer_id'],
            phone: user_info['phone']
          )
        ).then((value){
          print('user added $value');
        }).onError((error, stackTrace){
          print(error.toString());
        });*/
        // return UserModel.fromJson(user_info[0]);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (user_info!['message'] == 'Customer register successfully.') {
          prefs.setInt('customer_id', user_info!['data']['customer_id']);
          prefs.setInt('pickUpId', user_info!['data']['pickup_id']);
          prefs.setInt('shippingId', user_info!['data']['shipping_id']);
          prefs.setString('token', user_info!['data']['token']);
          prefs.setString('phone', user_info!['data']['phone']);
          await FirebaseApi().enableNotification();
        }

        return user_info!['success'];
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<List<dynamic>> fetchServices() async {
    String url = Helper.BASE_URL + Helper.extDefault + 'services';
    var result = await http.get(Uri.parse(url));
    return jsonDecode(result.body)['data'];
  }

  Future addCart(int customerId, int serviceId, int productId, int quantity,
      int price, String token, int hPrice) async {
    print('inside function');
    //'7|kBR2OMnoO2nMafSSicOmKuJ6l31YFae51fm8Bwbz'
    //'https://api.dhopai.com/api-customer/cart_create'
    String url = Helper.BASE_URL + Helper.extCustomer + 'cart_create';
    final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode(<String, dynamic>{
          'customer_id': customerId,
          'product_id': productId,
          'service_id': serviceId,
          'quantity': quantity,
          'price': price,
          'h_price': hPrice
        })
    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var user_info = json.decode(response.body);
        print('cart data $user_info');
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<CartProductModel> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Helper.BASE_URL + Helper.extCustomer +
        'cart/${prefs.getInt('customer_id')}';
    print(url);
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },

    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var cart_info = json.decode(response.body);
        print('cart data $cart_info');
        return CartProductModel.fromJson(cart_info);
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future updateQuantity(int quantity, int id) async {
    print('updating');
    print(id);
    //'https://api.dhopai.com/api-customer/cart_update'
    String url = Helper.BASE_URL + Helper.extCustomer + 'cart_update';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    EasyLoading.show(status: 'Updating...');
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: jsonEncode(<String, dynamic>{
        'cart_id': id,
        'quantity': quantity,
      }),
    );
    try {
      if (response.statusCode == 200) {
        // EasyLoading.showSuccess('Updating!');
        EasyLoading.dismiss();
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }

    // EasyLoading.dismiss();

  }


  Future deleteItem(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //https://api.dhopai.com/api-customer/cart_delete/
    print('deleting');
    print(id);
    print(prefs.getInt('customer_id'));
    String url = Helper.BASE_URL + Helper.extCustomer + 'cart_delete/$id';
    await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
    );

    //return response;
  }

  Future<Map> getUserInfo(String phone, String pass,
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //'https://api.dhopai.com/api-customer/login?phone=${phone}&password=${pass}'
    String url = Helper.BASE_URL + Helper.extCustomer +
        'login?phone=${phone}&password=${pass}';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        final Map userInfo = json.decode(response.body);
        LogDebugger.instance.i(userInfo);
        print('User data : $userInfo');
        prefs.remove('customer_id');
        prefs.remove('token');
        prefs.remove('phone');
        prefs.remove('pickUpId');
        prefs.remove('shippingId');
        if (userInfo['success'] == true) {
          prefs.setInt('customer_id', userInfo['data']['customer_id']);
          prefs.setString('token', userInfo['data']['token'].toString());
          prefs.setString('phone', userInfo['data']['phone'].toString());
          prefs.setInt('pickUpId', userInfo['data']['pickup']);
          prefs.setInt('shippingId', userInfo['data']['shipping']);
          await FirebaseApi().enableNotification();
        }

        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
        /* if (Navigator.canPop(context)) {
           Navigator.pop(context);
         } else {
           SystemNavigator.pop();
         }*/
        return userInfo;
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<int> storePickUpAddress(int areaId, int zoneId, int labelId,
      String streetAddress, String city, String zip,
      BuildContext context) async {
    print('in storing address method');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));

    String url = Helper.BASE_URL + Helper.extCustomer + 'pickup_address_store';
    EasyLoading.show(status: 'loading...');
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': prefs.getInt('customer_id'),
        'area_id': areaId,
        'zone_id': zoneId,
        'label_id': labelId,
        'street_address': streetAddress,
        'city': city,
        'zip': zip
      }),
    );
    try {
      if (response.statusCode == 200) {
        var addressInfo = json.decode(response.body);
        print('address data : $addressInfo');
        prefs.setInt('pickupAddressId', addressInfo['data']['id']);
        prefs.setBool('success', addressInfo['success']);
        // print('address id ${prefs.getInt('pickupAddressId')}');
        // print('address id ${prefs.getBool('success')}');
        EasyLoading.showSuccess('address saving!');
        return addressInfo['data']['id'];
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }

    // EasyLoading.dismiss();

  }

  Future<Map> updatePickUpAddress(int areaId, int zoneId, int labelId,
      String streetAddress, String city, String zip) async {
    print('in updating address method');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));
    /* print('area Id $areaId');
    print('zone Id $zoneId');
    print('label Id $labelId');
    print('street address $streetAddress');
    print('city $city');
    print('zip $zip');*/
    String url = Helper.BASE_URL + Helper.extCustomer + 'pickup_address_update';
    // EasyLoading.show(status: 'loading...');
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': prefs.getInt('customer_id'),
        'area_id': areaId,
        'zone_id': zoneId,
        'label_id': labelId,
        'street_address': streetAddress,
        'city': city,
        'zip': zip,
        'id': prefs.getInt('pickUpId')
      }),
    );
    try {
      if (response.statusCode == 200) {
        //EasyLoading.showSuccess('address updating!');
        EasyLoading.show(status: 'Updating...');
        var addressInfo = json.decode(response.body);
        print(' update pick up address data : $addressInfo');
        // log(addressInfo);
        //  Navigator.pop(context,true);
        return addressInfo;
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }

    // EasyLoading.dismiss();

  }

  Future<Map<String, dynamic>> EditPickUpAddress(BuildContext context,
      int addressId) async {
    print('in editing pick up address method');
    //'https://api.dhopai.com/api-customer/pickup_address_edit'

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));
    print(prefs.getInt('pickupId'));
    String url = Helper.BASE_URL + Helper.extCustomer + 'pickup_address_edit';

    // EasyLoading.show(status: 'loading...');
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: jsonEncode(<String, dynamic>{
        'id': prefs.getInt('customer_id'),

      }),
    );
    try {
      if (response.statusCode == 200) {
        //   EasyLoading.showSuccess('address Edited!');

        var addressInfo = json.decode(response.body);
        print('address Edit data : $addressInfo');
        print('response data ${addressInfo['data']}');
        // log(addressInfo);
        return addressInfo['data'];
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }

    // EasyLoading.dismiss();

  }

  Future<int> countProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String urls = 'https://api.dhopai.com/api-customer/cart_item_count/${prefs
        .getInt('customer_id')}';
    final response = await http.get(
      Uri.parse(urls),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
    );
    try {
      if (response.statusCode == 200) {
        var countInfo = json.decode(response.body);
        print('number of product data : $countInfo');
        return countInfo['data'];
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> pickUpAddressShow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));
    String url = Helper.BASE_URL + Helper.extCustomer + 'pickup_address';

    EasyLoading.show(status: 'loading...');
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': prefs.getInt('customer_id'),
      }),
    );
    try {
      if (response.statusCode == 200) {
        //  EasyLoading.showSuccess(' pick up address!');
        var addressInfo = json.decode(response.body);
        print('pick up address data : $addressInfo');
        print(addressInfo.runtimeType);
        //  prefs.setString('pick up', a)
        EasyLoading.dismiss();
        //  return addressInfo['data']['address_line_1'].toString();
        return addressInfo['data'];
      }

      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> pickUpAddressShowInBox() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));
    String url = Helper.BASE_URL + Helper.extCustomer + 'pickup_address';

    EasyLoading.show(status: 'loading...');
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': prefs.getInt('customer_id'),
      }),
    );
    try {
      if (response.statusCode == 200) {
        //  EasyLoading.showSuccess(' pick up address!');
        var addressInfo = json.decode(response.body);
        print('pick up address data : $addressInfo');
        print(addressInfo.runtimeType);
        //  prefs.setString('pick up', a)
        EasyLoading.dismiss();
        return addressInfo['data'];
        //return addressInfo['data'];
      }

      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  Future<int> storeDeliveryAddress(int areaId, int zoneId, int labelId,
      String streetAddress, String city, String zip,
      BuildContext context) async {
    print('in storing address method');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));

    String url = Helper.BASE_URL + Helper.extCustomer +
        'shipping_address_store';
    EasyLoading.show(status: 'loading...');
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': prefs.getInt('customer_id'),
        'area_id': areaId,
        'zone_id': zoneId,
        'label_id': labelId,
        'street_address': streetAddress,
        'city': city,
        'zip': zip
      }),
    );
    try {
      if (response.statusCode == 200) {
        print('storing is successful');
        var addressInfo = json.decode(response.body);
        prefs.setInt('deliveryAddressId', addressInfo['data']['id']);
        print('address data : $addressInfo');
        print('address Id:${addressInfo['data']['id']}');
        EasyLoading.showSuccess('address saving!');
        return addressInfo['data']['id'];
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }

    // EasyLoading.dismiss();

  }

  Future<Map> updateDeliveryAddress(int areaId, int zoneId, int labelId,
      String streetAddress, String city, String zip) async {
    print('in updating deliver address method');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var client = http.Client();
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));

    String url = Helper.BASE_URL + Helper.extCustomer +
        'shipping_address_update';
    EasyLoading.show(status: 'loading...');

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': prefs.getInt('customer_id'),
          'area_id': areaId,
          'zone_id': zoneId,
          'label_id': labelId,
          'street_address': streetAddress,
          'city': city,
          'zip': zip,
          'id': prefs.getInt('shippingId')
        }),
      );

      if (response.statusCode == 200) {
        //EasyLoading.showSuccess('address updating!');
        EasyLoading.show(status: 'Updating...');
        var addressInfo = json.decode(response.body);
        print(' update address data : $addressInfo');
        LogDebugger.instance.i(addressInfo);
        // log(addressInfo);
        EasyLoading.dismiss();
        return addressInfo;
      }
      else {
        client.close();
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      client.close();
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }

    // EasyLoading.dismiss();

  }

  Future<Map<String, dynamic>> EditDeliveryAddress(BuildContext context,
      int addressId) async {
    print('in editing delivery address method');
    //'https://api.dhopai.com/api-customer/pickup_address_edit'
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('address Id $addressId');
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));
    print('address Id ${prefs.getInt('deliveryAddressId')}');

    String url = Helper.BASE_URL + Helper.extCustomer + 'shipping_address_edit';

    EasyLoading.show(status: 'loading...');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode(<String, dynamic>{
          'id': prefs.getInt('customer_id'),

        }),
      );

      if (response.statusCode == 200) {
        //EasyLoading.showSuccess('Edit your address!');
        var addressInfo = json.decode(response.body);
        print('delivery address Edit data : $addressInfo');
        print('response data ${addressInfo['data']}');
        //  log(addressInfo['data']);

        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddressModificationDeliveryUpdate())
        );
        EasyLoading.dismiss();
        return addressInfo['data'];
      }
      else {
        EasyLoading.showSuccess('Something went wrong!');
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      //print(response.statusCode);
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }

    // EasyLoading.dismiss();

  }


  Future<Map<String, dynamic>> deliveryAddressShow() async {
    print('inside delivery address show data method');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));
    String url = Helper.BASE_URL + Helper.extCustomer + 'shipping_address';

    EasyLoading.show(status: 'loading...');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': prefs!.getInt('customer_id')!.toInt(),
        }),
      );

      if (response.statusCode == 200) {
        //EasyLoading.showSuccess(' pick up address!');

        var addressInfo = json.decode(response.body);
        print('Delivery address data show : $addressInfo');
        print(addressInfo.runtimeType);
        /* print('addressline ${addressInfo['data']['area_id']}');
         prefs.setInt('deliveryAddressId', addressInfo['data']['area_id'].toInt());
         print('addressline: ${ addressInfo['data']['address_line_1']}');*/
        EasyLoading.dismiss();
        return addressInfo['data'];
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deliveryAddressShowInBox() async {
    print('inside delivery address show data method');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));
    String url = Helper.BASE_URL + Helper.extCustomer + 'shipping_address';

    EasyLoading.show(status: 'loading...');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': prefs!.getInt('customer_id')!.toInt(),
        }),
      );

      if (response.statusCode == 200) {
        //EasyLoading.showSuccess(' pick up address!');

        var addressInfo = json.decode(response.body);
        print('Delivery address data show : $addressInfo');
        print(addressInfo.runtimeType);
        print('addressline ${addressInfo['data']['area_id']}');
        // prefs.setInt('deliveryAddressId', addressInfo['data']['area_id']);
        print('addressline: ${ addressInfo['data']['address_line_1']}');
        EasyLoading.dismiss();
        return addressInfo['data'];
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  Future<List<DeliveryInfoModel>> deliveryInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final infoOfDelivery  = Provider.of<DeliveryInfo>(context);
    // print('address id in function ${infoOfDelivery.addressId}');
    print('inside delivery info method');
    print('address area id ${prefs.getInt('delivery_area_id')}');
    print('shipping area id ${prefs.getInt('shippingId')}');
    LogDebugger.instance.i('shipping area id ${prefs.getInt('shippingId')}');
    // var url = Helper.BASE_URL + Helper.extDefault + 'delivery_info/${ prefs.getInt('shippingId')}';
    //var url=Helper.BASE_URL+Helper.extDefault+'delivery_info/${ infoOfDelivery.addressId}';
    var url = Helper.BASE_URL + Helper.extDefault + 'delivery_info/${prefs.getInt('delivery_area_id')}';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var deliveryInfo = json.decode(response.body);
        print('System of Delivery data : $deliveryInfo');
        List<dynamic> lst = deliveryInfo['data'];
        LogDebugger.instance.i(lst);
        print('list of delivery method $lst');
        return lst.map((element) => DeliveryInfoModel.fromJson(element))
            .toList();
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<List> getServiceAreaData() async {
    String url = Helper.BASE_URL + Helper.extDefault + 'service_area';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List<dynamic> lst = result['data'];
      print(lst);
      return lst;
      // return lst.map((e) => ServiceAreaModelClass.fromJson(e)).toList();

    }
    else {
      throw 'Something went wrong';
    }
  }

  Future<List> getLabelData() async {
    //'https://api.dhopai.com/api/address_labels'
    String url = Helper.BASE_URL + Helper.extDefault + 'address_labels';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List<dynamic> lst = result['data'];
      print(lst);
      // return lst.map((e) => ModelLabel.fromJson(e)).toList();
      return lst;
    }
    else {
      throw 'Something went wrong';
    }
  }

  Future<bool?> makeOrder(String pickup, String delivery) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('customerId: ${prefs.getInt('customer_id')}');
    print('customerId: ${prefs.getInt('subTotal')}');
    print('charge id is ${prefs.getInt('chargeId')}');
    print('charge is ${prefs.getInt('charge')}');
    print('delivery id is ${prefs.getInt('deliveryAddressId')}');
    print('pick up id is ${prefs.getInt('pickupAddressId')}');
    print(pickup);
    print(delivery);
    //prefs.getInt('deliveryAddressId')
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print(formattedDate);
    String url = Helper.BASE_URL + Helper.extCustomer + 'order_store';
    EasyLoading.show(status: 'loading...');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode(<String, dynamic>{
          'ord_date': formattedDate,
          'customer_id': prefs.getInt('customer_id')!.toInt(),
          'amount': prefs.getInt('subTotal'),
          'charge_id': prefs.getInt('chargeId'),
          'charge': prefs.getInt('charge'),
          'discount_id': null,
          'discount_amount': (prefs.getInt('discount')==null||prefs.getInt('discount')==0)?0:prefs.getInt('discount'),
          'payment_type': 1,
          'pickup': pickup, //prefs.getString('pick_Address'),
          'shipping': delivery //prefs.getString('ship_Address'),
        }),
      );
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var makeOrderInfo = json.decode(response.body);
        print('make order info data : $makeOrderInfo');
        LogDebugger.instance.i(makeOrderInfo);
        prefs.setInt('current_order_id', makeOrderInfo['data']['id']);
        EasyLoading.dismiss();
        return makeOrderInfo['success'];
      }
      else {
        EasyLoading.showInfo('Something went wrong!');
        throw Exception('Request Error: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.showInfo('Something went wrong!');
    }
    return null;
  }

  Future<List<TopOrders>> getLatest5Orders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('customerId: ${prefs.getInt('customer_id')}');
    String url = Helper.BASE_URL + Helper.extCustomer +
        'latest_order/${prefs.getInt('customer_id')}';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List<dynamic> lst = result['data'];
      LogDebugger.instance.i(lst);
      print(lst);
      return lst.map((e) => TopOrders.fromJson(e)).toList();
    }
    else {
      throw 'Something went wrong';
    }
  }

  Future<List<AllOrderModelClass>> getAllOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Helper.BASE_URL + Helper.extCustomer +
        'orders/${prefs.getInt('customer_id')}';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List<dynamic> lst = result['data'];
      LogDebugger.instance.i(lst);
      print(lst);

      return lst.map((e) => AllOrderModelClass.fromJson(e)).toList();
    }
    else {
      throw 'Something went wrong';
    }
  }

  Future<Map<String, dynamic>> userInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //'https://api.dhopai.com/api-customer/cart/${prefs.getInt('customer_id')}'
    String url = Helper.BASE_URL + Helper.extCustomer +
        'customer/${prefs.getInt('customer_id')}';
    print('userinfo is $url');
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var profileInfo = json.decode(response.body);
        print('User profile data $profileInfo');
        return profileInfo;
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<List<SearchModel>> getSearchList(query) async {
    String url = Helper.BASE_URL + Helper.extDefault + 'find?q=$query';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List<dynamic> lst = result['data'];
      return lst.map((e) => SearchModel.fromJson(e)).toList();
    }
    else {
      throw 'Something went wrong';
    }
  }

  Future<PastOrderView> viewOrderedProducts(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Helper.BASE_URL + Helper.extCustomer + 'order/${orderId}';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },

    );
    try {
      if (response.statusCode == 200) {
        var productInfo = json.decode(response.body);
        return PastOrderView.fromJson(productInfo['data']);
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<String> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('inside function');

    try {
      final response = await http.post(
        Uri.parse('https://api.dhopai.com/api-customer/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
      );

      if (response.statusCode == 200) {
        var logOutInfo = json.decode(response.body);
        return logOutInfo['data']['status'];
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<String> userBillingUpdate(String f_name, String l_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Helper.BASE_URL + Helper.extCustomer + 'billing_update';
    EasyLoading.show(status: 'updating...');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode(<String, dynamic>{
          'f_name': f_name,
          'l_name': l_name,
          'customer_id': prefs.getInt('customer_id'),

        }),
      );

      if (response.statusCode == 200) {
        //EasyLoading.showSuccess('Edit your address!');
        var updateInfo = json.decode(response.body);
        print('Billing data : $updateInfo');
        print('response data ${updateInfo['message']}');
        //  log(addressInfo['data']);
        EasyLoading.dismiss();
        return updateInfo['message'];
      }
      else {
        EasyLoading.showSuccess('Something went wrong!');
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      //print(response.statusCode);
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  Future<String> updatePhoto(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Helper.BASE_URL + Helper.extCustomer + 'upload_image_profile';
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    print(base64Image);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode(<String, dynamic>{
          'customer_id': prefs.getInt('customer_id'),
          'img': 'data:image/jpeg;base64,' + base64Image
        }),
      );

      if (response.statusCode == 200) {
        var updateInfo = json.decode(response.body);
        prefs.setString('image', updateInfo['data']);
        EasyLoading.dismiss();
        return updateInfo['message'];
      }
      else {
        EasyLoading.showSuccess('Something went wrong!');
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      //print(response.statusCode);
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> orderStatus([int? oId]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Helper.BASE_URL + Helper.extCustomer + 'order_tracking';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode(<String, dynamic>{
          'order_id': oId ?? prefs.getInt('current_order_id'),
        }),
      );

      if (response.statusCode == 200) {
        var updateInfo = json.decode(response.body);
        print('Order Status data : $updateInfo');
        print('response data ${updateInfo['data']}');
        EasyLoading.dismiss();
        return updateInfo;
      }
      else {
        EasyLoading.showSuccess('Something went wrong!');
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      //print(response.statusCode);
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  Future<PromotionModel> getAds() async {
    String url = Helper.BASE_URL + Helper.extDefault + 'home_adds';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

    );
    try {
      if (response.statusCode == 200) {
        var adsInfo = json.decode(response.body);
        return PromotionModel.fromJson(adsInfo);
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendingPhoneNumberForResetPassword(
      String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Helper.BASE_URL + Helper.extDefault + 'otp/send';
    EasyLoading.show(status: 'loading...');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
          //  'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode(<String, dynamic>{
          'number': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        var updateInfo = json.decode(response.body);
        print(updateInfo);
        EasyLoading.dismiss();
        return updateInfo;
      }
      else {
        EasyLoading.showSuccess('Something went wrong!');
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      //print(response.statusCode);
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  //https://api.dhopai.com/api/otp/valid
  Future<Map<String, dynamic>> otpVerification(String otp,
      String phoneNumber) async {
    String url = Helper.BASE_URL + Helper.extDefault + 'otp/valid';
    EasyLoading.show(status: 'loading...');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'number': phoneNumber,
          'token': otp
        }),
      );

      if (response.statusCode == 200) {
        var updateInfo = json.decode(response.body);
        print('data : $updateInfo');
        print('response data ${updateInfo['data']}');
        EasyLoading.dismiss();
        return updateInfo;
      }
      else {
        EasyLoading.showSuccess('Something went wrong!');
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      //print(response.statusCode);
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  //https://api.dhopai.com/api/pass_reset
  Future<Map<String, dynamic>> resetPassword(String? token, String? phoneNumber,
      String pass, String confirmPass) async {
    String url = Helper.BASE_URL + Helper.extDefault + 'pass_reset';
    EasyLoading.show(status: 'loading...');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'phone': phoneNumber,
          'token': token,
          'password': pass,
          'password_confirmation': confirmPass
        }),
      );

      if (response.statusCode == 200) {
        var updateInfo = json.decode(response.body);
        print('data : $updateInfo');
        EasyLoading.dismiss();
        return updateInfo;
      }
      else {
        EasyLoading.showSuccess('Something went wrong!');
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      //print(response.statusCode);
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkRegisteredNumber(String phoneNumber) async {
    //https://api.dhopai.com/api/check_usr
    String url = Helper.BASE_URL + Helper.extDefault + 'check_usr';
    EasyLoading.show(status: 'loading...');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'phone': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        var updateInfo = json.decode(response.body);
        print('data : $updateInfo');
        EasyLoading.dismiss();
        return updateInfo;
      }
      else {
        EasyLoading.showSuccess('Something went wrong!');
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      //print(response.statusCode);
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }

  Future<OfferModelClass> getOffers() async {
    //https://api.dhopai.com/api/offers
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Helper.BASE_URL + Helper.extDefault + 'offers';
    print(url);
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //'Authorization': 'Bearer ${prefs.getString('token')}',
      },

    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var offer_info = json.decode(response.body);
        print('cart data $offer_info');
        return OfferModelClass.fromJson(offer_info);
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<SupportModelClass> getSupport() async {
    //https://api.dhopai.com/api/offers
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Helper.BASE_URL + Helper.extDefault + 'support_category';
    print(url);
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //'Authorization': 'Bearer ${prefs.getString('token')}',
      },

    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var support_info = json.decode(response.body);
        print('cart data $support_info');
        return SupportModelClass.fromJson(support_info);
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<SupportCatagoryModel> getSupportCatagory(int id) async {
    //https://api.dhopai.com/api/support_category/1
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = Helper.BASE_URL + Helper.extDefault + 'support_category/${id}';
    print(url);
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //'Authorization': 'Bearer ${prefs.getString('token')}',
      },

    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var supportCatagoryInfo = json.decode(response.body);
        print('cart data $supportCatagoryInfo');
        return SupportCatagoryModel.fromJson(supportCatagoryInfo);
      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      rethrow;
    }
  }

  Future<Map> checkUserFoundOrNot(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getInt('customer_id'));
    https: //api.dhopai.com/api/otp/send
    String url = 'https://api.dhopai.com/api-customer/check_user_phn';
    EasyLoading.show(status: 'loading...');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode(<String, dynamic>{
          'phone_num': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        var updatePhoneNumberInfo = json.decode(response.body);
        print('phone Info : $updatePhoneNumberInfo');

        EasyLoading.dismiss();
        return updatePhoneNumberInfo;
      }
      else {
        EasyLoading.showSuccess('Something went wrong!');
        throw Exception('Request Error: ${response.statusCode}');
      }
    }
    on Exception {
      //print(response.statusCode);
      EasyLoading.showSuccess('Something went wrong!');
      rethrow;
    }
  }
}