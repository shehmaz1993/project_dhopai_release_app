import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhopai/Profile/edit_profile.dart';
import 'package:dhopai/promotion/support_page.dart';
import 'package:dhopai/utils/Size.dart';
import 'package:dhopai/promotion/notification.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Profile/edit_profile_provider.dart';
import '../Repository/repository.dart';
import '../SignIn/sign_in.dart';
import '../authentication/Reset_Phone_Number/reset_phone_number.dart';
import '../authentication/Reset_password/forget_password.dart';
import '../home.dart';
import '../orderFile/order_rev.dart';
import '../promotion/offers_page.dart';
import '../utils/helper_class.dart';
import '../widgets/webview_page.dart';
import 'main_side_bar_provider.dart';

class MainSideBar extends StatefulWidget {
  const MainSideBar({Key? key}) : super(key: key);

  @override
  State<MainSideBar> createState() => _MainSideBarState();
}

class _MainSideBarState extends State<MainSideBar> with AutomaticKeepAliveClientMixin<MainSideBar> {
  bool isLogIn =false;
  bool isLogInNot =false;
  int numberOfProduct=0;
  int? customerId;
  String? image;
  String? phone;
  String? name;
  Repository repo=Repository();
  loadNumberOfProduct()async{
    print('inside load number function');
    numberOfProduct= await repo.countProduct();
    print(numberOfProduct);
    setState(()  {

    });
  }
  checkLoggedInOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('token')==''||prefs.getString('token')==null){
      setState(() {
        isLogIn=false;
      });
    }else{
      setState(() {
        isLogIn=true;
      });
    }

  }
 /* getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image= prefs.getString('image');
    });
  }
  getIdAndPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId= prefs.getInt('customer_id');
      phone = prefs.getString('phone');
      name =prefs.getString('name');
    });
  }*/
  @override
  void initState() {
    //final MainSideBarInfo mainSideBarInfo = Provider.of<MainSideBarInfo>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      await Provider.of<MainSideBarInfo>(context,listen: false).updateInfo().then((value) => print(value));

    });
    checkLoggedInOrNot();
   // getDetails();
    //getIdAndPhone();
    loadNumberOfProduct();
    super.initState();

  }
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig().init(context);

    final mainSideBarInfo  = Provider.of<MainSideBarInfo>(context);
    return Scaffold(
      body:  Drawer(
        child: Container(

          child: Column(
            children: [
              Visibility(
                visible: isLogIn,
                child: Expanded(
                  flex: 3,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade400
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width:SizeConfig.blockSizeVertical*12, //80,
                          height:SizeConfig.blockSizeVertical*12, //80,
                          decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [ BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1.0,
                              ),]
                          ),
                          child: CachedNetworkImage(
                            alignment: Alignment.center,
                            imageUrl:Helper.BASE_URL+ mainSideBarInfo.imgString,
                            imageBuilder: (context, imageProvider) => CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: imageProvider,
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.person),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3.5),
                              child: Text(
                                mainSideBarInfo.fullName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical*1.7, color: Colors.white),
                              ),
                            ),
                            Text(
                              "${mainSideBarInfo.phone
                              }",
                              style: TextStyle(fontSize: SizeConfig.blockSizeVertical*1.7, color: Colors.white),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 11,
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: isLogIn==false,
                            child: SizedBox(height: SizeConfig.blockSizeVertical*20,)),
                        Visibility(
                          visible: isLogIn==false,
                          child: Padding(
                            padding:  EdgeInsets.only(
                                left:SizeConfig.blockSizeHorizontal*2,
                                top: SizeConfig.blockSizeVertical*22
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInPage()));
                                if(result == true){
                                  setState(() {
                                    checkLoggedInOrNot();
                                   // getDetails();
                                    //getIdAndPhone();
                                    mainSideBarInfo.updateInfo();
                                    loadNumberOfProduct();
                                  });
                                }
                              },
                              child: Text('Log in/Create Account',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: SizeConfig.blockSizeVertical*2.3,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Visibility(child: SizedBox(height: SizeConfig.blockSizeVertical*2.0,),
                      visible: !isLogIn,
                    ),
                    Container(
                        height: SizeConfig.blockSizeVertical*7,
                        // color: Colors.indigo,
                        child: ListTile(
                          selectedColor: Colors.indigo.shade100,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          },
                          leading: Icon(
                            Icons.home,
                            color:Colors.black45,
                            size: SizeConfig.blockSizeVertical*3.5,
                          ),
                          title: Text(
                            "Home",
                            style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.3 ) ,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                          dense: true,
                        )
                    ),
                    //  SizedBox(height: SizeConfig.blockSizeVertical*3,),

                    Visibility(
                      visible: isLogIn==true,
                      child: Container(
                        height: SizeConfig.blockSizeVertical*7,
                        // color: Colors.indigo,
                        child: ListTile(
                          selectedColor: Colors.indigo.shade100,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderRev()));
                          },
                          leading:badges.Badge(
                            badgeContent: Text(numberOfProduct.toString()),
                            badgeAnimation: badges.BadgeAnimation.rotation(
                              animationDuration:Duration(milliseconds: 300) ,
                            ),
                            child: Icon(Icons.shopping_basket),
                          ),
                          title: Text(
                            "Carts",
                            style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.2 ) ,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                          dense: true,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isLogIn==true,
                      child: Container(
                        height: SizeConfig.blockSizeVertical*7,
                        // color: Colors.indigo,
                        child: ListTile(
                          selectedColor: Colors.indigo.shade100,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OfferPage()));
                          },
                          leading: Icon(
                            Icons.notifications_active_outlined,
                            color:Colors.black45,
                            size: SizeConfig.blockSizeVertical*3.5,
                          ),
                          title: Text(
                            "Offer",
                            style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.2 ) ,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                          dense: true,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isLogIn==true,
                      child: Container(
                        height: SizeConfig.blockSizeVertical*7,
                        // color: Colors.indigo,
                        child: ListTile(
                          selectedColor: Colors.indigo.shade100,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  EditProfile()));
                          },
                          leading: Icon(
                            Icons.account_circle_rounded,
                            color:Colors.black45,
                            size: SizeConfig.blockSizeVertical*3.5,
                          ),
                          title: Text(
                            "Profile",
                            style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.2 ) ,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                          dense: true,
                        ),
                      ),
                    ),
                    Visibility(
                      visible:isLogIn==true,
                      child: Container(
                          height: SizeConfig.blockSizeVertical*7,
                          // color: Colors.indigo,
                          child: ListTile(
                            selectedColor: Colors.indigo.shade100,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupportPage()));
                            },
                            leading: Icon(
                              Icons.help_outline,
                              color:Colors.black45,
                              size: SizeConfig.blockSizeVertical*3.5,
                            ),
                            title: Text(
                              "Help Center",
                              style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.2 ) ,
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                            dense: true,
                          )
                      ),
                    ),
                    // Visibility(
                    //   visible:isLogIn==true,
                    //   child: Container(
                    //       height: SizeConfig.blockSizeVertical*7,
                    //       // color: Colors.indigo,
                    //       child: ListTile(
                    //         selectedColor: Colors.indigo.shade100,
                    //         onTap: () {
                    //           /* Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => OrderRev()));*/
                    //         },
                    //         leading: Icon(
                    //           Icons.business,
                    //           color:Colors.black45,
                    //           size: SizeConfig.blockSizeVertical*3.5,
                    //         ),
                    //         title: Text(
                    //           "Dhopai for business",
                    //           style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.2 ) ,
                    //         ),
                    //         contentPadding:
                    //         const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                    //         dense: true,
                    //       )
                    //   ),
                    // ),
                    // Visibility(
                    //   visible:isLogIn==true,
                    //   child: Container(
                    //       height: SizeConfig.blockSizeVertical*7,
                    //       // color: Colors.indigo,
                    //       child: ListTile(
                    //         selectedColor: Colors.indigo.shade100,
                    //         onTap: () {
                    //           /* Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => OrderRev()));*/
                    //         },
                    //         leading: Icon(
                    //           Icons.group,
                    //           color:Colors.black45,
                    //           size: SizeConfig.blockSizeVertical*3.5,
                    //         ),
                    //         title: Text(
                    //           "Invite Friends",
                    //           style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.2 ) ,
                    //         ),
                    //         contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                    //         dense: true,
                    //       )
                    //   ),
                    // ),
                    Visibility(
                      visible: isLogIn == true,
                      child: Container(
                          height: SizeConfig.blockSizeVertical*7,
                          // color: Colors.indigo,
                          child: ListTile(
                            selectedColor: Colors.indigo.shade100,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPhoneNumber())
                              );
                            },
                            leading: Icon(
                              Icons.phone,
                              color:Colors.black45,
                              size: SizeConfig.blockSizeVertical*3.5,
                            ),
                            title: Text(
                              "Change Phone Number",
                              style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.3 ) ,
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                            dense: true,
                          )
                      ),
                    ),
                    Visibility(
                      visible: isLogIn == true,
                      child: Container(
                          height: SizeConfig.blockSizeVertical*7,
                          // color: Colors.indigo,
                          child: ListTile(
                            selectedColor: Colors.indigo.shade100,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetPasswordPage()));
                            },
                            leading: Icon(
                              Icons.paste_sharp,
                              color:Colors.black45,
                              size: SizeConfig.blockSizeVertical*3.5,
                            ),
                            title: Text(
                              "Change Password",
                              style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.3 ) ,
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                            dense: true,
                          )
                      ),
                    ),
                    Container(
                        height: SizeConfig.blockSizeVertical*7,
                        // color: Colors.indigo,
                        child: ListTile(
                          selectedColor: Colors.indigo.shade100,
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => WebViewPage(
                                        title: 'Terms and conditions',
                                        url:'https://api.dhopai.com/terms_condition'
                                    )
                                )

                            );
                          },
                          leading: Icon(
                            Icons.rule_folder,
                            color:Colors.black45,
                            size: SizeConfig.blockSizeVertical*3.5,
                          ),
                          title: Text(
                            "Terms and conditions",
                            style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.3 ) ,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                          dense: true,
                        )
                    ),
                    Visibility(
                      visible: isLogIn==true,
                      child: Container(
                        height: SizeConfig.blockSizeVertical*7,
                        // color: Colors.indigo,
                        child: ListTile(
                          selectedColor: Colors.indigo.shade100,
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String message= await  repo.logOut();
                            if(message=="Logout Successfully"){
                              prefs.remove('customer_id');
                              prefs.remove('token');
                              prefs.remove('phone');
                              prefs.remove('pickUpId');
                              prefs.remove('shippingId');
                              //prefs.setString('token', '');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  Home()));
                            }else{
                              Fluttertoast.showToast(msg: 'Something went wrong');
                            }
                            /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  MyProfile()));*/
                          },
                          leading: Icon(
                            Icons.logout,
                            color:Colors.black45,
                            size: SizeConfig.blockSizeVertical*3.5,
                          ),
                          title: Text(
                            "Log out",
                            style:TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*2.2 ) ,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                          dense: true,
                        ),
                      ),
                    ),
                  ],

                ),
              )
            ],
          ),
        ),
      ),
    );

  }
}
