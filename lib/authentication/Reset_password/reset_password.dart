import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/SignIn/sign_in.dart';
import 'package:dhopai/utils/Size.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ResetPassword extends StatefulWidget {


  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>with SingleTickerProviderStateMixin {

  bool showPassword=false;
  var resetPasswordController = TextEditingController();
  var passwordController = TextEditingController();
  Repository rp = Repository();
  @override
  void initState() {
    /* _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _controller.repeat();*/
    super.initState();
  }


  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*7,
                top: SizeConfig.blockSizeVertical*16,

              ),
              child: Text('Reset Password',
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical*3.5,
                    fontWeight: FontWeight.bold
                ),),
            ),
            Padding(
              padding:  EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*7,
                  top: SizeConfig.blockSizeVertical*2,
                  right: SizeConfig.blockSizeHorizontal*7,
                  bottom: SizeConfig.blockSizeVertical*3
              ),
              child: Text('Enter your new password twice below to reset new password',
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical*2.7,
                    fontWeight: FontWeight.normal,
                    color: Colors.black45
                ),),
            ),
            Padding(
              padding:  EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*7,
                  top: SizeConfig.blockSizeVertical*1,
                  right: SizeConfig.blockSizeHorizontal*7,
                  bottom: SizeConfig.blockSizeVertical*4
              ),
              child: Text('Password must be at least 8 characters',
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical*2.7,
                    fontWeight: FontWeight.normal,
                    color: Colors.red
                ),),
            ),

            Padding(
              padding:  EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*7,
                  top: SizeConfig.blockSizeVertical*3,
                  right: SizeConfig.blockSizeHorizontal*7
              ),
              child: Text('Enter new password',
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical*2.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
            ),
            Padding(
              padding:  EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*3.5,
                  top: SizeConfig.blockSizeVertical*1,
                  bottom: SizeConfig.blockSizeVertical*1.5
                //right: SizeConfig.blockSizeHorizontal*7
              ),
              child: passwordTextBox(),
            ),
            Padding(
              padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*7,
                top: SizeConfig.blockSizeVertical*2,

                // right: SizeConfig.blockSizeHorizontal*7
              ),
              child: Text('Re-enter new password',
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical*2.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*3.5,

              ),
              child: resetPasswordTextBox(),
            ),

            SizedBox(height:SizeConfig.blockSizeVertical*9,),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*5.8,
                // top: SizeConfig.blockSizeVertical*0.5,
                //right: SizeConfig.blockSizeHorizontal*7
              ),
              child: GestureDetector(
                onTap:((passwordController.text.isNotEmpty && resetPasswordController.text.isNotEmpty)
                    && (passwordController.text==resetPasswordController.text)) ?
                    ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  var map = await    rp.resetPassword(
                      prefs.getString('password_token'),
                      prefs.getString('phone_number'),
                      passwordController.text.toString(),
                      resetPasswordController.text.toString()
                  );
                  if(map['data']=='Done'){
                    prefs.clear();
                    Fluttertoast.showToast(msg: 'Password reset successful!');
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                      return SignInPage();
                    }), (r){
                      return false;
                    });
                  }

                }:null,
                child: Container(
                  height:SizeConfig.blockSizeVertical*7.5,
                  width: SizeConfig.blockSizeHorizontal*85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color:((passwordController.text.isNotEmpty && resetPasswordController.text.isNotEmpty)
                        && (passwordController.text==resetPasswordController.text))?Colors.lightBlue.shade500:Colors.grey ,
                  ),
                  child: Center(
                      child: Text(
                        'Update Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockSizeVertical*2.5,
                            color: Colors.white),
                      )
                  ),
                ),
              ),
            )


          ],

        ),
      ),
    );
  }
  Widget passwordTextBox(){

    return  Padding(
      padding:  EdgeInsets.only(
          left:SizeConfig.blockSizeHorizontal*2.0,//22.0,
          top:SizeConfig.blockSizeVertical*1.0,//18.0,
          bottom: 0.0,
          right: SizeConfig.blockSizeHorizontal*2.0
      ),
      child: Container(
        width:SizeConfig.blockSizeHorizontal*88,//332, //266.0,
        height:SizeConfig.blockSizeVertical*7.3,//48.0, //48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: const Color(0xffe7ebee),
          border: Border.all(
              width: 2.0,
              color:  Colors.lightBlue.shade300
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*4.8),
          child: TextFormField(
            controller: passwordController,
            obscureText: showPassword==false?true:false,
            decoration:  InputDecoration(
              // icon: Icon(Icons.password_sharp),
                hintText:'Type new password....',

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
            validator: (value){
              if ((value!.length < 8) && value.isNotEmpty) {
                return "Password should contain at least 8 characters";
              }
            },
            onChanged:(value){},


          ),
        ),
      ),
    );
  }
  Widget resetPasswordTextBox(){

    return  Padding(
      padding: EdgeInsets.only(
          left:SizeConfig.blockSizeHorizontal*2.0,//22.0,
          top:SizeConfig.blockSizeVertical*3.0,//18.0,
          bottom: 0.0,
          right: SizeConfig.blockSizeHorizontal*2.0
      ),
      child: Container(
        width:SizeConfig.blockSizeHorizontal*88,//332, //266.0,
        height:SizeConfig.blockSizeVertical*7.3,//48.0, //48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // color: const Color(0xffe7ebee),
          border: Border.all(
              width: 2.0,
              color:  Colors.lightBlue.shade300
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*4.8),
          child: TextFormField(
            controller: resetPasswordController,
            obscureText: showPassword==false?true:false,
            decoration:  InputDecoration(
              //  icon: Icon(Icons.password_sharp),
                hintText:'Retype the new password ....',

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
            validator: (txt){
              if (txt!=passwordController.text.toString()) {
                return "The re-type password must match with password";
              }

            },
            onChanged:(value){},
          ),
        ),
      ),
    );
  }
}
