import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/SignUp/sign_up_info.dart';
import 'package:dhopai/SignUp/user.dart';
import 'package:dhopai/database/db-handlar.dart';

import 'package:dhopai/push-notification_services/firebase.dart';
import 'package:dhopai/utils/scaffold_message.dart';
import 'package:dhopai/utils/utils.dart';
import 'package:dhopai/widgets/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/Reset_password/sms_verification.dart';
import '../utils/Size.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  bool checkedValue = false;
  bool showPassword=false;
  bool showRePassword=false;
  Repository repo =Repository();
  late AnimationController _controller;
  bool state = false;
  final List<Icon> iconsImage = [
    Icon(Icons.person),
    Icon(Icons.mail),
    Icon(Icons.phone_android),
    Icon(Icons.password_sharp)
  ];
  Map? user_info;
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPassController = TextEditingController();
  //DBHelper? dbHelper;

  @override
  void initState() {
    final SignUpInfo infoOfSignUp = Provider.of<SignUpInfo>(
        context, listen: false);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 7),
    )..repeat();
    super.initState();
    nameController = TextEditingController(text: infoOfSignUp.name);
    phoneController = TextEditingController(text: infoOfSignUp.phoneNumber);
    emailController = TextEditingController(text: infoOfSignUp.email);
   // dbHelper=DBHelper();
  }


  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    _controller.dispose();

    super.dispose();
  }
  //password
 /* Future<bool>  registerInfo(String phoneNumber,String password) async {
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
        user_info = json.decode(response.body) ;
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
        if(user_info!['message']=='Customer register successfully.'){
          prefs.setInt('customer_id', user_info!['data']['customer_id']);
          prefs.setInt('pickUpId', user_info!['data']['pickup_id']);
          prefs.setInt('shippingId', user_info!['data']['shipping_id']);
          prefs.setString('token',  user_info!['data']['token']);
          prefs.setString('phone', user_info!['data']['phone']);
          prefs.setString('name', nameController.text.toString());
          prefs.setString('email', emailController.text.toString());
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
  }*/

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //var data=Provider.of<User>(context);
    SignUpInfo infoOfSignUp = Provider.of<SignUpInfo>(context);
    return Scaffold(
      // appBar: AppBar(title: const Text('Register'),),
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical*20,
            // color: Colors.blue,
            child: Center(
              child: Image.asset(
                'assets/images/dhopai_logo.png',
                height: SizeConfig.blockSizeVertical*50,
                width: SizeConfig.blockSizeHorizontal*50,
              ),
            ),
          ),
          // nameTextBox(),
          Padding(
            padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*7,
                top: SizeConfig.blockSizeVertical*5.5,
                bottom: 0.0,
                right:  SizeConfig.blockSizeHorizontal*7
            ),
            child: Container(
              width: SizeConfig.blockSizeHorizontal*30, //266.0,
              height: SizeConfig.blockSizeVertical*7.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                // color: const Color(0xffe7ebee),
                border: Border.all(
                    width: 2.0,
                    color: Colors.indigo.shade300
                ),
              ),
              child: Padding(
                padding:  EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal*4.5
                ),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,

                  decoration: InputDecoration(
                    icon: iconsImage[0],
                    hintText: 'Your Full name....',
                    border: InputBorder.none,
                    // labelText: hint,
                  ),

                  onChanged: infoOfSignUp.setName,
                  //onSubmitted:infoOfSignUp.setName ,

                ),
              ),
            ),
          ),
          //phoneNumberTextBox(),
          Padding(
            padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*7,
                top: SizeConfig.blockSizeVertical*1.5,
                bottom: 0.0,
                right:  SizeConfig.blockSizeHorizontal*7
            ),
            child: Container(
              width: SizeConfig.blockSizeHorizontal*30, //266.0,
              height: SizeConfig.blockSizeVertical*7.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                // color: const Color(0xffe7ebee),
                border: Border.all(
                    width: 2.0,
                    color: Colors.indigo.shade300
                ),
              ),
              child: Padding(
                padding:  EdgeInsets.only(left:  SizeConfig.blockSizeHorizontal*4.5),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      icon: iconsImage[2],
                      hintText: 'Phone Number....',
                      border: InputBorder.none
                    // labelText: hint,
                  ),

                  onChanged: infoOfSignUp.setPhoneNumber,
                  //onSubmitted: infoOfSignUp.setPhoneNumber,

                ),
              ),
            ),
          ),
          //  eMailTextBox(),
          /*  Padding(
            padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*7,
                top: SizeConfig.blockSizeVertical*1.5,
                bottom: 0.0,
                right:  SizeConfig.blockSizeHorizontal*7
            ),
            child: Container(
              width: SizeConfig.blockSizeHorizontal*30, //266.0,
              height: SizeConfig.blockSizeVertical*6.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                // color: const Color(0xffe7ebee),
                border: Border.all(
                    width: 2.0,
                    color: Colors.lightBlue.shade300
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: iconsImage[1],
                      hintText: 'Email....',
                      border: InputBorder.none
                    // labelText: hint,
                  ),

                  onChanged: infoOfSignUp.setEmail,
                  //  onSubmitted: infoOfSignUp.setEmail,

                ),
              ),
            ),
          ),*/
          //passwordTextBox(),
          Padding(
            padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*7,
                top: SizeConfig.blockSizeVertical*1.5,
                bottom: 0.0,
                right:  SizeConfig.blockSizeHorizontal*7
            ),
            child: Container(
              width: SizeConfig.blockSizeHorizontal*30, //266.0,
              height: SizeConfig.blockSizeVertical*7.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                // color: const Color(0xffe7ebee),
                border: Border.all(
                    width: 2.0,
                    color: Colors.indigo.shade300
                ),
              ),
              child: Padding(
                padding:  EdgeInsets.only(left:  SizeConfig.blockSizeHorizontal*4.5),
                child: TextField(
                  controller: passwordController,
                  obscureText: showPassword==false?true:false,
                  decoration: InputDecoration(
                    icon: iconsImage[3],
                    hintText: 'password....',
                    border: InputBorder.none,
                    // labelText: hint,
                    suffixIcon: IconButton(
                      onPressed: (){
                        if(showPassword==false){
                          setState(() {
                            showPassword=true;
                          });
                        }
                        else{
                          setState(() {
                            showPassword=false;
                          });
                        }

                      },
                      icon:showPassword==true? Icon(Icons.visibility,color: Colors.grey,):Icon(Icons.visibility_off,color: Colors.grey,),
                    ),
                  ),

                  onChanged: infoOfSignUp.setPassword,
                  // onSubmitted: infoOfSignUp.setPassword,

                ),
              ),
            ),
          ),
          //confirmPasswordTextBox(),
          Padding(
            padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*7,
                top: SizeConfig.blockSizeVertical*1.5,
                bottom: 0.0,
                right:  SizeConfig.blockSizeHorizontal*7
            ),
            child: Container(
              width: SizeConfig.blockSizeHorizontal*30, //266.0,
              height: SizeConfig.blockSizeVertical*7.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                // color: const Color(0xffe7ebee),
                border: Border.all(
                    width: 2.0,
                    color: Colors.indigo.shade300
                ),
              ),
              child: Padding(
                padding:  EdgeInsets.only(left:  SizeConfig.blockSizeHorizontal*4.5),
                child: TextField(
                  controller: confirmPassController,
                  obscureText: showRePassword==false?true:false,
                  decoration: InputDecoration(
                      icon: iconsImage[3],
                      hintText: 'Retype password....',

                      suffixIcon: IconButton(
                        onPressed: (){
                          if(showRePassword==false){
                            setState(() {
                              showRePassword=true;
                            });
                          }
                          else{
                            setState(() {
                              showRePassword=false;
                            });
                          }

                        },
                        icon:showRePassword==true? Icon(Icons.visibility,color: Colors.grey,):Icon(Icons.visibility_off,color: Colors.grey,),
                      ),
                      border: InputBorder.none

                    // labelText: hint,
                  ),

                  onChanged: infoOfSignUp.setConfirmPassword,
                  // onSubmitted: infoOfSignUp.setConfirmPassword,
                ),
              ),
            ),
          ),

          Padding(
            padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*7,
                top: SizeConfig.blockSizeVertical*5.5,
                bottom: 0.0,
                right:  SizeConfig.blockSizeHorizontal*7
            ),
            child: state == true? Center(
              child: CircularProgressIndicator(
                value: _controller.value,
              ),
            ): Container(
              width: SizeConfig.blockSizeHorizontal*30, //266.0,
              height: SizeConfig.blockSizeVertical*6.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Colors.indigo.shade500,
              ),
              child: MaterialButton(
                onPressed: () async {
                  if(infoOfSignUp.phoneNumber.length!=11){
                    showScaffoldMessage(context, 'Phone number must be 11 digit');
                  }
                  if(infoOfSignUp.phoneNumber.isEmpty){
                    showScaffoldMessage(context, 'You must enter your mobile number');
                  }
                  if(infoOfSignUp.password.isEmpty){
                    showScaffoldMessage(context, 'You must enter password');
                  }
                  if(infoOfSignUp.password.length<6 ){
                    showScaffoldMessage(context, 'Your password length must be six');
                  }
                  if(infoOfSignUp.password!=infoOfSignUp.confirmPassword){
                    showScaffoldMessage(context, 'Your passwords need to be matched');
                  }
                  print(infoOfSignUp.phoneNumber);
                  if(checkedValue==false){
                    showScaffoldMessage(context, 'you need to agree with terms and conditions');
                  }
                  if(infoOfSignUp.phoneNumber.length==11 && infoOfSignUp.password.length>=6 && infoOfSignUp.confirmPassword.length>=6 && checkedValue==true){

                    setState(() {
                      state = true;
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('phone', infoOfSignUp.phoneNumber);
                    prefs.setString('password', infoOfSignUp.password);
                    prefs.setString('rePassword', infoOfSignUp.confirmPassword);
                    var map = await repo.sendingPhoneNumberForResetPassword(infoOfSignUp.phoneNumber);
                    if(map['token']!=null){
                      print('phone number ${infoOfSignUp.phoneNumber.toString()}');
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                        return SmsVerification(otp: map['otp'],phone:infoOfSignUp.phoneNumber, page: 'sign_up',);
                      }), (r){
                        print(r);
                        return false;
                      });
                    }

                  }

                },
                child: FittedBox(
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical*2),
                      child: Text(
                        'Sign Up', style: TextStyle(color: Colors.white),),
                    )),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical*1.5,),
          Padding(
            padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2),
            child: CheckboxListTile(
              title:Row(
                children: [
                  Text("You need to agree with the ",
                    style: TextStyle(fontWeight: FontWeight.normal,fontSize: SizeConfig.blockSizeVertical*1.5),),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => WebViewPage(
                                  title: 'Terms and conditions',
                                  url:'https://api.dhopai.com/terms_condition'
                              )
                          )

                      );
                    },
                    child: Text(
                      "terms and conditions",
                      style: TextStyle(
                          fontWeight:FontWeight.normal,
                          fontSize: SizeConfig.blockSizeVertical*1.5,
                          color: Colors.blue
                      ),
                    ),
                  )
                ],
              ),  //Text("You need to agree with the terms and conditions"),
              value: checkedValue,
              onChanged: (newValue) {
                setState(() {
                  checkedValue = !checkedValue;
                });
              },
              controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          )


        ],
      ),
    );
  }


