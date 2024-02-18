import 'dart:convert';
import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/Routing/constrants.dart';
import 'package:dhopai/utils/helper_class.dart';
import 'package:dhopai/orderFile/DeliveyModelClasses/deliveryModelClass.dart';

import 'package:dhopai/orderFile/order_details.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Repository/log_debugger.dart';
import '../utils/Size.dart';
import '../Side_Navigator/main_side_bar.dart';
import 'addressmodification/delivery_info.dart';
class CashMemo extends StatefulWidget {
  int? total;
  CashMemo({Key? key,this.total}) : super(key: key);

  @override
  State<CashMemo> createState() => _CashMemoState();
}

class _CashMemoState extends State<CashMemo> with AutomaticKeepAliveClientMixin<CashMemo> {
  String? currentAddress;
  String? pickUpAddress;
  String? deliveryAddress;
  Position? currentPosition;
  bool checkBoxValue=false;
  int modification=0;
  int total=0;
  int? selectedAreaId;
  int? selectedZoneId;
  String postcode=' ';
  String streetAddress=' ';
  var postcodeController=TextEditingController();
  var streetController=TextEditingController();
  var cityController=TextEditingController();
  List<String> addresses=[];
  String? area;
  String? zone;
  String? place;
  int? labelId;
  int addressIdPickUp=0;
  int addressIdDelivery=0;
  String city='';
  bool isSelectedArea=false;
  bool isSelectedZone=false;
  bool isSelectedlabel=true;
  // bool pickUpAddressStastus=false;
  bool  modifiedDeliveryAddress=false;
  bool  modifiedPickUpAddress=false;
  int selectedRadioTile=0;
  int temp =0;
  String deliveryType='';
  String time='';
  int deliveryAmount=0;
  Map<String,dynamic>? map1,map2;
  bool selectedMethod=false;

  Repository repo=Repository();



  /* Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      Future.delayed(const Duration(milliseconds: 800), (){
        setState(()  {
          currentPosition = position;
          print('current position $currentPosition');
          getAddressFromLatLng();
        } );
      });

    }).catchError((e) {
      debugPrint(e);
    });
  }
  Future<void> getAddressFromLatLng() async {
    // await getCurrentPosition();
    if(currentPosition!=null){
      await placemarkFromCoordinates(
          currentPosition!.latitude,
          currentPosition!.longitude
      ).then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        setState(() {
          currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
          addresses.add(currentAddress!);
        });
        print(currentAddress);
        print(place.street);
        print(place.subLocality);
        print(place.subAdministrativeArea);
        print(place.postalCode);
      }

      ).catchError((e) {
        debugPrint(e);
      });
    }
  }*/


