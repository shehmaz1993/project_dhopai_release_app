import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/Routing/constrants.dart';
import 'package:dhopai/utils/helper_class.dart';
import 'package:dhopai/orderFile/addressmodification/assressmodificationforpickupUPDATE.dart';
import 'package:dhopai/orderFile/cartProductModel.dart';
import 'package:dhopai/orderFile/cashmemo.dart';
import 'package:dhopai/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../Products/products.dart';
import '../Profile/personal_information.dart';
import '../utils/Size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../Side_Navigator/main_side_bar.dart';
class OrderRev extends StatefulWidget {
  const OrderRev({Key? key}) : super(key: key);

  @override
  State<OrderRev> createState() => _OrderRevState();
}


class _OrderRevState extends State<OrderRev> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin<OrderRev> {
  Repository repo= Repository();
  List<int> indTotalPrice =[];

  List<dynamic> studList=[];
  late final AnimationController _controller;
  late final Animation<double> _animation;
  String? token;
  _loadData()async{

    await repo.getProducts();
  }

  int countProduct=0;
  int subTotal=0;
  int discount=0;
  int total=0;
  String discountMessage='';
  var promoController =TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadingToken();
    loadNumberOfProduct();
    getTotalPriceProducts();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

  }
  loadingToken()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    print(token);
  }
  loadNumberOfProduct()async{
    print('inside load number function');
    countProduct= await repo.countProduct();
    setState(()  {

    });
  }
  void createIndividualTotalPrice(int numberOfProductCatagory) {
    for (int i = 0; i < numberOfProductCatagory; i++) {
      indTotalPrice.add(0);
    }
  }
  Future  getTotalPriceProducts()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('customer_id'));
    print(prefs.getString('token'));
    var Url = Helper.BASE_URL + Helper.extCustomer + 'cart/${prefs.getInt('customer_id')}';
    var response = await http.get(
      Uri.parse(Url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },

    );
    try {
      if (response.statusCode == 200) {
        print('api calling is successful......');
        var cart_info = json.decode(response.body);
        print('fetched cart data $cart_info');
        studList = cart_info['data'];
        print('studlist ${studList}');
        //  totalPrice();
        for(int i=0;i<studList.length;i++){
          setState(() {
            int a=int.parse(studList[i]['price'].toString());
            int b=int.parse(studList[i]['quantity'].toString());
            int c = int.parse(studList[i]['h_price'].toString());
            print(' $i price $a');
            print('$i quantity $b');
            print('$i h_price $c');
            indTotalPrice.add(a*b+c*b);
            subTotal=subTotal+ (a*b+c*b);
            // total=subTotal;
          });
        }
        print('total $subTotal');
        // prefs.setInt('total', total);
        prefs.setInt('subTotal', subTotal);

      }
      else {
        throw Exception('Request Error: ${response.statusCode}');
      }

    }
    on Exception {
      rethrow;
    }

  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //  _loadData();
    super.build(context);
    SizeConfig().init(context);
    return token!=null? Scaffold(
      floatingActionButton: Theme(
          data:Theme.of(context).copyWith(
              backgroundColor: Theme.of(context).cardTheme.shadowColor,
              floatingActionButtonTheme: FloatingActionButtonThemeData(

                extendedSizeConstraints: BoxConstraints.tightFor(width:SizeConfig.blockSizeHorizontal*88.5,height: SizeConfig.blockSizeVertical*7),
              )
          ),
          child:FloatingActionButton.extended(
            backgroundColor:subTotal!=0?Colors.indigo.shade700:Colors.grey.shade500,
            onPressed:subTotal!=0?(){
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => CashMemo(total:total)));
              // Navigator.pushNamed(context, cashMemo,arguments: total);
             // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  PersonalInformation()));
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>PersonalInformation()));
            }:null,
            icon: Icon(Icons.arrow_right_alt_outlined,size: SizeConfig.blockSizeVertical*4.5,color: Colors.white,),
            label: Text('Sub total: ৳$subTotal',style: TextStyle(color: Colors.white),),
            extendedIconLabelSpacing: 16,
          )
      ),



      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(SizeConfig.blockSizeVertical*8.5),
        child:AppBar(
          automaticallyImplyLeading: false,
          title:Text('Basket',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.indigo.shade500,
          leading: Builder(builder: (BuildContext context)=>IconButton(
            onPressed:()=> Scaffold.of(context).openDrawer(),
            icon:  Icon(
              Icons.menu,
              color: Colors.white,
              size: SizeConfig.blockSizeVertical*4,
            ),
          ),),
        ),
      ),
      drawer: Drawer(
        child: MainSideBar(),
      ),
      body:countProduct!=0? ListView(
        children: [

          FutureBuilder(
              future:repo.getProducts(),
              builder: (context,AsyncSnapshot<CartProductModel> snapshot){
                if(snapshot.hasData){
                  //  studList=snapshot.data!.data!;
                  //totalPrice();
                  createIndividualTotalPrice(snapshot.data!.data!.length);
                  return ListView.builder(
                      itemCount: snapshot.data!.data!.length,
                      shrinkWrap: true,
                      itemBuilder:(context,index){
                        print(snapshot.data!.data![index].price);

                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),

                            children: [
                              SlidableAction(
                                  icon: Icons.delete,
                                  backgroundColor: Colors.redAccent,
                                  label: 'delete',
                                  onPressed: (context)async{
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    for(int i=0;i<int.parse(snapshot.data!.data![index].quantity!) ;i++){
                                      setState(() {
                                        subTotal=subTotal-int.parse(snapshot.data!.data![index].price!)-int.parse(snapshot.data!.data![index].hPrice!);
                                        prefs.setInt('subTotal', subTotal);
                                        // total=subTotal-discount;
                                      });
                                      //   prefs.setInt('total', total);
                                    }
                                    await repo.deleteItem(snapshot.data!.data![index].id);
                                    Utils().toastMessage('${snapshot.data!.data![index].product!.name.toString()} deleted ');

                                    setState(() {
                                      _loadData();
                                    });
                                  }
                              )
                            ],
                          ),
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            child: SizedBox(
                              height:SizeConfig.blockSizeVertical*12.3, //90,
                              width: double.infinity,
                              //color: Colors.red,
                              child: Row(
                                children: [
                                  Container(
                                    height: SizeConfig.blockSizeVertical*10.6,
                                    width:SizeConfig.blockSizeHorizontal*27, //110,
                                    //color: Colors.lightBlue,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft:Radius.circular(7),
                                          bottomLeft:Radius.circular(7)

                                      ),
                                      //color: Colors.cyan.shade700,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: Helper.BASE_URL+snapshot.data!.data![index].product!.imagePath.toString(),
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Column(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: SizeConfig.blockSizeVertical*3.8,
                                        width: SizeConfig.blockSizeHorizontal*47.2,
                                        // color: Colors.black26,
                                        child: Padding(
                                            padding:  EdgeInsets.only(
                                              left:SizeConfig.blockSizeHorizontal*2.6,
                                              top: SizeConfig.blockSizeVertical*0.7,
                                              // bottom: SizeConfig.blockSizeVertical*0.4
                                            ),
                                            child:Row(
                                              children: [
                                                Text(
                                                  snapshot.data!.data![index].product!.name.toString(),
                                                  style: TextStyle(fontSize: SizeConfig.blockSizeVertical*1.9,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                Padding(
                                                  padding:  EdgeInsets.only(
                                                      top:SizeConfig.blockSizeVertical*0.4,
                                                      left: SizeConfig.blockSizeHorizontal*0.5
                                                  ),
                                                  child: Text.rich(
                                                      TextSpan(
                                                          text: '(',style:TextStyle(
                                                        fontSize: SizeConfig.blockSizeVertical*1.8,
                                                        // fontWeight: FontWeight.bold,
                                                      ) ,
                                                          children: <InlineSpan>[
                                                            TextSpan(
                                                              text: '৳',
                                                              style: TextStyle(
                                                                fontSize: SizeConfig.blockSizeVertical*1.7,
                                                                //fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: snapshot.data!.data![index].price.toString(),
                                                              style: TextStyle(
                                                                  fontSize: SizeConfig.blockSizeVertical*1.7,
                                                                  color: Colors.red
                                                              ),

                                                            ),
                                                            TextSpan(
                                                              text: ')',
                                                              style: TextStyle(
                                                                  fontSize: SizeConfig.blockSizeVertical*1.8,
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontStyle: FontStyle.italic,
                                                                  color: Colors.black45
                                                              ),

                                                            )
                                                          ]
                                                      )),
                                                ),

                                              ],
                                            )
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.blockSizeVertical*2.9,
                                        width: SizeConfig.blockSizeHorizontal*42.2,
                                        // color: Colors.green,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left:SizeConfig.blockSizeHorizontal*2.6,
                                            top: SizeConfig.blockSizeVertical*0.7,
                                            //  bottom: SizeConfig.blockSizeVertical*0.4

                                          ),
                                          child:snapshot.data!.data![index].service!=null?
                                          RichText(
                                            text: TextSpan(
                                                text: snapshot.data!.data![index].service!.name.toString(),
                                                style: TextStyle(
                                                  fontSize: SizeConfig.blockSizeVertical*1.4,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.indigo.shade700,),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: int.parse(snapshot.data!.data![index].hPrice.toString())!=0
                                                        ?' (with Hanger ৳${snapshot.data!.data![index].hPrice} )':' ',
                                                    style: TextStyle(
                                                      fontSize: SizeConfig.blockSizeVertical*1.4,
                                                      fontWeight: FontWeight.normal,),
                                                  )
                                                ]
                                            ),
                                          ):Text(''),

                                          /*Text(
                                              snapshot.data!.data![index].service!.name.toString(),
                                              style: TextStyle(
                                                  fontSize: SizeConfig.blockSizeVertical*2.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.lightBlue.shade700,
                                                  fontStyle: FontStyle.italic),
                                            ),*/
                                        ),
                                      ),
                                      SizedBox(
                                          height: SizeConfig.blockSizeVertical*4.2,
                                          width: SizeConfig.blockSizeHorizontal*45.2,
                                          //color: Colors.yellow,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: SizeConfig.blockSizeVertical*4.5,
                                                width: SizeConfig.blockSizeHorizontal*42.2,
                                                //color: Colors.lightBlue,
                                                child: Center(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: SizeConfig.blockSizeHorizontal*1,),
                                                      IconButton(
                                                        onPressed: ()async{
                                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                                          if(int.parse(snapshot.data!.data![index].quantity!)>1){
                                                            await repo.updateQuantity(-1, snapshot.data!.data![index].id!);
                                                            setState(() {
                                                              //snapshot!.data!.data![index].quantity!;

                                                              _loadData();
                                                              subTotal=subTotal-int.parse(snapshot.data!.data![index].price!)-int.parse(snapshot.data!.data![index].hPrice!);
                                                              indTotalPrice[index] = indTotalPrice[index] -int.parse(snapshot.data!.data![index].price!)-int.parse(snapshot.data!.data![index].hPrice!);

                                                              //  total=subTotal-discount;

                                                            });
                                                            prefs.setInt('subTotal', subTotal);
                                                            //  prefs.setInt('total', total);
                                                            //EasyLoading.showSuccess('Updated!');
                                                            EasyLoading.dismiss();

                                                          }
                                                          else{
                                                            SharedPreferences prefs = await SharedPreferences.getInstance();


                                                            setState(()  {

                                                              for(int i=0;i< int.parse(snapshot.data!.data![index].quantity!);i++){
                                                                subTotal=subTotal-int.parse(snapshot.data!.data![index].price!)-int.parse(snapshot.data!.data![index].hPrice!);
                                                                // total=subTotal-discount;

                                                              }

                                                            });
                                                            prefs.setInt('subTotal', subTotal);
                                                            // prefs.setInt('total', total);
                                                            await repo.deleteItem(snapshot.data!.data![index].id);
                                                            _loadData();


                                                          }


                                                        },
                                                        icon:Icon(Icons.remove_circle,color: Colors.indigo.shade400,size: SizeConfig.blockSizeVertical*4,), //Image.asset('assets/images/minus.png',),
                                                      ),
                                                      SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
                                                      Padding(
                                                        padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*1.5),
                                                        child: Text(snapshot.data!.data![index].quantity!.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      ),
                                                      SizedBox(width: SizeConfig.blockSizeHorizontal*4.5,),
                                                      IconButton(
                                                        onPressed: ()async{
                                                          SharedPreferences prefs = await SharedPreferences.getInstance();

                                                          await repo.updateQuantity( 1, snapshot.data!.data![index].id!);
                                                          setState(() {

                                                            _loadData();
                                                            subTotal=subTotal+int.parse(snapshot.data!.data![index].price!)+int.parse(snapshot.data!.data![index].hPrice!);
                                                            indTotalPrice[index] = indTotalPrice[index]+int.parse(snapshot.data!.data![index].price!)+int.parse(snapshot.data!.data![index].hPrice!);
                                                            //total=subTotal-discount;

                                                          });
                                                          prefs.setInt('subTotal', subTotal);
                                                          // prefs.setInt('total', total);

                                                          // EasyLoading.dismiss();
                                                        },
                                                        icon:Icon(Icons.add_circle,color: Colors.indigo.shade400,size: SizeConfig.blockSizeVertical*4,), //Image.asset('assets/images/add.png'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          )
                                      ),

                                    ],
                                  ),

                                  Container(
                                      height: SizeConfig.blockSizeVertical*11.5,
                                      width: SizeConfig.blockSizeHorizontal*23,
                                      //color: Colors.grey,
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(
                                            vertical: SizeConfig.blockSizeVertical*3.8
                                        ),
                                        child: Column(

                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text.rich(
                                                TextSpan(
                                                    text: 'total:',style:TextStyle(
                                                    fontSize: SizeConfig.blockSizeVertical*2,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                    color:  Colors.black
                                                ) ,
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text: '৳',
                                                        style: TextStyle(
                                                            fontSize: SizeConfig.blockSizeVertical*2,
                                                            fontWeight: FontWeight.bold,
                                                            fontStyle: FontStyle.italic,
                                                            color: Colors.black45
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: indTotalPrice[index].toString(),
                                                        style: TextStyle(
                                                            fontSize: SizeConfig.blockSizeVertical*2,
                                                            fontWeight: FontWeight.bold,
                                                            fontStyle: FontStyle.italic,
                                                            color: Colors.redAccent
                                                        ),
                                                      )
                                                    ]
                                                )),
                                          ],
                                        ),
                                      )

                                  )
                                ],
                              ),
                            ),
                          ),
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

          ),
          SizedBox(height: SizeConfig.blockSizeVertical*3,),
          /* Card(
            elevation: 7,
            child: SizedBox(
                height: SizeConfig.blockSizeVertical*12,
                width: double.infinity,
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3,top: SizeConfig.blockSizeVertical*2.5),
                      child: Container(
                        height: SizeConfig.blockSizeVertical*6,
                        width: SizeConfig.blockSizeHorizontal*60,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26)
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4),
                          child:  TextField(
                            controller: promoController,
                            decoration: InputDecoration(
                                hintText: 'Enter promocode!...',
                                border: InputBorder.none


                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3,top: SizeConfig.blockSizeVertical*2.5),
                      child: InkWell(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          bool info=await discountOfProduct();
                          if(info==true){
                            prefs.setInt('discount', discount);
                            Utils().toastMessage('you got ৳${discount} discount!');

                          }
                          else{
                            Utils().toastMessage(discountMessage);
                            prefs.setInt('discount', 0);
                          }
                        },
                        child: Container(
                          height: SizeConfig.blockSizeVertical*6,
                          width: SizeConfig.blockSizeHorizontal*30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Colors.redAccent,
                          ),
                          child: const Center(child: FittedBox(child: Text('Use',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))),
                        ),
                      ),
                    )
                  ],
                )
            ),
          ),*/
          /* Padding(
            padding:  EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal*8,
              top: SizeConfig.blockSizeVertical*2,
            ),
            child: Row(
              children: [
                SizedBox(
                  //color: Colors.red,
                    height:SizeConfig.blockSizeVertical*6,
                    width: SizeConfig.blockSizeHorizontal*60,
                    child: Padding(
                        padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*30,top: SizeConfig.blockSizeVertical*1),
                        child: Text('Sub Total',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.lightBlue)))),
                SizedBox(width: SizeConfig.blockSizeHorizontal*10,),
                Container(
                  //color: Colors.yellow,
                  height:SizeConfig.blockSizeVertical*3.9,
                  width: SizeConfig.blockSizeHorizontal*21,
                  child: Padding(
                    padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*5),
                    child: Text('৳:$subTotal',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.black54)),
                  ),
                )

              ],
            ),
          ),
          //Text('Sub Total',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3.0,color: Colors.lightBlue),),
          //Text('${sum}/-')
          Padding(
            padding:  EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal*8,
              //top: SizeConfig.blockSizeVertical*1,
            ),
            child: Row(
              children: [
                SizedBox(
                  //color: Colors.red,
                    height:SizeConfig.blockSizeVertical*6,
                    width: SizeConfig.blockSizeHorizontal*60,
                    child: Padding(
                        padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*30,top: SizeConfig.blockSizeVertical*1),
                        child: Text('Shipping',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.lightBlue)))),
                SizedBox(width: SizeConfig.blockSizeHorizontal*10,),
                Container(
                  // color: Colors.yellow,
                  height:SizeConfig.blockSizeVertical*3.9,
                  width: SizeConfig.blockSizeHorizontal*21,
                  child: Padding(
                    padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*5),
                    child: Text('৳:0',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.black54)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal*8,
              //top: SizeConfig.blockSizeVertical*1,
            ),
            child: Row(
              children: [
                SizedBox(
                  //color: Colors.red,
                    height:SizeConfig.blockSizeVertical*6,
                    width: SizeConfig.blockSizeHorizontal*60,
                    child: Padding(
                        padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*30,top: SizeConfig.blockSizeVertical*1),
                        child: Text('Discount',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.lightBlue)))),
                SizedBox(width: SizeConfig.blockSizeHorizontal*9,),
                Container(
                  // color: Colors.yellow,
                  height:SizeConfig.blockSizeVertical*3.9,
                  width: SizeConfig.blockSizeHorizontal*21,
                  child: Padding(
                    padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*5),
                    child: Text('-৳:${discount}',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.black54)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal*8,
              //  top: SizeConfig.blockSizeVertical*.5,
            ),
            child: Row(
              children: [
                SizedBox(
                  height:SizeConfig.blockSizeVertical*6,
                  width: SizeConfig.blockSizeHorizontal*70,
                  child: Padding(
                    padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*30,top: SizeConfig.blockSizeVertical*1),
                    child: Text('Payable amount',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.lightBlue)),
                  ),
                ),
                //SizedBox(width: SizeConfig.blockSizeHorizontal*1,),
                Container(
                  // color: Colors.yellow,
                  height:SizeConfig.blockSizeVertical*3.9,
                  width: SizeConfig.blockSizeHorizontal*21,
                  child: Padding(
                    padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*5),
                    child: Text('৳:$total',style:TextStyle(fontSize: SizeConfig.blockSizeVertical*2.0,color: Colors.black54)),
                  ),
                )

              ],
            ),
          ),*/
          SizedBox(height: SizeConfig.blockSizeVertical*10,)
          /*  Padding(
             padding:  EdgeInsets.only(
                 left: SizeConfig.blockSizeHorizontal*8,
                 right: SizeConfig.blockSizeVertical*4,
                 top: SizeConfig.blockSizeVertical*3,
                 bottom: SizeConfig.blockSizeVertical*3
             ),
             child: InkWell(
               onTap: (){
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => CashMemo(total:total)));
               },
               child: Container(
                 // color: Colors.lightBlue,
                   height: SizeConfig.blockSizeVertical*8,
                   width: SizeConfig.blockSizeHorizontal*90,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(24.0),
                     color: Colors.lightBlue.shade500,
                   ),
                   child: Center(
                       child: FittedBox(
                           child: Row(
                             children: [
                               Icon(Icons.shopping_basket,color: Colors.white,),
                               SizedBox(width: SizeConfig.blockSizeHorizontal*2,),
                               FittedBox(child: Text('Check out',style: TextStyle(color: Colors.white),))
                             ],
                           )
                       )
                   )
               ),
             ),
           )*/
        ],
      ):Center(
        child: FittedBox(
            child: Text(
              'You have not added any product to card yet!',
              style: TextStyle(fontStyle: FontStyle.italic,fontSize: SizeConfig.blockSizeVertical*2.5),
            )
        ),
      ),
    ):Scaffold(
      body:paintedBoxBeforeSignIn(),
    );
  }
  Widget listItems(){
    return Card(
      elevation: 10,
      child: Container(
        height:SizeConfig.blockSizeVertical*12.6, //90,
        width: double.infinity,
        //color: Colors.red,
        child: Row(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical*12.6,
              width:SizeConfig.blockSizeHorizontal*30, //110,
              //color: Colors.lightBlue,
              child: Image.network('https://www.google.com/search?q=shirt&sxsrf=ALiCzsZIwtFBIcj5vLFKXoinOxOIQ46hgg%3A1669298902785&source=hp&ei=1np_Y7nkLPyk2roP1qCF2AU&iflsig=AJiK0e8AAAAAY3-I5qrzt_TIW6EsEbBcrGfbYbUKyYQO&ved=0ahUKEwi5p_yA_8b7AhV8klYBHVZQAVsQ4dUDCAg&uact=5&oq=shirt&gs_lcp=Cgdnd3Mtd2l6EAMyBwgjEOoCECcyBwgjEOoCECcyBwgjEOoCECcyBwgjEOoCECcyBwgjEOoCECcyBwgjEOoCECcyBwgjEOoCECcyBwgjEOoCECcyBwgjEOoCECcyBwgjEOoCECdQxgVY3Q9gmRdoAXAAeACAAQCIAQCSAQCYAQCgAQGwAQo&sclient=gws-wiz#imgrc=7NuethxUAX5uRM'),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: SizeConfig.blockSizeVertical*4.2,
                  width: SizeConfig.blockSizeHorizontal*67.2,
                  // color: Colors.black26,
                  child: Padding(
                    padding:  EdgeInsets.only(
                        left:SizeConfig.blockSizeHorizontal*2.6,
                        top: SizeConfig.blockSizeVertical*0.7,
                        bottom: SizeConfig.blockSizeVertical*0.4
                    ),
                    child: Text('Shirt',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.5,fontWeight: FontWeight.bold),),
                  ),
                ),
                Container(
                  height: SizeConfig.blockSizeVertical*4.2,
                  width: SizeConfig.blockSizeHorizontal*67.2,
                  // color: Colors.green,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left:SizeConfig.blockSizeHorizontal*2.6,
                        top: SizeConfig.blockSizeVertical*0.7,
                        bottom: SizeConfig.blockSizeVertical*0.4

                    ),
                    child: Text('Iron & fold',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.5,fontWeight: FontWeight.normal,color: Colors.lightBlue,fontStyle: FontStyle.italic),),
                  ),
                ),
                Container(
                    height: SizeConfig.blockSizeVertical*4.2,
                    width: SizeConfig.blockSizeHorizontal*67.2,
                    //color: Colors.yellow,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left:SizeConfig.blockSizeHorizontal*2.6,
                              top: SizeConfig.blockSizeVertical*0.9,
                              bottom: SizeConfig.blockSizeVertical*0.4
                          ),
                          child: Container(
                            height: SizeConfig.blockSizeVertical*4.2,
                            width: SizeConfig.blockSizeHorizontal*22.2,
                            // color: Colors.black12,
                            child: Text('MRP: 7/-'),
                          ),
                        ),
                        Container(
                          height: SizeConfig.blockSizeVertical*4.2,
                          width: SizeConfig.blockSizeHorizontal*42.2,
                          // color: Colors.lightBlue,
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox(width: SizeConfig.blockSizeHorizontal*5,),
                                Container(
                                  height: SizeConfig.blockSizeVertical*4.2 ,
                                  child: IconButton(
                                    onPressed: (){},
                                    icon: Image.asset('assets/images/add.png',),
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
                                Text('0'),
                                SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
                                IconButton(
                                  onPressed: (){},
                                  icon: Image.asset('assets/images/minus.png'),
                                  color: Colors.lightBlue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
  Widget paintedBoxBeforeSignIn(){
    return Container(
        height:SizeConfig.blockSizeVertical*30,
        width: double.infinity,
        //color: Colors.blue,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [
              0.1,
              0.4,
              0.6,
              0.9,
            ],
            colors: [
              Colors.lightBlueAccent,
              Colors.lightBlue,
              Colors.blueAccent,
              Colors.blue,
            ],
          ),
          borderRadius: BorderRadius.only(
            //  topRight: Radius.circular(40.0),
            // bottomRight: Radius.circular(40.0),
            //topLeft: Radius.circular(40.0),
              bottomLeft: Radius.circular(130.0)),
        ),
        child:Stack(
          children: [
            Padding(
              padding:EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*30,
                  top: SizeConfig.blockSizeVertical*2
              ),
              child: FadeTransition(
                  opacity: _animation,
                  child: Text('Welcome to',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: SizeConfig.blockSizeVertical*4),)),
            ),
            Padding(
              padding:  EdgeInsets.only(
                left:SizeConfig.blockSizeHorizontal*21,
                //  top:SizeConfig.blockSizeVertical*1
              ),
              child: FadeTransition(

                  opacity: _animation,
                  child: Image.asset('assets/images/dhopai_logo.png',height: SizeConfig.blockSizeVertical*20,width: SizeConfig.blockSizeHorizontal*55,)),
            ),
            Padding(
                padding:  EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal*16,
                    top:SizeConfig.blockSizeVertical*15
                ),
                child: Text('You need to log in first!',style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: SizeConfig.blockSizeVertical*3.5),)
            ),
            Padding(
                padding:  EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal*66,
                    top:SizeConfig.blockSizeVertical*22
                ),
                child:Container(
                  height: SizeConfig.blockSizeVertical*5,
                  width: SizeConfig.blockSizeHorizontal*30,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: Center(child: Text('Sign in',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3,fontStyle: FontStyle.italic,color: Colors.lightBlueAccent),)),
                )
            ),


          ],
        )
    );
  }
}
