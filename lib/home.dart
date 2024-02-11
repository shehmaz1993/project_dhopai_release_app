import 'package:dhopai/Products/products.dart';
import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/Routing/constrants.dart';
import 'package:dhopai/utils/helper_class.dart';
import 'package:dhopai/Side_Navigator/main_side_bar.dart';
import 'package:dhopai/orderFile/order_history.dart';
import 'package:dhopai/orderFile/order_model_classes/top_five_order.dart';
import 'package:dhopai/promotion/promo_model_class/promotional_model_class.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Products/search_product.dart';
import 'orderFile/order_rev.dart';
import 'utils/Size.dart';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;

import 'orderFile/order_track_folder/order_track_ui.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>with TickerProviderStateMixin {

  late AnimationController _controller2;
  late Animation<double> animation2;
  Future<List<dynamic>>? response;
  String? token;
  String? area;
  Repository _repo =Repository();
  int numberOfProduct=0;
  List image=[
    'assets/images/wash_iron.png',
    'assets/images/dry_clean.png',
    'assets/images/wash1.png',
    'assets/images/wash1.png',
  ];

  Future<List<dynamic>> fetchServices() async {
    String url=Helper.BASE_URL+Helper.extDefault+'services';
    var result = await http.get(Uri.parse(url));
    return jsonDecode(result.body)['data'];
  }
  loadingToken()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      area = prefs.getString('service_zone');
    });
    print(token);
    print('serviec area $area');
  }
  loadNumberOfProduct()async{
    print('inside load number function');
    numberOfProduct= await _repo.countProduct();
    print(numberOfProduct);
    setState(()  {

    });
  }

  @override
  void initState() {
    loadingToken();
    loadNumberOfProduct();
    response = fetchServices();
    _controller2 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    animation2 = CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeOut,
    );
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller2.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical*16.2),
            child: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: SizeConfig.blockSizeVertical*14.5,
              backgroundColor: Colors.indigo.shade500,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (BuildContext context)=>IconButton(
                          onPressed:()=> Scaffold.of(context).openDrawer(),
                          icon:  Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: SizeConfig.blockSizeVertical*4,
                          ),
                        ),),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*6,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.blockSizeVertical*2.5
                            ),
                          ),
                          Text(
                            area??'Kuril',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.blockSizeVertical*2.0
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*47,),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderRev()));
                        },
                        child: badges.Badge(
                            badgeContent: Text(numberOfProduct.toString()),
                            badgeAnimation: badges.BadgeAnimation.rotation(
                              animationDuration:Duration(milliseconds: 300) ,
                            ),
                            child: Icon(Icons.shopping_basket,color: Colors.white,size: SizeConfig.blockSizeVertical*4)
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal*7,
                        top: SizeConfig.blockSizeVertical*1
                    ),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchProduct()));
                      },
                      child: Container(
                        height: SizeConfig.blockSizeVertical*5,
                        width: SizeConfig.blockSizeHorizontal*80,

                        decoration: BoxDecoration(
                          borderRadius:   BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
                            Icon(Icons.search,size: SizeConfig.blockSizeVertical*3.2,color: Colors.black,),
                            SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
                            Text(
                              'Search services and clothes',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.blockSizeVertical*1.7
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ),
        drawer: Drawer(
          child: MainSideBar(),
        ),

        body:  ListView(
          shrinkWrap: true,
          children: [

            SizedBox(
              height:SizeConfig.blockSizeVertical*28 ,
              width: double.maxFinite,
              child: FutureBuilder(
                  future: response,
                  builder: (BuildContext context,AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      print(snapshot.data);
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        //cacheExtent: double.maxFinite,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context,int index){
                          return  Padding(
                              padding:EdgeInsets.only(
                                left:index==0? SizeConfig.blockSizeHorizontal*0.3:
                                SizeConfig.blockSizeHorizontal*0.2,
                                bottom: SizeConfig.blockSizeVertical*3,
                                top: SizeConfig.blockSizeVertical*3,

                              ),
                              child: services(
                                  snapshot.data[index]['name'],
                                  image[index],snapshot.data[index]['id'],
                                  index
                              )
                          );
                        },
                      );
                    }

                    else{
                      print(snapshot.error.toString());
                      return const Center(
                        child: CircularProgressIndicator(),

                      );

                    }
                  }
              ),
            ),

            FutureBuilder<PromotionModel>(
                future:_repo.getAds() ,
                builder:(BuildContext context,AsyncSnapshot<PromotionModel> snapshot){
                  if(snapshot.hasData){
                    return Padding(
                      padding: EdgeInsets.only(
                          left:SizeConfig.blockSizeHorizontal*2,
                          right: SizeConfig.blockSizeHorizontal*1.0
                      ),
                      child: Container(
                        height:SizeConfig.blockSizeVertical*30.0,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child:Row(
                          children: [
                            Container(
                              height: SizeConfig.blockSizeVertical*30,
                              width: SizeConfig.blockSizeHorizontal*57,
                              color: Colors.grey.shade200,


                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  //const Spacer(flex: 1,),
                                  Padding(
                                    padding:  EdgeInsets.only(
                                        left: SizeConfig.blockSizeHorizontal*2.5,
                                        top: SizeConfig.blockSizeVertical*4.5
                                    ),
                                    child: FadeTransition(
                                        opacity: animation2,
                                        child: Text(snapshot.data!.title.toString(),style:TextStyle(fontSize: SizeConfig.blockSizeVertical*3),)),
                                  ),
                                  //Spacer(flex: 1,),
                                  Padding(
                                      padding:  EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal*2.5,
                                          top: SizeConfig.blockSizeVertical*4.5
                                      ),
                                      child: Text(snapshot.data!.description.toString(),style:TextStyle(fontSize: SizeConfig.blockSizeVertical*1.8),)
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(
                                        left: SizeConfig.blockSizeHorizontal*2.5,
                                        top: SizeConfig.blockSizeVertical*4.5
                                    ),
                                    child: Container(

                                      height: SizeConfig.blockSizeVertical*3.5,
                                      width: SizeConfig.blockSizeHorizontal*50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Colors.indigo.shade700,
                                      ),
                                      child: Center(child: Text('Learn more',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2),)),
                                    ),
                                  )



                                ],
                              ),
                            ),

                            Container(
                                color:Colors.grey[100],
                                height:SizeConfig.blockSizeVertical*30, //220,
                                width:SizeConfig.blockSizeHorizontal*39, //170,

                                child: Padding(
                                    padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*4.8),
                                    child:Image.network(
                                      Helper.BASE_URL + snapshot.data!.image.toString(),
                                      height: SizeConfig.blockSizeVertical*8,
                                      width: SizeConfig.blockSizeHorizontal*15,
                                    )
                                )   //Image.asset('assets/images/clo.png',height: 100,width: 100,)),
                            )


                          ],
                        ) ,
                      ),
                    );
                  }
                  else{
                    return Center(child: CircularProgressIndicator());
                  }
                }),

            token!=null?ListTile(
              leading:Padding(
                padding: EdgeInsets.only(
                  // left: SizeConfig.blockSizeHorizontal*2,
                  // bottom: SizeConfig.blockSizeVertical*2,
                    top:SizeConfig.blockSizeVertical*1 ),
                child:  Text('Recent orders',style: TextStyle(color: Colors.black,fontSize:SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold),),
              ),
              trailing: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderHistory()));
                  },
                  child:  Text('Past orders',style: TextStyle(color: Colors.indigo.shade800,fontSize: SizeConfig.blockSizeVertical*2.0),)),
            ): Container(),
            token!=null?
            generateOrderList():Container(),
            SizedBox(height: SizeConfig.blockSizeVertical*1.5,)


          ],
        ),

      ),
    );
  }
  Widget services(String serviceName, String imagePath,int id,int index){
    return Padding(
      padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3.08),
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductList(index)));
        },
        child: Card(
          elevation: 3,
          child: Container(
            height: SizeConfig.blockSizeVertical*9,
            width: SizeConfig.blockSizeHorizontal*65,
            child: Padding(
              padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.blockSizeVertical*1.10,),
                  Text(serviceName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2.7
                  ),),
                  SizedBox(height: SizeConfig.blockSizeVertical*1.10,),
                  Text('Save 80% offer',style: TextStyle(fontWeight: FontWeight.normal,fontSize: SizeConfig.blockSizeVertical*1.9),),
                  Padding(
                    padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*37),
                    child: SizedBox(
                      height: SizeConfig.blockSizeVertical*10,
                      width: SizeConfig.blockSizeHorizontal*25,

                      child: Center(
                        child: Image.asset(imagePath,fit: BoxFit.fill,),
                      ),
                    ),
                  ),


                  // SizedBox(height: SizeConfig.blockSizeVertical*1.70,),

                ],

              ),
            ),
          ),

        ),
      ),
    );
  }

  Widget generateOrderList(){
    return  FutureBuilder<List<TopOrders>>(
        future:_repo.getLatest5Orders(),
        builder: (BuildContext context,AsyncSnapshot<List<TopOrders>> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder:(context,index){
                    return orderList(
                        snapshot.data![index].ordDate.toString(),
                        snapshot.data![index].id!,
                        snapshot.data![index].ref.toString(),
                        snapshot.data![index].amount!,
                        snapshot.data![index].status.toString()
                    );
                  }
              );
            }
            else{
              return  Center(
                child: Container(),
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
  Widget orderList(String date,int id ,String ref,int amount,String status){
    return  Padding(
      padding: EdgeInsets.fromLTRB(
          SizeConfig.blockSizeHorizontal*1.0,
          SizeConfig.blockSizeVertical*1.0,
          SizeConfig.blockSizeHorizontal*0.0,
          SizeConfig.blockSizeVertical*.05
      ),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>OrderTrackUI(orderId:id)));
        },
        child: Card(
          elevation: 2,
          child: SizedBox(
              height: SizeConfig.blockSizeVertical*8.5,
              width: SizeConfig.blockSizeHorizontal*90,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*3),
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.blockSizeVertical*1,),
                        Text(ref,style:TextStyle(
                            fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*2.0),),
                        SizedBox(height: SizeConfig.blockSizeVertical*1,),
                        Text(status,style:TextStyle(
                            fontWeight: FontWeight.normal,fontSize: SizeConfig.blockSizeVertical*1.6),)
                      ],
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal*38,),
                  Text('৳${amount}',style:TextStyle(
                      fontWeight: FontWeight.normal,fontSize: SizeConfig.blockSizeVertical*1.8),),
                  SizedBox(width: SizeConfig.blockSizeHorizontal*12,),
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>OrderTrackUI(orderId:id)));
                      },
                      child: Icon(Icons.arrow_forward,size: SizeConfig.blockSizeVertical*2)
                  )
                ],
              )
          ),

        ),
      ),
    );

  }
}
