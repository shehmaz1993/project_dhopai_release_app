import 'dart:io';
import 'package:dhopai/Repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/Size.dart';
import '../utils/helper_class.dart';
import 'edit_profile_provider.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var fname=TextEditingController();
  var lname=TextEditingController();
  var nid =TextEditingController();
  var email=TextEditingController();
  var phone=TextEditingController();
  String? image;
  int? id;
  @override
  void initState() {
    final ProfileInfoProvider profileInfo = Provider.of<ProfileInfoProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      await Provider.of<ProfileInfoProvider>(context,listen: false).updateInfo();
      phone=TextEditingController(text: profileInfo.phone);
      fname=TextEditingController(text: profileInfo.fName);
      lname=TextEditingController(text: profileInfo.lName);
    });

    // TODO: implement initState
    super.initState();
    getSharedInfo();
    phone=TextEditingController(text: profileInfo.phone);
    fname=TextEditingController(text: profileInfo.fName);
    lname=TextEditingController(text: profileInfo.lName);
    email=TextEditingController(text: profileInfo.email);
    nid=TextEditingController(text: profileInfo.nid);
  }
  getSharedInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image=prefs.getString('image');
      id= prefs.getInt('customer_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileInfo  = Provider.of<ProfileInfoProvider>(context);
    SizeConfig().init(context);
    print(profileInfo.imageFile);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Profile', style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: ()=>{
              Navigator.pop(context)
            },
            color: Colors.white,
          ),
        ),
        body: ListView(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical*3,
                          left: SizeConfig.blockSizeHorizontal*8
                      ),
                      child: CircleAvatar(
                          radius: SizeConfig.blockSizeVertical*8.8,
                          backgroundColor: Colors.orange.shade200,
                          child: profileInfo.imgString.isNotEmpty
                              ?Container(
                            height: SizeConfig.blockSizeVertical*15,
                            width: SizeConfig.blockSizeHorizontal*34.3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              // border: Border.all(color: Colors.blueAccent)

                            ),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                  size: Size.fromRadius(60), // Image radius
                                  child:profileInfo.croppedFile!=null? Image.file(
                                    File(profileInfo.croppedFile!.path),
                                    fit: BoxFit.cover,
                                  )
                                  :Image.network(
                                    Helper.BASE_URL+ profileInfo.imgString.toString(),
                                    fit:BoxFit.fill ,
                                  )
                              ),
                            ),
                          )
                              : Container(
                            height: SizeConfig.blockSizeVertical*16,
                            width: SizeConfig.blockSizeHorizontal*35,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle
                            ),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                  size: Size.fromRadius(88), // Image radius
                                  child:profileInfo.croppedFile!=null? Image.file(
                                    File(profileInfo.croppedFile!.path),
                                    fit: BoxFit.cover,
                                  )
                                      :Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: SizeConfig.blockSizeVertical*10,
                                  )
                              ),
                            ),
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical*16.2,
                          left: SizeConfig.blockSizeHorizontal*36.6
                      ),
                      child: GestureDetector(
                        onTap:()=> profileInfo.getFromGallery(),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/camera.png'),
                          radius: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*5,top: SizeConfig.blockSizeVertical*3),
                    child: Column(
                      children: [
                        Text(
                            '${profileInfo.fullName}'??' ',
                            style: TextStyle(color: Colors.black54,fontSize: SizeConfig.blockSizeVertical*2.4,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold)
                        ),
                        Row(
                          children: [
                            Text('Customer Id:',style: TextStyle(color: Colors.blueAccent,fontSize: SizeConfig.blockSizeVertical*2.0,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold),),
                            Text(id.toString(),style: TextStyle(color: Colors.black54,fontSize: SizeConfig.blockSizeVertical*2.0,fontStyle: FontStyle.normal),),
                          ],
                        ),
                      ],
                    )
                )
              ],
            ),

            SizedBox(height: SizeConfig.blockSizeVertical*7,),
            ListTile(
              /*leading: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 18.5,
                child: CircleAvatar(
                    radius: 17.5,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,color: Colors.blue,size: SizeConfig.blockSizeVertical*2,)
                ),
              ),*/
              title:Text('First Name',style: TextStyle(color: Colors.cyan.shade600,fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold),),
              subtitle://profileInfo.editfname==true?
              TextField(
                controller: fname,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  // labelText: '',
                  hintText: 'Enter First name',
                ),
                onChanged: profileInfo.setfName,
              ),
              // :Text(profileInfo.fName,style: TextStyle(color: Colors.black,fontSize: SizeConfig.blockSizeVertical*2.5),),
              /*trailing: IconButton(
                onPressed:  (){
                  profileInfo.setEditFname(true);
                },
                icon: Icon(Icons.more_vert),
              ),*/
            ),
            ListTile(
              /*leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 18.5,
                  child: CircleAvatar(
                      radius: 17.5,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person,color: Colors.blue,size: SizeConfig.blockSizeVertical*2,)
                  ),
                ),*/
              title:Text('Last Name',style: TextStyle(color: Colors.cyan.shade600,fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold),),
              subtitle://profileInfo.editlname==true?
              TextField(
                controller: lname,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  // labelText: '',
                  hintText: 'Enter last name',
                ),
                onChanged: profileInfo.setlName,
              ),//:Text(profileInfo.lName,style: TextStyle(color: Colors.black,fontSize: SizeConfig.blockSizeVertical*2.5),),
              //
              /*trailing: IconButton(
                  onPressed: (){
                    profileInfo.setEditLname(true);
                  },
                  icon: Icon(Icons.more_vert),
                )*/
            ),
            ListTile(
              /*leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 18.5,
                  child: CircleAvatar(
                      radius: 17.5,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.email,color: Colors.orangeAccent,size: SizeConfig.blockSizeVertical*2,)
                  ),
                ),*/
                title:Text('Email',style: TextStyle(color: Colors.cyan.shade600,fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold),),
                subtitle://profileInfo.editMail==true?
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                    // labelText: '',
                    hintText: 'Enter Email',
                  ),
                  onChanged: profileInfo.setEmail,
                )
              //   :Text(profileInfo.email,style: TextStyle(color: Colors.black45,fontSize: SizeConfig.blockSizeVertical*2.5),),
              /* trailing: IconButton(
                  onPressed:  (){
                    profileInfo.setEditEmail(true);
                  },
                  icon: Icon(Icons.more_vert),
                )*/
            ),
           /* ListTile(
              /* leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 18.5,
                  child: CircleAvatar(
                      radius: 17.5,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.phone,color: Colors.green,size: SizeConfig.blockSizeVertical*2,)
                  ),
                ),*/
                title:Text('Phone No',style: TextStyle(color: Colors.cyan.shade600,fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold),),
                subtitle://profileInfo.editPhone==true?
                TextField(
                  controller: phone,
                  decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                    // labelText: '',
                    hintText: 'phone no..',
                  ),
                  onChanged: profileInfo.setPhone,
                )//:Text(profileInfo.phone,style: TextStyle(color: Colors.black,fontSize: SizeConfig.blockSizeVertical*2.5),),
              /*trailing: IconButton(
                  onPressed: (){
                    profileInfo.setEditPhone(true);
                  } ,
                  icon: Icon(Icons.more_vert),
                )*/
            ),*/
            /*
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 18.5,
                child: CircleAvatar(
                    radius: 17.5,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.perm_device_information_sharp,color: Colors.primaries.first,size: SizeConfig.blockSizeVertical*2,)
                ),
              ),
              title:Text('NID',style: TextStyle(color: Colors.blueAccent,fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold),),
              subtitle:profileInfo.editNid==true? TextField(
                controller: nid,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  // labelText: '',
                  hintText: 'NID..',
                ),
                onChanged: profileInfo.setNid,
              )
                  :Text(profileInfo.nid,style: TextStyle(color: Colors.black45,fontSize: SizeConfig.blockSizeVertical*2.5),),
              trailing: IconButton(
                onPressed: (){
                  profileInfo.setEditNid(true);
                },
                icon: Icon(Icons.more_vert),
              ),
            ),*/
            Padding(
              padding:  EdgeInsets.only(
                  left:SizeConfig.blockSizeHorizontal*5,
                  right: SizeConfig.blockSizeHorizontal*5,
                  top: SizeConfig.blockSizeVertical*6,
                  bottom: SizeConfig.blockSizeVertical*2
              ),
              child:  ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    // shape: const CircleBorder(),
                  ),
                  onPressed: () async {
                    Repository rp= Repository();
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    // rp.updateProfile(profileInfo.fName, profileInfo.lName, profileInfo.imageFile!,'1234','1234',profileInfo.imageData!,context);
                    var   response = await rp.userBillingUpdate(
                        profileInfo.fName,
                        profileInfo.lName
                    );
                    var statusInfo = await rp.updatePhoto(File(profileInfo.croppedFile!.path));
                    if( statusInfo=='Data Saved' && response=='Customer update successfully.'){
                      prefs.setString('name', '${profileInfo.fName} ${profileInfo.lName}');
                      print('name is ${prefs.getString('name')}');
                      Fluttertoast.showToast(msg: 'Profile update successful!');
                    }
                    else{
                      Fluttertoast.showToast(msg: 'Something went wrong while profile updating');
                    }
                  },
                  child: Center(
                    child: Text('Save',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold),),
                  )
              ),

            )


          ],
        )
    );
  }

}