/* Widget nameTextBox() {
    SignUpInfo infoOfSignUp=Provider.of<SignUpInfo>(context);
    return Padding(
      padding: const EdgeInsets.only(
          left: 22.0, top: 18.0, bottom: 0.0, right: 22.0),
      child: Container(
        width: 266, //266.0,
        height: 48.0, //48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: const Color(0xffe7ebee),
          border: Border.all(
              width: 2.0,
              color: Colors.lightBlue.shade300
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: TextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                icon: iconsImage[0],
                hintText: 'Your Full name....',
                border: InputBorder.none
              // labelText: hint,
            ),

            onChanged: infoOfSignUp.setName,
           //onSubmitted:infoOfSignUp.setName ,

          ),
        ),
      ),
    );
  }*/

/* Widget phoneNumberTextBox() {
    SignUpInfo infoOfSignUp=Provider.of<SignUpInfo>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.only(
          left: 22.0, top: 18.0, bottom: 0.0, right: 22.0),
      child: Container(
        width: 266, //266.0,
        height: 48.0, //48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: const Color(0xffe7ebee),
          border: Border.all(
              width: 2.0,
              color: Colors.lightBlue.shade300
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: TextField(
            controller: phoneController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                icon: iconsImage[2],
                hintText: 'Phone Number....',
                border: InputBorder.none
              // labelText: hint,
            ),

            onChanged: infoOfSignUp.setPhoneNumber,
            //onSubmitted: infoOfSignUp.setPhoneNumber,

          ),
        ),
      ),
    );
  }*/
