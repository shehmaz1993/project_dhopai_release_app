import 'dart:convert';

import 'package:dhopai/orderFile/addressmodification/assressmodificationforpickupUPDATE.dart';
import 'package:dhopai/orderFile/addressmodification/delivery_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Repository/repository.dart';
import '../../Routing/constrants.dart';
import '../../utils/Size.dart';
import '../../utils/helper_class.dart';
import 'package:http/http.dart' as http;

import '../../Side_Navigator/main_side_bar.dart';
import '../cashmemo.dart';

class AddressModificationDeliveryUpdate extends StatefulWidget {

  AddressModificationDeliveryUpdate({Key? key}) : super(key: key);

  @override
  State<AddressModificationDeliveryUpdate> createState() => _AddressModificationDeliveryUpdateState();
}

class _AddressModificationDeliveryUpdateState extends State<AddressModificationDeliveryUpdate>
                                                       with AutomaticKeepAliveClientMixin<AddressModificationDeliveryUpdate> {
  var postcodeController=TextEditingController();
  var streetController=TextEditingController();
  var cityController=TextEditingController();
  String deliveryAddress='';
  Repository repo=Repository();
  Map<String,dynamic>? map;
  int i=0;
  bool _canPop = false;






  @override
  void initState() {
    final DeliveryInfo infoOfDelivery = Provider.of<DeliveryInfo>(context, listen: false);
    // TODO: implement initState
    print('inside function');
    if(infoOfDelivery.label.isEmpty){
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async{
        print('time stamp is $timeStamp');
        await  Provider.of<DeliveryInfo>(context,listen: false).getAllServiceAreasAndZones().then((value){print('got areas');});
        await  Provider.of<DeliveryInfo>(context,listen: false).getLabels().then((value){ print('got labels');});
        await Provider.of<DeliveryInfo>(context,listen: false).getInitialDropDownValues(context).then((value){print('need 1 time');});
        //await Provider.of<DeliveryInfo>(context,listen: false).settingInitialDropdownValues();
        cityController=TextEditingController(text: infoOfDelivery.city);
        postcodeController=TextEditingController(text: infoOfDelivery.postCode);
        streetController=TextEditingController(text: infoOfDelivery.street);

      });

    }

    super.initState();

    cityController=TextEditingController(text: infoOfDelivery.city);
    postcodeController=TextEditingController(text: infoOfDelivery.postCode);
    streetController=TextEditingController(text: infoOfDelivery.street);
  }
  loadEditedData(){
    final DeliveryInfo infoOfDelivery = Provider.of<DeliveryInfo>(context, listen: false);
    print('printed data ${infoOfDelivery.map}');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    cityController.dispose();
    postcodeController.dispose();
    streetController.dispose();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
     super.build(context);
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: ()async =>true,
      child: Scaffold(
        appBar:AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo.shade500,
          title: Text('Delivery Address ',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2.9),),
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
            // ),
          ),
          ),
        ),
        /*PreferredSize(
          preferredSize: const Size.fromHeight(63.0),
          child:AppBar(
            automaticallyImplyLeading: false,
            title:Padding(
              padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*3.0,bottom: SizeConfig.blockSizeVertical*2),
              child: Text('Delivery Address ',style: TextStyle(color: Colors.white),),
            ),
            /*Padding(
              padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*3.5,bottom: SizeConfig.blockSizeVertical*2),
              child: const FittedBox(child: Text('Pickup Address ',style: TextStyle(color: Colors.black45),)),
            ),*/
            backgroundColor: Colors.indigoAccent.shade700,
            // centerTitle: true,
            /*
            leading: Padding(

              padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*1.5,bottom: SizeConfig.blockSizeVertical*4),
              child: IconButton(
                onPressed: (){
                 // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>CashMemo()));
                  //  Navigator. of(context). pop();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                    return OrderRev();
                  }), (r){
                    return false;
                  });
                //  Navigator. of(context)..pop();
                 /* if (mounted) {
                    // if it is mounted then go to result screen, time is off bro..
                  //  Navigator.pushReplacement(context,
                    //    MaterialPageRoute(builder: (context) => CashMemo()));
                    //Navigator.pushNamed(context, cashMemo);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(cashMemo, (Route<dynamic> route) => false);
                  }*/
                },
                icon:const Icon(Icons.arrow_back,color: Colors.lightBlue,) ,

              ),
            ),*/
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
        drawer: Drawer(
          child: MainSideBar(),
        ),
        bottomNavigationBar: GestureDetector(
          onTap:() async {
            final infoOfDelivery  = Provider.of<DeliveryInfo>(context,listen:false);
             SharedPreferences prefs = await SharedPreferences.getInstance();
             prefs.setInt( 'delivery_area_id',infoOfDelivery.selectedAreaId!);

            var info=await repo.updateDeliveryAddress(
                infoOfDelivery.selectedAreaId!,
                infoOfDelivery.selectedZoneId!,
                1,
                infoOfDelivery.street,
                infoOfDelivery.city,//cityController.text.toString(),
                infoOfDelivery.postCode// postcodeController.text.toString()
            );

            if(info['success']==true){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>CashMemo())
              );
            }
            else{
              Fluttertoast.showToast(msg:"Something went wrong!");
            }




            EasyLoading.dismiss();
          },
          child: Container(
            height: SizeConfig.blockSizeVertical*6,
            width: double.infinity,
            color: Colors.indigo.shade700,
            child: Row(
              children: [
                SizedBox(width: SizeConfig.blockSizeHorizontal*7,),
                Container(
                  height: SizeConfig.blockSizeVertical*5,
                  width: SizeConfig.blockSizeHorizontal*83,

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
        body: ListView(
          children: [
            /* Padding(
              padding: EdgeInsets.only(
                  top:SizeConfig.blockSizeVertical*3,
                  left:SizeConfig.blockSizeHorizontal*4.5,
                  right:SizeConfig.blockSizeHorizontal*4,
                  bottom: SizeConfig.blockSizeVertical*1
              ),
              child: Text('Delivery Address',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3.0,fontWeight: FontWeight.bold),),
            ),*/
            // SizedBox(height: SizeConfig.blockSizeVertical*2.5,),
            addressModification(),
            SizedBox(height: SizeConfig.blockSizeVertical*1.4,),

          ],
        ),

      ),
    );
  }
  Widget addressModification(){
    final infoOfDelivery  = Provider.of<DeliveryInfo>(context);
    return Padding(
        padding:  EdgeInsets.only(
            top:SizeConfig.blockSizeVertical*2,
            left:SizeConfig.blockSizeHorizontal*2,
            right:SizeConfig.blockSizeHorizontal*2,
            bottom: SizeConfig.blockSizeVertical*2
        ),
        child: Container(
          // color: Colors.white,
            height:SizeConfig.blockSizeVertical*78,
            width:SizeConfig.blockSizeHorizontal*50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(2),
              color: Colors.grey.shade100,
            ),
            child: Consumer<DeliveryInfo>(
              builder: (context,value,child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height:SizeConfig.blockSizeVertical*2.8 ,),
                        /*Row(
                          children: [
                            SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
                            Text('Address label   :',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.3,fontWeight: FontWeight.bold) ,),
                            SizedBox(width: SizeConfig.blockSizeHorizontal*4,),

                            if(value.label.isEmpty)
                              const Center(child: CircularProgressIndicator(),)
                            else
                              DropdownButton<String>(
                                underline: Container(),
                                hint: Text('Select label'),
                                icon: Icon(Icons.keyboard_arrow_down_rounded),
                                // isDense: true,
                                //isExpanded: true,
                                items:infoOfDelivery.label.map((ar) {
                                  return DropdownMenuItem<String>(
                                    value: ar['lable'],
                                    child: Text(ar['lable']),
                                  );
                                }
                                ).toList(),
                                value: value.labelName!.isEmpty?null:value.labelName,
                                onChanged: (val) {
                                  setState(() {
                                    value.setLabelName(val!);
                                    print(value.labelName);
                                    for(int i=0;i<value.label.length;i++){
                                      if(value.label[i]['lable']==val){

                                        value.setLabelId(value!.label[i]['id']);

                                      }
                                    }
                                    // print(_zones);
                                    print(' label id ${infoOfDelivery.labelId}');
                                    value.setIsSelectedLabel(true);
                                  });

                                },

                              ),

                          ],
                        ),*/
                        // SizedBox(height:SizeConfig.blockSizeVertical*1.7 ,),
                        Padding(
                          padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: SizeConfig.blockSizeVertical*4,),
                              Text('Service area',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*1.9,fontWeight: FontWeight.bold) ,),
                              SizedBox(height: SizeConfig.blockSizeVertical*1.1,),

                              if(value.serviceArea.isEmpty)
                                const Center(child: CircularProgressIndicator(),)
                              else
                                Container(
                                  height: SizeConfig.blockSizeVertical*6.5,
                                  width: SizeConfig.blockSizeHorizontal*90,
                                  color: Colors.grey.shade300,
                                  child: Padding(
                                    padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      underline: Container(),
                                      hint: Text('Select area'),
                                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                                      // isDense: true,
                                      //isExpanded: true,
                                      items:value.serviceArea.map((ar) {
                                        return DropdownMenuItem<String>(
                                          value: ar['name'],
                                          child: Text(ar['name'],
                                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.3),
                                          ),
                                        );
                                      }
                                      ).toList(),
                                      value: value.selectedAreaName==null?null:value.selectedAreaName,
                                      onChanged: (val) async {
                                        value.setIsSelectedArea(false);
                                        value.setAreaName(null);
                                        value.setZones([]);
                                        value.setZoneName(null);
                                        value.setAreaName(val!);

                                        print(value.selectedAreaName);
                                        for(int i=0;i<value.serviceArea.length;i++){
                                          if(value.serviceArea[i]['name']==val){
                                            value.setAreaId(value.serviceArea[i]['id']);
                                            value.setAreaName(value.serviceArea[i]['name']);
                                            value.setZones(value.serviceArea[i]['zones']);
                                            print('Zones are ${value.zones}');
                                          }
                                        }
                                        print(infoOfDelivery.selectedAreaName);
                                        print(infoOfDelivery.selectedAreaId);
                                        print(value.zones);
                                        print('service area id ${value.selectedAreaId}');
                                        value.setIsSelectedArea(true);

                                      },

                                    ),
                                  ),
                                ),

                            ],
                          ),
                        ),
                        SizedBox(height:SizeConfig.blockSizeVertical*1.3),
                        if(value.isSelectedArea==true)
                          Padding(
                            padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Zone',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*1.9,fontWeight: FontWeight.bold) ,),
                                SizedBox(height: SizeConfig.blockSizeVertical*1,),
                                Container(
                                  height: SizeConfig.blockSizeVertical*6.5,
                                  width: SizeConfig.blockSizeHorizontal*90,
                                  color: Colors.grey.shade300,
                                  child: Padding(
                                    padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      underline: Container(),
                                      hint: Text('select zone'),
                                      icon: Icon(Icons.keyboard_arrow_down_rounded),

                                      items: value.zones.map((ar) {
                                        return DropdownMenuItem<String>(
                                          value: ar['title'],
                                          child: Text(
                                            ar['title'],
                                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.3),
                                          ),
                                        );
                                      }
                                      ).toList(),
                                      value: value.zone==''?null:value!.zone,
                                      onChanged: (String? newValue){
                                        value.setZoneName(newValue!);
                                        for(int i=0;i<value.zones.length;i++){
                                          if(value.zones[i]['title']==newValue){
                                            value.setZoneId(value.zones[i]['id']);
                                            print(value.selectedZoneId);
                                            value.setZoneName((value.zones[i]['title']));
                                            print(value.zone);
                                            break;
                                          }
                                        }
                                        value.setIsSelectedZone(true);
                                        print(value.zone);
                                        print('zone id is ${value.selectedZoneId}');
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        SizedBox(height:SizeConfig.blockSizeVertical*1.3 ,),
                        Padding(
                          padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('City',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*1.9,fontWeight: FontWeight.bold) ,),
                              SizedBox(height: SizeConfig.blockSizeVertical*1,),
                              Container(
                                // color: Colors.blue,
                                color: Colors.grey.shade300,
                                height: SizeConfig.blockSizeVertical*6.5,
                                width: SizeConfig.blockSizeHorizontal*90,
                                child: Padding(
                                  padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                                  child: TextField(
                                    controller: cityController,
                                    style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.3),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter city',
                                      contentPadding: EdgeInsets.only(
                                          bottom: SizeConfig.blockSizeHorizontal*0.11,
                                          top: SizeConfig.blockSizeVertical*0.12
                                      ),

                                    ),
                                    onChanged: infoOfDelivery.setCity,
                                    onSubmitted: infoOfDelivery.setCity,

                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical*1.3,),
                        Padding(
                          padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Post code',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*1.9,fontWeight: FontWeight.bold) ,),
                              SizedBox(height: SizeConfig.blockSizeVertical*1.5,),
                              Container(
                                // color: Colors.blue,
                                color: Colors.grey.shade300,
                                height: SizeConfig.blockSizeVertical*6.5,
                                width: SizeConfig.blockSizeHorizontal*90,
                                child: Padding(
                                  padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                                  child: TextField(
                                    controller: postcodeController,
                                    style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.3),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter postcode',
                                      contentPadding: EdgeInsets.only(
                                          bottom: SizeConfig.blockSizeHorizontal*0.11,
                                          top: SizeConfig.blockSizeVertical*0.12
                                      ),
                                    ),
                                    onChanged: infoOfDelivery.setPostCode,
                                    onSubmitted: infoOfDelivery.setPostCode,
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical*1.3,),
                        Padding(
                          padding: EdgeInsets.only(
                              left:SizeConfig.blockSizeHorizontal*3
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Street address',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*1.9,fontWeight: FontWeight.bold) ,),
                              SizedBox(height: SizeConfig.blockSizeHorizontal*2,),
                              Container(
                                // color: Colors.blue,
                                color: Colors.grey.shade300,
                                height: SizeConfig.blockSizeVertical*13,
                                width: SizeConfig.blockSizeHorizontal*90,
                                child: Padding(
                                  padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                                  child: TextField(
                                    controller: streetController,
                                    style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.3),
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter address'
                                    ),
                                    onChanged: infoOfDelivery.setStreet,
                                    onSubmitted: infoOfDelivery.setStreet,
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    infoOfDelivery.isSelectedArea==true?SizedBox(height: SizeConfig.blockSizeVertical*3,):SizedBox(height: SizeConfig.blockSizeVertical*8,),


                  ],
                );
              },
            )
        )
    );
  }
}
