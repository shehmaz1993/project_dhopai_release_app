import 'package:dhopai/Side_Navigator/main_side_bar.dart';
import 'package:dhopai/orderFile/addressmodification/addressmodificationfordeliveryUPDATE.dart';
import 'package:dhopai/orderFile/addressmodification/pickup_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../Repository/log_debugger.dart';
import '../../Repository/repository.dart';
import '../../utils/Size.dart';



class AddressModificationPickUpUpdate extends StatefulWidget {

  AddressModificationPickUpUpdate({Key? key}) : super(key: key);

  @override
  State<AddressModificationPickUpUpdate> createState() => _AddressModificationPickUpUpdateState();
}

class _AddressModificationPickUpUpdateState extends State<AddressModificationPickUpUpdate> with AutomaticKeepAliveClientMixin<AddressModificationPickUpUpdate>{
  var postcodeController=TextEditingController();
  var streetController=TextEditingController();
  var cityController=TextEditingController();
  String pickUpAddress='';
  Repository repo=Repository();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    final PickUpInfo infoOfPickUp = Provider.of<PickUpInfo>(context, listen: false);

    if(infoOfPickUp.label.isEmpty){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
        print('inside function');
        await Provider.of<PickUpInfo>(context,listen: false).getAllServiceAreasAndZones();
        await Provider.of<PickUpInfo>(context,listen: false).getLabels();
        await  Provider.of<PickUpInfo>(context,listen: false).getInitialDropDownValues(context);
        cityController=TextEditingController(text: infoOfPickUp.city);
        postcodeController=TextEditingController(text: infoOfPickUp.postCode);
        streetController=TextEditingController(text: infoOfPickUp.street);

      });
    }
    // TODO: implement initState
    super.initState();

    //getAddressFromLatLng();

  }
  @override
  void deactivate() {
    super.deactivate();
  }
  @override
  void dispose() {
    cityController.dispose();
    postcodeController.dispose();
    streetController.dispose();
    super.dispose();
  }
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    LogDebugger.instance.i('pickup_update_page');
    super.build(context);
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: ()async =>true,
      child: Scaffold(
        appBar:AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo.shade500,
          title: Text('Pickup Address ',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2.9),),
          leading: Builder(builder: (BuildContext context)=>IconButton(
            onPressed:()=> Scaffold.of(context).openDrawer(),
            icon: /* Padding(
              padding: EdgeInsets.only(
                  top:SizeConfig.blockSizeVertical*1.2,bottom: SizeConfig.blockSizeVertical*2),
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
        drawer: Drawer(
          child: MainSideBar(),
        ),
        bottomNavigationBar: Consumer<PickUpInfo>(
          builder: (BuildContext context, PickUpInfo value, Widget? child) {
            return GestureDetector(
              onTap:() async {
                //final infoOfPickUp  = Provider.of<PickUpInfo>(context,listen: false);
                /*SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              pickUpAddress='';
            });
            pickUpAddress='${streetController.text.toString()},${infoOfPickUp.selectedAreaName},${infoOfPickUp.zone},${cityController.text},${postcodeController.text}';
            prefs.setString('pick_Address', pickUpAddress);
            print('shared preference pick address ${prefs.getString('pick_Address')}');*/
                Map map = await repo.updatePickUpAddress(
                    value.selectedAreaId!,
                    value.selectedZoneId!,
                    1,
                    value.street,
                    value.city,//cityController.text.toString(),
                    value.postCode//postcodeController.text.toString(),

                );
                if(map['success']==true){
                 // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>AddressModificationDeliveryUpdate()));
                  await  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>AddressModificationDeliveryUpdate())
                  );
                }else{
                  Fluttertoast.showToast(msg: 'Address did not updated!');
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
            );
          },),
        body: ListView(
          children: [
            addressModification(),
            SizedBox(height: SizeConfig.blockSizeVertical*1.4,),

          ],
        ),

      ),
    );
  }
  Widget addressModification(){
   // final infoOfPickUp  = Provider.of<PickUpInfo>(context);
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
            child: Consumer<PickUpInfo>(
              key: _formKey,
              builder: (context,value,child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(height:SizeConfig.blockSizeVertical*2.8 ,),

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
                                    padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
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
                                          child: Text(ar['name'],style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.3),),
                                        );
                                      }
                                      ).toList(),
                                      value: value.selectedAreaName==null?null:value.selectedAreaName,
                                      onChanged: ( val) async {
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
                                        print(value.selectedAreaName);
                                        print(value.selectedAreaId);
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
                                // SizedBox(height: SizeConfig.blockSizeVertical*2,),
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
                                          child: Text(ar['title'],style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.3),),
                                        );
                                      }
                                      ).toList(),
                                      value: value.zone==''?null:value.zone,
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
                              // SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
                              Text('City',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*1.9,fontWeight: FontWeight.bold) ,),
                              SizedBox(height: SizeConfig.blockSizeVertical*1,),
                              Container(
                                color: Colors.grey.shade300,
                                height: SizeConfig.blockSizeVertical*6.5,
                                width: SizeConfig.blockSizeHorizontal*90,
                                /* decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),*/
                                child: Padding(
                                  padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                                  child: TextField(
                                    controller: cityController,
                                    style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.3),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter city',
                                      // focusedBorder: InputBorder.none,

                                      contentPadding: EdgeInsets.only(
                                          bottom: SizeConfig.blockSizeHorizontal*0.11,
                                          top: SizeConfig.blockSizeVertical*0.12
                                      ),
                                    ),
                                    onChanged: value.setCity,
                                    onSubmitted: value.setCity,

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
                              //SizedBox(height: SizeConfig.blockSizeVertical*3,),
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
                                    onChanged: value.setPostCode,
                                    onSubmitted: value.setPostCode,
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
                              //SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
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
                                    onChanged: value.setStreet,
                                    onSubmitted: value.setStreet,
                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    value.isSelectedArea==true?SizedBox(height: SizeConfig.blockSizeVertical*3,):SizedBox(height: SizeConfig.blockSizeVertical*8,),


                  ],
                );
              },
            )
        )
    );
  }
}