/*Widget eMailTextBox(){
     SignUpInfo infoOfSignUp=Provider.of<SignUpInfo>(context);
    return  Padding(
      padding: const EdgeInsets.only(left:22.0,top:18.0,bottom: 0.0,right: 22.0),
      child: Container(
        width:266, //266.0,
        height:48.0, //48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: const Color(0xffe7ebee),
          border: Border.all(
              width: 2.0,
              color:  Colors.lightBlue.shade300
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:18.0),
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration:  InputDecoration(
                icon: iconsImage[1],
                hintText:'Email....',
                border: InputBorder.none
              // labelText: hint,
            ),

           onChanged:infoOfSignUp.setEmail,
          //  onSubmitted: infoOfSignUp.setEmail,

          ),
        ),
      ),
    );
  }*/
/* Widget passwordTextBox(){
   // SignUpInfo infoOfSignUp=Provider.of<SignUpInfo>(context);
    return  Padding(
      padding: const EdgeInsets.only(left:22.0,top:18.0,bottom: 0.0,right: 22.0),
      child: Container(
        width:266, //266.0,
        height:48.0, //48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: const Color(0xffe7ebee),
          border: Border.all(
              width: 2.0,
              color:  Colors.lightBlue.shade300
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:18.0),
          child: TextField(
            controller: passwordController,
            decoration:  InputDecoration(
                icon: iconsImage[3],
                hintText:'password....',
                border: InputBorder.none
              // labelText: hint,
            ),

          //  onChanged: infoOfSignUp.setPassword,
           // onSubmitted: infoOfSignUp.setPassword,

          ),
        ),
      ),
    );
  }*/
