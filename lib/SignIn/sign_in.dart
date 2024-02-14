import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/SignIn/sign_in_info.dart';
import 'package:dhopai/SignUp/sign_up.dart';
import 'package:dhopai/authentication/Reset_password/forget_password.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home.dart';
import '../utils/Size.dart';
import '../utils/scaffold_message.dart';
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  final List<Icon> iconsImage = [
    Icon(Icons.person),
    Icon(Icons.mail),
    Icon(Icons.phone_android),
    Icon(Icons.password_sharp)
  ];
  var phoneNumberController = TextEditingController();
  var passwordController = TextEditingController();
  bool showPassword=false;
  bool permission = false;
  bool state = false;
  late AnimationController _controller;
  Repository repo=Repository();

  @override
  void initState() {
    final SignInInfo infoOfSignIn = Provider.of<SignInInfo>(context, listen: false);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
    super.initState();
    phoneNumberController=TextEditingController(text: infoOfSignIn.phoneNumber);
    passwordController=TextEditingController(text: infoOfSignIn.password);

  }
  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final infoOfSignIn  = Provider.of<SignInInfo>(context);
    SizeConfig().init(context);
    return  Scaffold(
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical*25,
            // color: Colors.blue,
            child: Center(
              child: Image.asset(
                'assets/images/dhopai_logo.png', height: 140, width: 140,),
            ),
          ),

          phoneNumberTextBox(),

          passwordTextBox(),


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
            ):Container(
              width: SizeConfig.blockSizeHorizontal*30, //266.0,
              height: SizeConfig.blockSizeVertical*6.2,  //48.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Colors.indigo.shade500,
              ),
              child: MaterialButton(
                onPressed: () async {
                  if(infoOfSignIn.phoneNumber.length!=11){
                    showScaffoldMessage(context, 'Phone number must be 11 digit');
                  }
                  if(infoOfSignIn.phoneNumber.isEmpty){
                    showScaffoldMessage(context, 'You must enter your mobile number');
                  }
                  if(infoOfSignIn.password.isEmpty){
                    showScaffoldMessage(context, 'You must enter password');
                  }
                  if(infoOfSignIn.password.length<6 ){
                    showScaffoldMessage(context, 'Your password length must be six');
                  }
                  if(infoOfSignIn.phoneNumber.length==11 && infoOfSignIn.password.length>=6 ){
                    setState(() {
                      state = true;
                    });
                    Map map= await repo.getUserInfo(phoneNumberController.text, passwordController.text,context);
                    if (map['success']==true && Navigator.canPop(context)) {
                      setState(() {
                        state = false;
                      });
                      Navigator.pop(context,true);
                    }else if(map['success']==true){
                      setState(() {
                        state = false;
                      });
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                        return Home();
                      }), (r){
                        print(r);
                        return false;
                      });
                    }
                    else {
                      if(map['success']==false && map['message']=='Phone not match'){
                        setState(() {
                          state = false;
                        });
                        showScaffoldMessage(context, 'The phone number is not registered');
                      }
                      if(map['success']==false && map['message']=='Credentials not match'){
                        setState(() {
                          state = false;
                        });
                        showScaffoldMessage(context, 'Credentials did not match');
                      }

                    }
                  }

                },
                child:const FittedBox(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Sign In', style: TextStyle(color: Colors.white),),
                    )),
              ),
            ),
          ),
          SizedBox(height:SizeConfig.blockSizeVertical*3.5,),
          Padding(
            padding:  EdgeInsets.only(
                left:SizeConfig.blockSizeHorizontal*15.8,
                right: SizeConfig.blockSizeHorizontal*15.8,
                top: SizeConfig.blockSizeVertical*3
            ),
            child: Row(
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgetPasswordPage()));
                    },
                    child: Text('Forgot password?',style: TextStyle(color: Colors.black,fontSize: SizeConfig.blockSizeVertical*2.0),)

                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal*2.3),
                GestureDetector(
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    child: Text('create account!',style: TextStyle(color: Colors.indigo,fontSize: SizeConfig.blockSizeVertical*2.0),))
              ],
            ),
          )



        ],
      ),

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
        width: SizeConfig.blockSizeHorizontal*30, //266.0,
        height: SizeConfig.blockSizeVertical*7.2, //48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: const Color(0xffe7ebee),
          border: Border.all(
              width: 2.0,
              color:Colors.indigo.shade300
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*4.2),
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

              onChanged: infoOfSignIn.setPhoneNumber,
              onSubmitted: infoOfSignIn.setPhoneNumber

          ),
        ),
      ),
    );
  }
  Widget passwordTextBox(){
    SizeConfig().init(context);
    final infoOfSignIn  = Provider.of<SignInInfo>(context);
    return  Padding(
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
              color:  Colors.indigo.shade300
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*4.2),
          child: TextField(
            controller: passwordController,
            obscureText: showPassword==false?true:false,
            decoration:  InputDecoration(
                icon: iconsImage[3],
                hintText:'password....',

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
                border: InputBorder.none


              // labelText: hint,
            ),

            onChanged:infoOfSignIn.setPassword,
            onSubmitted:infoOfSignIn.setPassword,

          ),
        ),
      ),
    );
  }
}
