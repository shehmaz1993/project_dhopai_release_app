import 'package:dhopai/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Repository/repository.dart';
import '../../home.dart';
import '../../utils/Size.dart';
class PhoneNumberVerification extends StatefulWidget {
  final String otp,phone;
  const PhoneNumberVerification({super.key, required this.otp, required this.phone});

  @override
  State<PhoneNumberVerification> createState() => _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
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

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    var map = await rp.otpVerification(otp_by_user, widget.phone);

                    if(map['status']== true){
                      Utils().toastMessage('Your phone number has been changed successfully!');
                      prefs.setString('phone', widget.phone);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                          return Home();
                        }), (r){
                          return false;
                        });
                      });

                    }
                    else{
                      Fluttertoast.showToast(msg: 'Your otp was not valid!');
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