/* Widget confirmPasswordTextBox(){
  //  SignUpInfo infoOfSignUp=Provider.of<SignUpInfo>(context);
    return  Padding(
      padding: const EdgeInsets.only(left:22.0,top:18.0,bottom: 0.0,right: 22.0),
      child: Container(
        width:266, //266.0,
        height:48.0, //48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: const Color(0xffe7ebee),
          border: Border.all(
              width: 2.0,
              color:  Colors.lightBlue.shade300
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:18.0),
          child: TextField(
            controller: confirmPassController,
            decoration:  InputDecoration(
                icon: iconsImage[3],
                hintText:'Retype password....',
                border: InputBorder.none
              // labelText: hint,
            ),

           // onChanged: infoOfSignUp.setConfirmPassword,
          // onSubmitted: infoOfSignUp.setConfirmPassword,
          ),
        ),
      ),
    );
  }
}*/
/*Future<UserModel?> registerInfo(BuildContext context,String phoneNumber) async {
 // SignUpInfo infoOfSignUp=Provider.of<SignUpInfo>(context,listen: false);
  try{
    final response = await http.post(
        Uri.parse('https://api.dhopai.com/api-customer/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone':phoneNumber
        })
    );
    if(response.statusCode==200){
      print('api calling is successful......');
      final Map user_info = json.decode(response.body);
      print(user_info);
      return UserModel.fromJson(user_info);

    }
    else{
      throw Exception('Request Error: ${response.statusCode}');
    }

  }
  on Exception{
    rethrow;
  }


}*/
}