  getTotal() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      total=prefs.getInt('subTotal')!;

    });

  }



  @override
  void initState() {
    // final PickUpInfo infoOfPickUp = Provider.of<PickUpInfo>(context, listen: false);
    // TODO: implement initState
    /* setState(() {
       loadPickAddress();
       loadDeliveryAddress();
     });*/
    setState(() {
      pickUpAddress='';
      deliveryAddress='';
    });
    repo.pickUpAddressShowInBox().then((value) {
      setState(() {

        map1=value;
        pickUpAddress='${map1!['address_line_1']},${map1!['area']['name']},${map1!['zone']['title']},${map1!['city']},${map1!['zip']}';
        print(pickUpAddress);
        if(pickUpAddress!=null){
          modifiedPickUpAddress=true;
        }
      });
      print('pick up address $pickUpAddress');
    });
    repo.deliveryAddressShowInBox().then((value) {
      setState(() {
        //  deliveryAddress='';
        map2=value;
        deliveryAddress='${map2!['address_line_1']},${map2!['area']['name']},${map2!['zone']['title']},${map2!['city']},${map2!['zip']}';
        print(deliveryAddress);
        if(deliveryAddress!=null){
          modifiedDeliveryAddress=true;
        }
      });
    });
   // repo.deliveryInfo();
    //  getServiceAreaData();
    // getLabelData();
    getTotal();
    super.initState();
    //getAddressFromLatLng();
    //  getCurrentPosition();
  }
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    LogDebugger.instance.i('cash memo');
    super.build(context);
    SizeConfig().init(context);
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.indigo.shade500,
        title: Text('Service',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2.9),),
        leading: Builder(builder: (BuildContext context)=>IconButton(
          onPressed:()=> Scaffold.of(context).openDrawer(),
          icon: /* Padding(
            padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*1.2,bottom: SizeConfig.blockSizeVertical*2),
            child: */
          Icon(
            Icons.menu,
            color: Colors.white,
            size: SizeConfig.blockSizeVertical*4,
          ),
          //  ),
        ),
        ),
      ),
      /*PreferredSize(
        preferredSize: const Size.fromHeight(63.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title:Padding(
            padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*3.0,bottom: SizeConfig.blockSizeVertical*2),
            child: Text('Service',style: TextStyle(color: Colors.white),),
          ),
          /*Padding(
              padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*3.5,bottom: SizeConfig.blockSizeVertical*2),
              child: const FittedBox(child: Text('Pickup Address ',style: TextStyle(color: Colors.black45),)),
            ),*/
          backgroundColor: Colors.indigoAccent.shade700,

          leading:Builder(builder: (BuildContext context)=>IconButton(
            onPressed:()=> Scaffold.of(context).openDrawer(),
            icon:  Padding(
              padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*1.2,bottom: SizeConfig.blockSizeVertical*2),
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: SizeConfig.blockSizeVertical*4,
              ),
            ),
           ),
          ),
        ),
      ),*/
      bottomSheet: Container(
        height: SizeConfig.blockSizeVertical*11.5,
        width: double.infinity,
        //color: Colors.blue,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 6,
              blurRadius: 6,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          // borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(width: SizeConfig.blockSizeHorizontal*5,),
            Icon(Icons.info,color: Colors.black38,size: SizeConfig.blockSizeVertical*3.5,),
            SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
            Text('Total:',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.5,fontWeight: FontWeight.bold),),
            SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
            Padding(
              padding:  EdgeInsets.only(top: SizeConfig.blockSizeVertical*0.5),
              child: Text('৳${total}',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,fontWeight: FontWeight.normal),),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal*12.5,),
            GestureDetector(
              onTap: () async {
                //repo.deliveryInfo();
                if(selectedMethod==true){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>PaymentOrder(
                        deliveryType:deliveryType,
                        time:time,
                        deliveryCharge:deliveryAmount,
                      ))
                  );
                 /* Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>PaymentOrder(
                    deliveryType:deliveryType,
                    time:time,
                    deliveryCharge:deliveryAmount,
                  )));*/
                }
              },
              child: Container(

                height: SizeConfig.blockSizeVertical*8,
                width: SizeConfig.blockSizeHorizontal*40,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                  color: selectedMethod?Colors.indigo.shade600:Colors.grey.shade700,
                ),
                child: Center(child: Text('CONFIRM',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2),)),
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: MainSideBar(),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top:SizeConfig.blockSizeVertical*3,
              left:SizeConfig.blockSizeHorizontal*4.5,
              right:SizeConfig.blockSizeHorizontal*4,
              // bottom: SizeConfig.blockSizeVertical*1
            ),
            child: Text('Address Details:',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.5,fontWeight: FontWeight.bold),),
          ),
          // addressModification(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                showPickUpAddress('Pick up Address'),
                showDeliveryAddress('Delivery Address'),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
                top:SizeConfig.blockSizeVertical*1.5,
                left:SizeConfig.blockSizeHorizontal*4.5,
                right:SizeConfig.blockSizeHorizontal*4,
                bottom: SizeConfig.blockSizeVertical*1
            ),
            child: Text('Shipping Method',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.5,fontWeight: FontWeight.bold),),
          ),

          SizedBox(height: SizeConfig.blockSizeVertical*2.5,),

          radioButtonGenerate(),

          SizedBox(height: SizeConfig.blockSizeVertical*15,)
        ],
      ),
    );
  }
  Widget orderedList(String pName,String service,int qty, int money){
    SizeConfig().init(context);
    return  Column(
      children: [
        Padding(
          padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*6.5,top: SizeConfig.blockSizeVertical*1.3),
          child: Row(
            children: [
              Container(
                //color: Colors.blue,
                height: SizeConfig.blockSizeVertical*4.5,
                width: SizeConfig.blockSizeHorizontal*18,
                child: Text('$pName',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.5,color: Colors.black),),
              ),
              //  SizedBox(width: 20,),
              Container(
                // color: Colors.red,
                  height: SizeConfig.blockSizeVertical*4.5,
                  width: SizeConfig.blockSizeHorizontal*37,
                  child: Padding(
                    padding:  EdgeInsets.only(top: SizeConfig.blockSizeVertical*.4),
                    child: Text('$service',style: TextStyle(fontSize:  SizeConfig.blockSizeVertical*2.0,color: Colors.blue),),
                  )
              ),
              // SizedBox(width: 20,),
              Container(
                // color: Colors.blue,
                  height: SizeConfig.blockSizeVertical*4.5,
                  width: SizeConfig.blockSizeHorizontal*20,
                  child: Text('Qty:$qty',style: TextStyle(fontSize:  SizeConfig.blockSizeVertical*2.3,color: Colors.black),)
              ),
              // SizedBox(width: 20,),
              Container(
                //color: Colors.yellow,
                  height:SizeConfig.blockSizeVertical*4.5,
                  width: SizeConfig.blockSizeHorizontal*18,
                  child: Text("${qty*money}/-",style: TextStyle(fontSize:  SizeConfig.blockSizeVertical*2.3,color: Colors.black),)
              ),

            ],
          ),
        ),
        Container(
          //color: Colors.white,
          height: SizeConfig.blockSizeVertical*0.2, width: SizeConfig.blockSizeHorizontal*89,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
        ),

      ],
    );

  }
  Widget shippingMethods(String name,int id,String description,String amount){
    return Padding(
      padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*5.0,right:SizeConfig.blockSizeHorizontal*5.0 ),
      child: Container(

        height: SizeConfig.blockSizeVertical*13.2, width: SizeConfig.blockSizeHorizontal*85,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          //  borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade100,
        ),
        child: RadioListTile<int>(
          value: id,
          groupValue: selectedRadioTile,
          toggleable:  true,
          activeColor: Colors.redAccent.shade700,
          selected: selectedRadioTile==id,
          title: Padding(
            padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*2.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$name($description)",style: TextStyle(color: Colors.black,fontSize: SizeConfig.blockSizeVertical*2),),
                SizedBox(height: SizeConfig.blockSizeVertical*0.8,),
                Text('৳$amount'),
              ],
            ),
          ),
          onChanged: (int? value)async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            print('previous ${value} ');
            print('value is ${value}');
            print('charge id is $id');
            print('charge amount is $amount');
            prefs.setInt('chargeId', id);
            prefs.setInt('charge', int.parse(amount));
            print(prefs.getInt('chargeId'));
            print(prefs.getInt('charge'));

            setState(() {
              selectedRadioTile=value! ;
              print("radiotile ${selectedRadioTile}");
              total=total+int.parse(amount)-temp;
              prefs.setInt('total_with_charge', total);
              temp = int.parse(amount);
              deliveryType=name;
              time=description;
              deliveryAmount=temp;
              selectedMethod= true;
            });
          },
        ),

      ),
    );
  }


  Widget showPickUpAddress(String title){
    return  Padding(
      padding:  EdgeInsets.only(
          top:SizeConfig.blockSizeVertical*2,
          left:SizeConfig.blockSizeHorizontal*3.5,
          right:SizeConfig.blockSizeHorizontal*4,
          bottom: SizeConfig.blockSizeVertical*2
      ),
      child: Container(
        //color: Colors.blue,
          height:SizeConfig.blockSizeVertical*20,
          width:SizeConfig.blockSizeHorizontal*95,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                    top:SizeConfig.blockSizeVertical*3,
                    left:SizeConfig.blockSizeHorizontal*3.5,
                    right:SizeConfig.blockSizeHorizontal*4,
                    // bottom: SizeConfig.blockSizeVertical*2
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3,color: Colors.cyan.shade700),),
                      SizedBox(height: SizeConfig.blockSizeVertical*2,),
                      modifiedPickUpAddress==true ?
                      Container(
                        // color: Colors.blue,
                        height: SizeConfig.blockSizeVertical*8.0,
                        // width: SizeConfig.blockSizeHorizontal*90,
                        child:  Text('${pickUpAddress ?? ""}',
                          style: TextStyle(fontSize:SizeConfig.blockSizeVertical*2.3, ),
                        ),
                      ) :Container(),
                    ],
                  )
              ),

            ],
          )


      ),
    );
  }
  Widget showDeliveryAddress(String title){
    return  Padding(
      padding:  EdgeInsets.only(
          top:SizeConfig.blockSizeVertical*2,
          left:SizeConfig.blockSizeHorizontal*3.5,
          right:SizeConfig.blockSizeHorizontal*4,
          bottom: SizeConfig.blockSizeVertical*2
      ),
      child: Container(
        // color: Colors.blue,
          height:SizeConfig.blockSizeVertical*20,
          width:SizeConfig.blockSizeHorizontal*95,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                    top:SizeConfig.blockSizeVertical*3,
                    left:SizeConfig.blockSizeHorizontal*3.5,
                    right:SizeConfig.blockSizeHorizontal*4,
                    // bottom: SizeConfig.blockSizeVertical*2
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3,color: Colors.cyan.shade700),),
                      SizedBox(height: SizeConfig.blockSizeVertical*1,),
                      modifiedDeliveryAddress==true?
                      Container(
                        //  color: Colors.blue,
                          height: SizeConfig.blockSizeVertical*10.0,
                          child:  Text(
                            '${deliveryAddress ?? ""}',
                            style: TextStyle(
                                fontSize:SizeConfig.blockSizeVertical*2.3 ),)
                      ):Container(),
                    ],
                  )
              ),

            ],
          )


      ),
    );
  }
  Widget radioButtonGenerate(){
    return  FutureBuilder<List<DeliveryInfoModel>>(
        future:repo.deliveryInfo(),
        builder: (BuildContext context,AsyncSnapshot<List<DeliveryInfoModel>> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              print('inside building radio');
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder:(context,index){
                    return shippingMethods(
                        snapshot.data![index].name.toString(),
                        snapshot.data![index].id!,
                        snapshot.data![index].decription.toString(),
                        snapshot.data![index].amount.toString()
                    );
                  }
              );
            }
            else{
              return const Center(
                child: CircularProgressIndicator(),
              );

            }
          }

          else{
            return const Center(
              child: CircularProgressIndicator(),
            );

          }
        }

    );
  }
}
