import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/SignIn/sign_in_info.dart';
import 'package:dhopai/SignUp/sign_up.dart';
import 'package:dhopai/authentication/Reset_password/reset_password.dart';
import 'package:dhopai/authentication/Reset_password/sms_verification.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Size.dart';
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
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
    // final SignInInfo infoOfSignIn = Provider.of<SignInInfo>(context, listen: false);
    // TODO: implement initState
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
        appBar: AppBar(
          backgroundColor: Colors.indigo.shade500,
          title: Text('Password Reset', style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: ()=>{
              Navigator.pop(context)
            },
            color: Colors.white,
          ),
        ),

        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              phoneNumberTextBox(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 22.0, top: 38.0, bottom: 0.0, right: 22.0),
                child: Container(
                  width: 266, //266.0,
                  height: 48.0, //48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Colors.indigo.shade700,
                  ),
                  child:  MaterialButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var info = await repo.checkRegisteredNumber(phoneNumberController.text);
                      if(info['data']=='exist'){
                        var map = await repo.sendingPhoneNumberForResetPassword(phoneNumberController.text);
                        if(map['token']!=null){
                          prefs.setString('password_token', map['token']);
                          prefs.setString('phone_number', phoneNumberController.text.toString());
                          print('phone number ${phoneNumberController.text.toString()}');
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                            return SmsVerification(otp: map['otp'],phone:phoneNumberController.text, page: 'forgot_password',);
                          }), (r){
                            print(r);
                            return false;
                          });
                        }
                        else {
                          SystemNavigator.pop();
                        }
                      }else{
                        Fluttertoast.showToast(msg: 'This number is not registered');
                      }

                    },
                    child:const FittedBox(
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
        )

    );
  }
  Widget phoneNumberTextBox() {
    SizeConfig().init(context);
    final infoOfSignIn  = Provider.of<SignInInfo>(context);
    return Padding(
      padding:  EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal*7,
          top: SizeConfig.blockSizeVertical*2.5,
          bottom: 0.0,
          right:  SizeConfig.blockSizeHorizontal*7
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: const Color(0xffe7ebee),
          border: Border.all(
              width: 2.0,
              color:Colors.indigo.shade400
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
                  hintText: 'Phone Number....',
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
