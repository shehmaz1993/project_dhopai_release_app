import 'package:dhopai/Profile/personal_information_provider.dart';
import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/orderFile/addressmodification/assressmodificationforpickupUPDATE.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../Side_Navigator/main_side_bar.dart';
import '../utils/Size.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final List<Icon> iconsImage = [
    Icon(Icons.person),
    Icon(Icons.person_2_rounded),
    Icon(Icons.phone_android),
    Icon(Icons.password_sharp)
  ];
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneController = TextEditingController();
  Repository rp =Repository();
  @override
  void initState() {
    final PersonalUpdateInfo infoOfPerson = Provider.of<PersonalUpdateInfo>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      await Provider.of<PersonalUpdateInfo>(context,listen: false).updateInfo();
      phoneController=TextEditingController(text: infoOfPerson.phoneNumber);
      firstNameController=TextEditingController(text: infoOfPerson.firstName);
      lastNameController=TextEditingController(text: infoOfPerson.lastName);
    });
    // TODO: implement initState
    super.initState();
    phoneController=TextEditingController(text: infoOfPerson.phoneNumber);
    firstNameController=TextEditingController(text: infoOfPerson.firstName);
    lastNameController=TextEditingController(text: infoOfPerson.lastName);
  }
  @override
  Widget build(BuildContext context) {
    final infoOfPerson  = Provider.of<PersonalUpdateInfo>(context);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title:Text('Billing',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2.9),),
          /*Padding(
                padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*3.5,bottom: SizeConfig.blockSizeVertical*2),
                child: const FittedBox(child: Text('Pickup Address ',style: TextStyle(color: Colors.black45),)),
              ),*/
          backgroundColor:  Colors.indigo.shade500,

          leading:Builder(builder: (BuildContext context)=>IconButton(
            onPressed:()=> Scaffold.of(context).openDrawer(),
            icon:  Icon(
              Icons.menu,
              color: Colors.white,
              size: SizeConfig.blockSizeVertical*4,
            ),
          ),),
        ),
      drawer: Drawer(
        child: MainSideBar(),
      ),
      bottomNavigationBar: GestureDetector(
        onTap:() async {
          String? response;
          if(firstNameController.text==' '){
            Fluttertoast.showToast(
                msg: 'you must fill first name'
            );
          }
          if(lastNameController.text==' '){
            Fluttertoast.showToast(
                msg: 'you must fill last name'
            );
          }
          if(firstNameController.text!='' &&  lastNameController.text!=''){
            response = await rp.userBillingUpdate(
                firstNameController.text.toString(),
                lastNameController.text.toString()
            );
          }


          if(response=='Customer update successfully.'){
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        AddressModificationPickUpUpdate()));
          }else{
            Fluttertoast.showToast(
                msg: 'Something went wrong'
            );
          }

        },
        child: Container(
          height: SizeConfig.blockSizeVertical*6,
          width: double.infinity,
          color: Colors.indigo.shade700,
          child: Row(
            children: [
              SizedBox(width: SizeConfig.blockSizeHorizontal*7,),
              Container(
                //color: Colors.blue,
                height: SizeConfig.blockSizeVertical*5,
                width: SizeConfig.blockSizeHorizontal*83,
                //
                //
                // color: Colors.indigo.shade700,
                child: Center(
                  child:
                  Text('Next',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2.3,fontWeight: FontWeight.bold),),
                ),
              ),

              // SizedBox(width: SizeConfig.blockSizeHorizontal*1,),
              Icon(Icons.arrow_forward_ios,color: Colors.white,size: SizeConfig.blockSizeVertical*3,)

            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*2,
                  right: SizeConfig.blockSizeHorizontal*2,
                  top:SizeConfig.blockSizeVertical*2,
                  bottom: SizeConfig.blockSizeVertical*3
              ),
              child: Container(
                height: SizeConfig.blockSizeVertical*50,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Padding(
                  padding:  EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal*3,
                      top: SizeConfig.blockSizeVertical*2
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'First Name',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical*2.0,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical*1.5,),
                      firstNameTextBox(),
                      SizedBox(height: SizeConfig.blockSizeVertical*1.5,),
                      Text(
                          'Last Name',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical*2.0,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical*1.5,),
                      lastNameTextBox(),
                      SizedBox(height: SizeConfig.blockSizeVertical*1.5,),
                      Text(
                          'Phone number',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical*2.0,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical*1.5,),
                      phoneNumberTextBox(),



                    ],
                  ),
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
  Widget phoneNumberTextBox() {
    SizeConfig().init(context);
    final infoOfPerson  = Provider.of<PersonalUpdateInfo>(context);
    return Container(
      width: SizeConfig.blockSizeHorizontal*90, //266.0,
      height: SizeConfig.blockSizeVertical*6.2, //48.0,

      color: Colors.white,
      child: Padding(
          padding:  EdgeInsets.only(
            left:SizeConfig.blockSizeHorizontal*2.4,
            top: SizeConfig.blockSizeVertical*1.3,
            bottom: SizeConfig.blockSizeVertical*1.3,
          ),
          child: Text(infoOfPerson.phoneNumber??'',)
      ),
      // ),
    );
  }
  Widget firstNameTextBox(){
    SizeConfig().init(context);
    final infoOfPerson  = Provider.of<PersonalUpdateInfo>(context);
    return Container(
      width: SizeConfig.blockSizeHorizontal*90, //266.0,
      height: SizeConfig.blockSizeVertical*6.2, //48.0,

      color: Colors.white,
      child: Padding(
        padding:  EdgeInsets.only(
          left:SizeConfig.blockSizeHorizontal*2,
          //  top: SizeConfig.blockSizeVertical*0.7,
          bottom: SizeConfig.blockSizeVertical*1.0,
        ),
        child: TextField(
          controller: firstNameController,
          decoration:  InputDecoration(
              border: InputBorder.none
          ),

          onChanged:infoOfPerson.setFirstName,
          onSubmitted:infoOfPerson.setFirstName,

        ),
      ),
      //),
    );
  }
  Widget lastNameTextBox(){
    SizeConfig().init(context);
    final infoOfPerson  = Provider.of<PersonalUpdateInfo>(context);
    return  Container(
      width: SizeConfig.blockSizeHorizontal*90, //266.0,
      height: SizeConfig.blockSizeVertical*6.2,
      color: Colors.white,

      child: Padding(
        padding:  EdgeInsets.only(
          left:SizeConfig.blockSizeHorizontal*2,
          // top: SizeConfig.blockSizeVertical*1.0,
          bottom: SizeConfig.blockSizeVertical*1.0,
        ),
        child: TextField(
          controller: lastNameController,
          decoration:  InputDecoration(

              border: InputBorder.none


          ),

          onChanged:infoOfPerson.setLastName,
          onSubmitted:infoOfPerson.setLastName,

        ),
      ),
      // ),
    );
  }
}
