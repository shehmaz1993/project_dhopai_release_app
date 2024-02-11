

import 'package:dhopai/Products/products.dart';
import 'package:dhopai/Routing/constrants.dart';
import 'package:dhopai/SignIn/sign_in.dart';
import 'package:dhopai/SignUp/sign_up.dart';

import 'package:dhopai/orderFile/addressmodification/addressmodificationfordeliveryUPDATE.dart';
import 'package:dhopai/orderFile/addressmodification/assressmodificationforpickupUPDATE.dart';
import 'package:dhopai/orderFile/cashmemo.dart';
import 'package:dhopai/orderFile/order_rev.dart';
import 'package:dhopai/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home.dart';

import '../orderFile/order_details.dart';


class ProRoutes{

  static Route<dynamic> generateRoute(RouteSettings setting){
    switch(setting.name){
      case splashScreen:
        return MaterialPageRoute(builder: (context)=>SplashScreen());
      case signUp:
        return MaterialPageRoute(builder: (context)=>SignUpPage());
      case signIn:
        return MaterialPageRoute(builder: (context)=>SignInPage());
      case homePage:
        return MaterialPageRoute(builder: (context)=>Home());
      case productListPage:
        return MaterialPageRoute(builder: (context)=>ProductList(0));
      case orderRev:
        return MaterialPageRoute(builder: (context)=>OrderRev());
      case cashMemo:
        return MaterialPageRoute(builder: (context)=>CashMemo());
      case pickupUpdate:
        return MaterialPageRoute(builder: (context)=>AddressModificationPickUpUpdate());
      case deliveryUpdate:
        return MaterialPageRoute(builder: (context)=>AddressModificationDeliveryUpdate());
      case orderDetails:
       // return MaterialPageRoute(builder: (context)=>PaymentOrder(deliveryType: 'deliveryType',));
    }
    return MaterialPageRoute(builder: (context)=>Scaffold(
      body: Text('No route defined'),
    ));
  }



}