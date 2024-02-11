import 'package:dhopai/authentication/Reset_Phone_Number/phone_number%20_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Repository/repository.dart';
import '../../utils/Size.dart';
import '../Reset_password/sms_verification.dart';

class NewPhoneNumberPage extends StatefulWidget {
  const NewPhoneNumberPage({super.key});

  @override
  State<NewPhoneNumberPage> createState() => _NewPhoneNumberPageState();
}

class _NewPhoneNumberPageState extends State<NewPhoneNumberPage> {
  final List<Icon> iconsImage = [
    Icon(Icons.person),
    Icon(Icons.mail),
    Icon(Icons.phone_android),
    Icon(Icons.password_sharp)
  ];

  var phoneNumberController = TextEditingController();
  bool showPassword=false;

  Repository repo=Repository();

  @override
  void initState() {

    super.initState();
    phoneNumberController=TextEditingController();


  }
  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  Scaffold(

      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical*15,
            //color: Colors.blue,
            child: Center(
              child: Image.asset(
                'assets/images/dhopai_logo.png', height: SizeConfig.blockSizeVertical*34, width: SizeConfig.blockSizeHorizontal*34,),
            ),
          ),


          phoneNumberTextBox(),


          Padding(
            padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*8,
                top: SizeConfig.blockSizeVertical*5.8,
                bottom: 0.0,
                right: SizeConfig.blockSizeHorizontal*8
            ),
            child: Container(
              width: SizeConfig.blockSizeHorizontal*26, //266.0,
              height: SizeConfig.blockSizeVertical*5.4, //48.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Colors.lightBlue.shade500,
              ),
              child:  MaterialButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  var map = await repo.sendingPhoneNumberForResetPassword(phoneNumberController.text);
                  if(map['token']!=null){
                    prefs.setString('password_token', map['token']);
                    prefs.setString('phone', phoneNumberController.text.toString());
                    print('phone number ${phoneNumberController.text.toString()}');
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                      return PhoneNumberVerification(otp: map['otp'],phone:phoneNumberController.text);
                    }), (r){
                      print(r);
                      return false;
                    });
                  }
                  else {
                    SystemNavigator.pop();
                  }
                },
                child: FittedBox(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Submit', style: TextStyle(color: Colors.white),),
                    )),
              ),
            ),
          ),
          const SizedBox(height: 10,),




        ],
      ),

    );
  }
  Widget phoneNumberTextBox() {
    SizeConfig().init(context);
    return Padding(
      padding:  EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal*7,
          top: SizeConfig.blockSizeVertical*2.5,
          bottom: 0.0,
          right:  SizeConfig.blockSizeHorizontal*7
      ),
      child: Container(
        width: SizeConfig.blockSizeHorizontal*30, //266.0,
        height: SizeConfig.blockSizeVertical*7.2, //48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: const Color(0xffe7ebee),
          border: Border.all(
              width: 2.0,
              color:Colors.lightBlue.shade300
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: TextField(
            //style:TextStyle(color: Colors.white)  ,
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(

                  icon: iconsImage[2],
                  //iconColor: Colors.white,
                  hintText: 'New phone number....',
                  // hintStyle:TextStyle(color: Colors.white) ,

                  border: InputBorder.none
                // labelText: hint,
              ),

              onChanged: (value){},
              onSubmitted: (value){}

          ),
        ),
      ),
    );
  }
}
