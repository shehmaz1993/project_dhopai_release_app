
import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/authentication/Reset_password/reset_password.dart';
import 'package:dhopai/utils/Size.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../SignUp/sign_up.dart';
import '../../utils/scaffold_message.dart';
import '../../widgets/successful_message_page.dart';




class SmsVerification extends StatefulWidget {

  final String otp,phone,page;
  const SmsVerification({Key? key, required this.otp, required this.phone, required this.page}) : super(key: key);

  @override
  _SmsVerificationState createState() => _SmsVerificationState();
}

class _SmsVerificationState extends State<SmsVerification> {


  String profile_verification='false';
  Repository rp =Repository();

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

  }

  //shared preference.......
  var otp_by_user=' ';



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget> [
          Padding(
              padding:  EdgeInsets.only(
                top:SizeConfig.blockSizeVertical*2,
                bottom: SizeConfig.blockSizeVertical*4.5,
              ),
              child: Column(
                children: [
                  Text("We have sent SMS to: ", style:TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold)),
                  SizedBox(height: SizeConfig.blockSizeVertical*2,),
                  Text(widget.phone),
                ],
              )
          ),
          Padding(
            padding:  EdgeInsets.symmetric(
                vertical:SizeConfig.blockSizeVertical*1,
                horizontal:SizeConfig.blockSizeHorizontal*3
            ),
            child: Container(
              child:OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: 45,
                fieldStyle: FieldStyle.box,
                style: TextStyle(
                    fontSize: 17
                ),
                onChanged: (pin) {
                  print("Changed: " + pin);
                  otp_by_user=pin;
                },
                onCompleted: (pin) {
                  print("Completed: " + pin);
                  otp_by_user=pin;
                },
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(
                vertical:SizeConfig.blockSizeVertical*4,
                horizontal:SizeConfig.blockSizeHorizontal*6
            ),
            child: SizedBox(
              width:double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: otp_by_user.length!=6? Colors.grey:Colors.blue
                  ),
                  child: Text('Verify',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                  onPressed:otp_by_user.length!=6?null:()async{
                    if(widget.page =='forgot_password'){
                      var map = await rp.otpVerification(otp_by_user, widget.phone);
                      if(map['status']== true){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                          return ResetPassword();
                        }), (r){
                          return false;
                        });
                      }
                      else{
                        Fluttertoast.showToast(msg: 'Your otp was not valid!');
                      }

                    }
                    if(widget.page =='sign_up'){

                      var user_info = await rp.otpVerification(otp_by_user, widget.phone);
                      if(user_info['status']== true){
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        print('phone is ${prefs.getString('phone')!}');
                        print('password is ${prefs.getString('password')!}');
                        var result = await rp.registerInfo(prefs.getString('phone')!,prefs.getString('password')!);
                        if(result == true){

                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                            return SuccessfulMessagePage(
                                message: 'Your registration has been Completed Successfully!',
                                navigationPage: 'registration_to_home'
                            );
                          }), (r){
                            return false;
                          });
                        }else{

                          if(user_info!['message']=='Duplicate Entry'){
                            showScaffoldMessage(context, 'The phone number is already registered');
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                              return SignUpPage();
                            }), (r){
                              return false;
                            });
                          } else{
                            Fluttertoast.showToast(msg: 'Something went wrong');
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                              return SignUpPage();
                            }), (r){
                              return false;
                            });
                          }
                        }
                      }

                    }
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Did not receive a code?'),
              SizedBox(width: SizeConfig.blockSizeHorizontal*0.35,),
              InkWell(
                  onTap: ()async{


                  },
                  child: Text('Resend',style: TextStyle(color: Colors.red),)


              ),
            ],
          )

        ],
      ),

    );
  }
}