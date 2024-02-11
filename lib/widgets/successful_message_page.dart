import 'dart:async';

import 'package:flutter/material.dart';

import '../home.dart';
import '../utils/Size.dart';
class SuccessfulMessagePage extends StatefulWidget {
  final String message;
  final String navigationPage;
  const SuccessfulMessagePage({super.key, required this.message, required this.navigationPage});

  @override
  State<SuccessfulMessagePage> createState() => _SuccessfulMessagePageState();
}

class _SuccessfulMessagePageState extends State<SuccessfulMessagePage> {

  startTime() async {

    var duration =  const Duration(seconds: 5);
    return  Timer(duration, navigationPage);
  }
  void navigationPage()async {

      if(widget.navigationPage =='registration_to_home'){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
          return Home();
        }), (r){
          return false;
        });
      }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical*26,),
                Container(
                  height: SizeConfig.blockSizeVertical*20,
                  width: SizeConfig.blockSizeHorizontal*50,
                  decoration:  const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/successful.png'),
                      fit: BoxFit.fill,
                    ),
                  ),

                ),
                Container(
                  height: SizeConfig.blockSizeVertical*5,
                  width: double.infinity,
                 // color: Colors.amber,
                  child: Center(
                      child:Text('Congratulations!',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.blockSizeVertical*3.1,
                            color: Colors.red.shade700
                        ),
                      )
                  ),
                ),
                Container(
                  height: SizeConfig.blockSizeVertical*12,
                  width: double.infinity,
                  //color: Colors.amber,
                  child: Center(
                      child:FittedBox(
                        child: Text(widget.message,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.blockSizeVertical*1.9,
                            color: Colors.black54
                          ),),
                      )
                  ),
                ),
              ],
            )
        )


    );

  }
}

