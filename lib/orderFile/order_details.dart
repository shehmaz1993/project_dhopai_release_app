import 'dart:convert';

import 'package:dhopai/Routing/constrants.dart';
import 'package:dhopai/orderFile/cashmemo.dart';
import 'package:dhopai/orderFile/order_confirmation_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Repository/repository.dart';
import '../utils/Size.dart';
import '../utils/helper_class.dart';

import '../Side_Navigator/main_side_bar.dart';
import '../utils/utils.dart';
class PaymentOrder extends StatefulWidget {
  final String deliveryType;

  final String time;
  final  int deliveryCharge;
  const PaymentOrder(
      {
        Key? key,
        required this.deliveryType,
        required this.time,
        required this.deliveryCharge
      }) : super(key: key);

  @override
  State<PaymentOrder> createState() => _PaymentOrderState();
}

class _PaymentOrderState extends State<PaymentOrder> {
  int numberOfProduct=0;
  int total=0,subTotal=0,discount=0,final_total=0;
  String pickUpAddress='';
  String deliveryAddress='';
  String discountMessage='';
  var promoController =TextEditingController();
  Repository repo=Repository();
  Map<String,dynamic>? map1,map2;
  bool checkDiscountAdded=false;

  checkDiscountRemovedOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkDiscountAdded=prefs.getBool('discount_added')!;
    });
    print('discount check $checkDiscountAdded');
  }
  loadAmounts()async{
    print('inside load number function');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      total=prefs.getInt('total_with_charge')!;
      subTotal=prefs.getInt('subTotal')!;
    });
    //discount=prefs.getInt('discount')!;
    numberOfProduct= await repo.countProduct();
    print(numberOfProduct);
    setState(()  {

    });
  }
  Future<bool> discountOfProduct() async {
    print('inside discount function');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var Url = Helper.BASE_URL + Helper.extDefault + 'discount_check/${promoController.text.toString()}/${subTotal}';
    var response = await http.get(
      Uri.parse(Url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var discountInfo = json.decode(response.body);
        print('fetched discount data $discountInfo');
        setState(() {
          discountInfo['success']==true?  discount=int.parse( discountInfo['data']):0;
          discountMessage=discountInfo['data'];
          // discount==0?total=subTotal:total=subTotal-discount;
          if(discount!=0){
            total=total-discount;
          }
          prefs.setInt('total_with_discount',final_total);
          // prefs.setInt('subTotal', subTotal);
          prefs.setInt('discount', discount);


        });
        return discountInfo['success'];
      }
      else {
        // Utils().toastMessage('Your discount expires');
        throw Exception('Request Error: ${response.statusCode}');

      }

    }
    on Exception {
      rethrow;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAmounts();
    checkDiscountRemovedOrNot();
    setState(() {
      pickUpAddress='';
      deliveryAddress='';
    });
    repo.pickUpAddressShowInBox().then((value) {
      setState(() {
        map1=value;
        pickUpAddress='${map1!['address_line_1']},${map1!['area']['name']},${map1!['zone']['title']},${map1!['city']},${map1!['zip']}';
        // pickUpAddress=value;
        print(pickUpAddress);
      });
      print('pick up address $pickUpAddress');
    });
    repo.deliveryAddressShowInBox().then((value) {
      setState(() {
        map2=value;
        deliveryAddress='${map2!['address_line_1']},${map2!['area']['name']},${map2!['zone']['title']},${map2!['city']},${map2!['zip']}';
        //  deliveryAddress=value;
        print(deliveryAddress);

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.indigo.shade500,
          title: Text('Check out',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2.9),),
          leading: Builder(builder: (BuildContext context)=>IconButton(
            onPressed:()=> Scaffold.of(context).openDrawer(),
            icon:  /*Padding(
            padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*1.2,bottom: SizeConfig.blockSizeVertical*2),
            child:*/ Icon(
              Icons.menu,
              color: Colors.white,
              size: SizeConfig.blockSizeVertical*4,
            ),
            // ),
          ),
          ),
        ), /*PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child:AppBar(
          automaticallyImplyLeading: false,

          title:Padding(
            padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*5.7,bottom: SizeConfig.blockSizeVertical*2),
            child: Text('Check out',style: TextStyle(color: Colors.white),),
          ),
          /*Padding(
              padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*3.5,bottom: SizeConfig.blockSizeVertical*2),
              child: const FittedBox(child: Text('Pickup Address ',style: TextStyle(color: Colors.black45),)),
            ),*/
          backgroundColor: Colors.indigo.shade500,

          leading:Builder(builder: (BuildContext context)=>IconButton(
            onPressed:()=> Scaffold.of(context).openDrawer(),
            icon:  Padding(
              padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*2.5,bottom: SizeConfig.blockSizeVertical*2),
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
        /*bottomSheet: GestureDetector(
        onTap: ()async {
          print('inside the near of order');
          bool?  info=await  repo.makeOrder(pickUpAddress,deliveryAddress) ;
          print(info);
          if(info! ==true){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>OrderConfirmationUI()));
          }
          // Navigator.pushNamed(context, homePage);

        },
        child: Container(
          height: SizeConfig.blockSizeVertical*7,
          width: double.infinity,
          color: Colors.indigo.shade500,
          child:Row(
            children: [
              SizedBox(width: SizeConfig.blockSizeHorizontal*30,),
              Icon(Icons.shopping_basket,size: SizeConfig.blockSizeVertical*3,color: Colors.white,),
              SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
              Text('Place order',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2.2,fontWeight: FontWeight.bold),),
            ],
          )
        ),
      ),*/
        /* appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: Padding(
            padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*3.5,bottom: SizeConfig.blockSizeVertical*2),
            child: const FittedBox(child: Text('Payment',style: TextStyle(color: Colors.black45),)),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: Padding(
            padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*1.5,bottom: SizeConfig.blockSizeVertical*4),
            child: IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>CashMemo()));
              },
              icon:const Icon(Icons.arrow_back,color: Colors.lightBlue,) ,

            ),
          ),
        ),
      ),*/


        drawer: Drawer(
          child: MainSideBar(),
        ),
        bottomNavigationBar:GestureDetector(
          onTap: ()async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            print('inside the near of order');
            bool?  info=await  repo.makeOrder(pickUpAddress,deliveryAddress) ;
            print(info);
            if(info! ==true){
              prefs.setBool('discount_added',false);
              setState(() {
                checkDiscountAdded=false;
              });
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>OrderConfirmationUI()));
            }
            // Navigator.pushNamed(context, homePage);

          },
          child: Container(
              height: SizeConfig.blockSizeVertical*7,
              width: double.infinity,
              color: Colors.indigo.shade500,
              child:Row(
                children: [
                  SizedBox(width: SizeConfig.blockSizeHorizontal*32,),
                  Icon(Icons.shopping_basket,size: SizeConfig.blockSizeVertical*3,color: Colors.white,),
                  SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
                  Text('Place order',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2.2,fontWeight: FontWeight.bold),),
                ],
              )
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*1,
                  right: SizeConfig.blockSizeHorizontal*1,
                  top: SizeConfig.blockSizeVertical*0.7

              ),
              child: Card(
                color: Colors.grey.shade200,
                child: SizedBox(
                  height: SizeConfig.blockSizeVertical*11,
                  width: SizeConfig.blockSizeHorizontal*95,
                  child: ListTile(
                      leading: Image.asset('assets/images/pickup.png',height: SizeConfig.blockSizeVertical*4.5,),
                      title:Text('Pick Up address',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2.5),),
                      subtitle:Text(pickUpAddress,style: TextStyle(fontSize:SizeConfig.blockSizeVertical*2 ),)
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*1,
                  right: SizeConfig.blockSizeHorizontal*1
              ),
              child: Card(
                color: Colors.grey.shade200,
                child: SizedBox(
                  height: SizeConfig.blockSizeVertical*11,
                  width:  SizeConfig.blockSizeHorizontal*95,
                  child: ListTile(
                    leading: Image.asset('assets/images/delivery_ad.png',height: SizeConfig.blockSizeVertical*4.5,),
                    title: Text('Delivery address',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2.5),),
                    subtitle:  Text(deliveryAddress,style: TextStyle(fontSize:SizeConfig.blockSizeVertical*2 ),),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*5,
                  top:  SizeConfig.blockSizeVertical*2
              ),
              child: Text('Delivery Type ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2.0),),
            ),
            /*ListTile(
              leading: Icon(Icons.circle,color: Colors.blue.shade900,),
              title: Text(widget.deliveryType,style: TextStyle(),),
              subtitle: Text(widget.time),
            )*/
            RadioListTile(

                activeColor: Colors.blue.shade900,
                value: 0,
                groupValue: 0,
                title:Text(widget.deliveryType,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,fontWeight: FontWeight.w600),),

                subtitle:Text(widget.time,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.black54),),
                onChanged: (val){}
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*5,
                  top:  SizeConfig.blockSizeVertical*0
              ),
              child: Text('Payments ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2.0),),
            ),
            RadioListTile(
                activeColor: Colors.blue.shade900,
                value: 0,
                groupValue: 0,
                title:Text('Cash On Delivery',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,fontWeight: FontWeight.w600),),

                subtitle:Text('Pay bills when you get your services',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.black54),),
                onChanged: (val){}

            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical*3,
              width: double.infinity,
              //color: Colors.purple,
              child: ListTile(
                leading:Text('Subtotal(৳)',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2),),
                trailing:Text(subTotal.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: SizeConfig.blockSizeVertical*2),) ,

              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical*3,
              width: double.infinity,
              child: ListTile(
                leading:Text('Shipping(৳)',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2),),
                trailing:Text(widget.deliveryCharge.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: SizeConfig.blockSizeVertical*2),) ,
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical*3,
              width: double.infinity,
              child: ListTile(
                leading: Container(
                  // color: Colors.redAccent,
                  height: SizeConfig.blockSizeVertical*7,
                  width: SizeConfig.blockSizeHorizontal*45,
                  child: Row(
                    children: [
                      Text('Discount(৳)',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2),),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*0.9,),
                      Visibility(
                        visible: checkDiscountAdded==true,
                        child: GestureDetector(
                            onTap: () async {
                              print('removed');
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              setState(() {
                                total=total+discount;
                                checkDiscountAdded=false;
                                discount=0;
                              });
                              prefs.setBool('discount_added', false);

                            },
                            child: RichText(
                                text:TextSpan(
                                    children: [
                                      /* Text('Remove',style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.blockSizeVertical*2,
                                        color: Colors.redAccent
                                    ),
                                    )*/
                                      TextSpan(
                                        text: '[ ',
                                        style:  TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig.blockSizeVertical*2,
                                            color: Colors.blueAccent
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Remove',
                                        style:  TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig.blockSizeVertical*2,
                                            color: Colors.redAccent
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ]',
                                        style:  TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig.blockSizeVertical*2,
                                            color: Colors.blueAccent
                                        ),
                                      ),

                                    ]
                                ))
                        ),
                      ),
                    ],
                  ),
                ),
                trailing:Text('${discount.toString()}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: SizeConfig.blockSizeVertical*2),) ,
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical*1.9,),
            Divider(
              color: Colors.grey.shade900,

            ),
            /*Container(
              height: SizeConfig.blockSizeVertical*3,
              width: double.infinity,
              color: Colors.amber,
              child: ListTile(
                leading:Text('Total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2),),
                trailing:Text(total.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: SizeConfig.blockSizeVertical*2),) ,
              ),
            ),*/

            Padding(
              padding:  EdgeInsets.only(
                  left:SizeConfig.blockSizeHorizontal*4,
                  right:SizeConfig.blockSizeHorizontal*6
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total(৳)',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2),),
                  // Spacer(),
                  //  SizedBox(width: SizeConfig.blockSizeHorizontal*71.5,),
                  Text(total.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: SizeConfig.blockSizeVertical*2),) ,
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top:SizeConfig.blockSizeVertical*4.3,
                    left:SizeConfig.blockSizeHorizontal*5.5,
                    right:SizeConfig.blockSizeHorizontal*5,
                    bottom: SizeConfig.blockSizeVertical*2
                ),
                child: Container(
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: double.infinity,
                  decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white30,
                      border: Border.all(color: Colors.black45)
                  ) ,
                  child: Row(
                    children: [
                      Padding(
                        padding:EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3,bottom: SizeConfig.blockSizeVertical*0.5),
                        child: SizedBox(
                          height: SizeConfig.blockSizeVertical*4.5,
                          width: SizeConfig.blockSizeHorizontal*55,
                          //color: Colors.cyan,
                          child: Center(

                            child: TextField(
                              style: TextStyle(fontSize: SizeConfig.blockSizeVertical*1.7),
                              controller: promoController,
                              decoration: InputDecoration(
                                hintText: 'Enter promocode if you have!...',
                                border: InputBorder.none,

                              ),
                            ),
                          ),
                        ),
                      ),
                      //  ),
                      Padding(
                        padding: EdgeInsets.only(
                            left:SizeConfig.blockSizeHorizontal*13,
                            top: SizeConfig.blockSizeVertical*0
                        ),
                        child: InkWell(
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              bool info=await discountOfProduct();
                              if(info==true){
                                //  prefs.setInt('discount', discount);
                                Utils().toastMessage('you got ৳${discount} discount!');
                                prefs.setBool('discount_added', true);
                                setState(() {
                                  checkDiscountAdded=true;
                                });
                              }
                              else{
                                Utils().toastMessage(discountMessage);
                                //  prefs.setInt('discount', 0);
                              }

                            },
                            child: Text('APPLY',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),)
                        ),
                      )
                    ],
                  ),
                )

            ),
            SizedBox(height: SizeConfig.blockSizeVertical*0.9,),
            /* GestureDetector(
              onTap: ()async {
                print('inside the near of order');
                bool?  info=await  repo.makeOrder(pickUpAddress,deliveryAddress) ;
                print(info);
                if(info! ==true){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>OrderConfirmationUI()));
                }
                // Navigator.pushNamed(context, homePage);

              },
              child: Container(
                  height: SizeConfig.blockSizeVertical*7,
                  width: double.infinity,
                  color: Colors.indigo.shade500,
                  child:Row(
                    children: [
                      SizedBox(width: SizeConfig.blockSizeHorizontal*30,),
                      Icon(Icons.shopping_basket,size: SizeConfig.blockSizeVertical*3,color: Colors.white,),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
                      Text('Place order',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2.2,fontWeight: FontWeight.bold),),
                    ],
                  )
              ),
            ),*/

          ],
        )


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
                  child: Text("৳${qty*money}",style: TextStyle(fontSize:  SizeConfig.blockSizeVertical*2.3,color: Colors.black),)
              ),

            ],
          ),
        ),
        Container(
          //color: Colors.white,
          height: SizeConfig.blockSizeVertical*0.2,
          width: SizeConfig.blockSizeHorizontal*89,
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
  Widget orderedProducts(String pName,String service,int qty, int money){
    //String pName,String service,int qty, int money
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.blockSizeVertical*5.5,
      width: double.infinity,
      //color: Colors.lightBlueAccent,
      child: Row(
        children: [
          SizedBox(width: SizeConfig.blockSizeHorizontal*6,),
          Container(
            height: SizeConfig.blockSizeVertical*5.5,
            width: SizeConfig.blockSizeHorizontal*70,
            //color: Colors.lightBlue,
            child: Row(
              children: [
                Text('$qty',style: TextStyle(fontSize:  SizeConfig.blockSizeVertical*2.3,color: Colors.black45),),
                SizedBox(width: SizeConfig.blockSizeHorizontal*2,),
                Text('X',style: TextStyle(fontSize:  SizeConfig.blockSizeVertical*2.3,color: Colors.black45),),
                SizedBox(width: SizeConfig.blockSizeHorizontal*2,),
                Text('$pName',style: TextStyle(fontSize:  SizeConfig.blockSizeVertical*2.3,color: Colors.black45),),
                SizedBox(width: SizeConfig.blockSizeHorizontal*2,),
                Text('($service)',style: TextStyle(fontSize:  SizeConfig.blockSizeVertical*2.3,color: Colors.lightBlue),),

              ],
            ),
          ),

          //  SizedBox(width: SizeConfig.blockSizeHorizontal*10,),
          Text('৳${qty*money}',style: TextStyle(fontSize:  SizeConfig.blockSizeVertical*2.3,color: Colors.black45),)
        ],
      ),

    );
  }
  Widget showingInfoString(String title,String amount){
    return Padding(
      padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3,top: SizeConfig.blockSizeVertical*1.5),
      child: Row(
        children: [
          Container(
              height:SizeConfig.blockSizeVertical*3,
              width: SizeConfig.blockSizeHorizontal*50,
              //color: Colors.limeAccent,
              child: Text(title,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,fontWeight: FontWeight.bold,color: Colors.black45),)
          ),
          Container(
            // color: Colors.red,
              height:SizeConfig.blockSizeVertical*3,
              width: SizeConfig.blockSizeHorizontal*24,
              child: FittedBox(child: Text('${amount.toString()}',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2,color: Colors.black45),))
          )
        ],
      ),
    );
  }
  Widget showingInfoInt(String title,int amount){
    return Padding(
      padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3,top: SizeConfig.blockSizeVertical*1.5),
      child: Row(
        children: [
          Container(
              height:SizeConfig.blockSizeVertical*3,
              width: SizeConfig.blockSizeHorizontal*65,
              //color: Colors.limeAccent,
              child: Text(title,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,fontWeight: FontWeight.bold,color: Colors.black45),)
          ),
          Container(
              height:SizeConfig.blockSizeVertical*3,
              width: SizeConfig.blockSizeHorizontal*10,
              child:title=='discount'? Text('-৳${amount.toString()}',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.black45),)
                  :Text('৳${amount.toString()}',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.black45),)
          )
        ],
      ),
    );
  }

}