import 'package:dhopai/authentication/Reset_Phone_Number/new_phone_number_insert.dart';
import 'package:dhopai/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../Repository/repository.dart';
import '../../utils/Size.dart';

class ResetPhoneNumber extends StatefulWidget {
  const ResetPhoneNumber({super.key});

  @override
  State<ResetPhoneNumber> createState() => _ResetPhoneNumberState();
}

class _ResetPhoneNumberState extends State<ResetPhoneNumber> {
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
        title: Text('Change phone number', style: TextStyle(color: Colors.white),),
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
              padding:  EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*8,
                  top: SizeConfig.blockSizeVertical*5.8,
                  bottom: 0.0,
                  right: SizeConfig.blockSizeHorizontal*8
              ),
              child: Container(
                width: 266, //266.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: Colors.indigo.shade700,
                ),
                child:  MaterialButton(
                  onPressed: () async {

                    Map map = await repo.checkUserFoundOrNot(phoneNumberController.text.toString());
                    if(map['success']==true){
                      Utils().toastMessage('${map['message']}');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => NewPhoneNumberPage()),
                            (Route<dynamic> route) => false,
                      );
                    }
                    else{
                      Utils().toastMessage('${map['message']}');
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
              width: 2.0,
              color:Colors.indigo.shade300
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
