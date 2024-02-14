import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dhopai/Routing/constrants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/Size.dart';
import 'home.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>with TickerProviderStateMixin  {
  late AnimationController _controller1,_controller2;
  late Animation<double> animation1,animation2;

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('BASE_URL', 'https://api.dhopai.com/');
    prefs.setString('Developer', 'Shehmaz');
    var duration =  const Duration(seconds: 6);
    return  Timer(duration, navigationPage);
  }
  void navigationPage()async {
    var v=await isInternet();
   if(v==true){
     Flushbar(message: 'You are connected to Internet!',backgroundColor: Colors.green,flushbarPosition: FlushbarPosition.TOP,
       flushbarStyle: FlushbarStyle.FLOATING,isDismissible: false, duration: Duration(seconds: 5),reverseAnimationCurve: Curves.decelerate,
       forwardAnimationCurve: Curves.elasticOut,)..show(context);
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>Home()));
     //Navigator.pushNamed(context, homePage);
   }
   else{
     Flushbar(message: 'You do not have Internet connection',backgroundColor: Colors.redAccent,flushbarPosition: FlushbarPosition.TOP,
       flushbarStyle: FlushbarStyle.FLOATING,isDismissible: false, duration: Duration(seconds: 5),reverseAnimationCurve: Curves.decelerate,
       forwardAnimationCurve: Curves.elasticOut,)..show(context);
     SystemNavigator.pop();
   }
  }
  Future<bool> isInternet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      if (result==true) {
        Flushbar(message: 'You are connected to Internet!',backgroundColor: Colors.green,flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,isDismissible: false, duration: Duration(seconds: 5),reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,)..show(context);
        // Mobile data detected & internet connection confirmed.
        return true;
      } else {
        // Mobile data detected but no internet connection found.
        Flushbar(message: 'You do not have Internet connection',backgroundColor: Colors.redAccent,flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,isDismissible: false, duration: Duration(seconds: 5),reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,)..show(context);
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      if (await result==true) {
        // Wifi detected & internet connection confirmed.
        Flushbar(message: 'You are  connected to Internet!',backgroundColor: Colors.green,flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,isDismissible: false, duration: Duration(seconds: 5),reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,)..show(context);
        return true;
      } else {
        // Wifi detected but no internet connection found.
        Flushbar(message: 'You do not have Internet connection',backgroundColor: Colors.redAccent,flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,isDismissible: false, duration: Duration(seconds: 5),reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,)..show(context);
        return false;
      }
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      Flushbar(message: 'You do not have Internet connection',backgroundColor: Colors.redAccent,flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,isDismissible: false, duration: Duration(seconds: 5),reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,)..show(context);
      return false;
    }
  }

  @override
  void initState() {
    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    animation1 = CurvedAnimation(parent: _controller1, curve: Curves.decelerate);
    _controller1.repeat(reverse: true);
     _controller2 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    animation2 = CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeIn,
    );
    super.initState();
    startTime();
   // SystemChrome.setEnabledSystemUIOverlays([]);

  }
  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  Scaffold(
          body: Center(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical*23,),
                FadeTransition(
                  opacity: animation2,
                  child: Container(
                    height: SizeConfig.blockSizeVertical*35,
                    width: SizeConfig.blockSizeHorizontal*70,
                    decoration:  const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/dhopai_logo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),

                  ),
                ),
                Container(
                  height: 180,
                  width: double.infinity,
                  //color: Colors.amber,
                  child: Center(
                      child: RotationTransition(
                          turns: animation1,
                          child: Image.asset('assets/images/icon.png',height: 100,width: 200,))
                  ),
                ),
              ],
            )
          )


    );

  }
}
