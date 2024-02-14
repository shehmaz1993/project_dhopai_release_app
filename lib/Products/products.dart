
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhopai/widgets/custom_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:dhopai/Products/search_product.dart';
import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/SignIn/sign_in.dart';
import 'package:dhopai/SignUp/user.dart';
import 'package:dhopai/utils/Size.dart';
import 'package:dhopai/utils/helper_class.dart';

import 'package:dhopai/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import '../database/db-handlar.dart';
import '../Side_Navigator/main_side_bar.dart';
import '../orderFile/order_rev.dart';
import 'productModel.dart';
class ProductList extends StatefulWidget {
  // const ProductList({Key? key}) : super(key: key);
  int selectedPage;
  ProductList(this.selectedPage);


  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> with AutomaticKeepAliveClientMixin<ProductList> {

  //Future<ProductModel>? response;
  TextEditingController dress =TextEditingController();
  List<TextEditingController> numberOfClothes = [TextEditingController()];
  List<bool> checkValues =[];
  Future<List<dynamic>>? catagory;
  late Future<List<UserModel>> userlist;
  late var timer;
  List cateList=[];
  int? selecctedRadioTile=0;
  String? area;
  bool dialogResult = false;

  // int changed=0;
  int numberOfSelectedproduct=0;
  int numberOfProduct=0;
  DBHelper? dbHelper;
  /*loadData()async{
    userlist= dbHelper!.getUserList();
  }*/
  Repository repo= Repository();
  Future<ProductModel> getProductfromApi(int service_id)async{
    String urls = Helper.BASE_URL+Helper.extDefault +'item/service/'+service_id.toString();
    print(urls);
    final response= await http.get(Uri.parse(urls));
    var data=jsonDecode(response.body);
    if(response.statusCode==200){
      return ProductModel.fromJson(data);
      // return data.map((job) => new ProductModel.fromJson(job)).toList();
    }
    else{
      return ProductModel.fromJson(data);
    }
  }
  loadNumberOfProduct()async{
    print('inside load number function');
    numberOfProduct= await repo.countProduct();
    print(numberOfProduct);
    setState(()  {

    });
  }
  loadingArea()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      area = prefs.getString('service_zone');
    });

    print('serviec area $area');
  }


  Future<List<dynamic>> fetchCatagories() async {
    String url=Helper.BASE_URL+Helper.extDefault+'services';
    var result = await http.get(
        Uri.parse(url));
    return jsonDecode(result.body)['data'];
  }
  void createControllers(int numberOfControllers) {
    for (int i = 0; i < numberOfControllers; i++) {

      TextEditingController controller = TextEditingController(text: '1');
      numberOfClothes.add(controller);
      if(numberOfClothes[0].text=='')
        numberOfClothes[0].text='1';

    }
  }

  void disposeControllers() {
    for (TextEditingController controller in  numberOfClothes) {
      controller.dispose();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // final ProductCountProvider infoOfProvider = Provider.of<ProductCountProvider>(context, listen: false);
    loadingArea();
    catagory = fetchCatagories();
    loadNumberOfProduct();



    super.initState();
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  static const snackBar = SnackBar(
    content: Text('You need to log in first!'),
  );
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
     super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: catagory,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              for(int i=0;i<snapshot.data.length;i++){
                cateList.add(snapshot.data[i]['name']);
              }
              return DefaultTabController(
                length: snapshot.data.length,
                initialIndex:widget.selectedPage,
                child: Scaffold(
                  bottomNavigationBar: GestureDetector(
                    onTap: (){
                      if(numberOfProduct>0){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => OrderRev()));
                        //  Navigator.pushNamed(context, orderRev);
                      }
                      else{
                        Utils().toastMessage('You did not select any product');
                      }
                    },
                    child: Container(
                      height: SizeConfig.blockSizeVertical*6,
                      width: double.infinity,
                      color: Colors.indigo.shade700,
                      child: Row(
                        children: [
                          SizedBox(width: SizeConfig.blockSizeHorizontal*37,),
                          Padding(
                            padding:  EdgeInsets.only(right:SizeConfig.blockSizeHorizontal*1.5),
                            child: badges.Badge(
                              badgeContent: Text(numberOfProduct.toString()),
                              badgeAnimation: badges.BadgeAnimation.rotation(
                                animationDuration:Duration(milliseconds: 300) ,
                                //animationType: BadgeAnimationType.fade,
                              ),
                              child: Icon(Icons.shopping_basket, color: Colors.white,size: SizeConfig.blockSizeVertical*2.5,),
                            ),
                          ),
                          Container(
                            // color: Colors.blue,
                            height: SizeConfig.blockSizeVertical*5,
                            width: SizeConfig.blockSizeHorizontal*20,
                            child: Center(
                              child:
                              Text('Confirm',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*2.3,fontWeight: FontWeight.bold),),
                            ),
                          ),

                          SizedBox(width: SizeConfig.blockSizeHorizontal*30,),
                          // Icon(Icons.arrow_forward_ios,color: Colors.white,size: SizeConfig.blockSizeVertical*3,)

                        ],
                      ),
                    ),
                  ),
                  drawer: Drawer(
                    child: MainSideBar(),
                  ),
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical*23.5),
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      toolbarHeight: SizeConfig.blockSizeVertical*14.5,
                      backgroundColor: Colors.indigo.shade500,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Builder(builder: (BuildContext context)=>IconButton(
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
                              SizedBox(width: SizeConfig.blockSizeHorizontal*49,),
                              badges.Badge(
                                  badgeContent: Text(numberOfProduct.toString()),
                                  badgeAnimation: badges.BadgeAnimation.rotation(
                                    animationDuration:Duration(milliseconds: 300) ,
                                  ),
                                  child: Icon(
                                      Icons.shopping_basket,
                                      color: Colors.white,
                                      size: SizeConfig.blockSizeVertical*4
                                  )
                              ),
                            ],
                          ),
                          Padding(
                            padding:EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal*7,
                                top: SizeConfig.blockSizeVertical*0.2
                            ),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>SearchProduct()));
                              //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchProduct()));
                              },
                              child: Container(
                                height: SizeConfig.blockSizeVertical*5.8,
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
                                          color: Colors.black45,
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

                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical*2),
                        child: ColoredBox(
                          color: Colors.white,
                          child: Container(
                            height: SizeConfig.blockSizeVertical*7,
                            child: TabBar(

                              labelColor: Colors.black,
                              indicatorColor: Colors.indigo.shade800,
                              unselectedLabelColor: Colors.black,

                              tabs: List<Widget>.generate(
                                  snapshot.data.length, (int index) {
                                return Tab(text: snapshot.data[index]['name']);
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  body:  TabBarView(

                    children: List<Widget>.generate(
                        snapshot.data.length, (index) =>
                        buildPage(
                            snapshot.data[index]['id'],snapshot.data[index]['name']
                        )
                      // buildPageForMan(snapshot.data[index]['name'])
                    ),
                  ),
                ),
              );
            }

            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),

    );
  }


  Widget buildPage(int service_id,String cata_name){

    // final  infoOfProvider = Provider.of<ProductCountProvider>(context);
    return Builder(
        builder: (context)=>FutureBuilder<ProductModel>(
            future:getProductfromApi(service_id ),
            builder:(context,snapshot){
              if(snapshot.hasData){
                //  createControllers(snapshot.data!.data!.length);
                // createCheckBoxValues(snapshot.data!.data!.length);
                return ListView.builder(
                    itemCount: snapshot.data!.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){

                      return  Padding(
                        padding:  EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal*2,
                            right: SizeConfig.blockSizeHorizontal*2,
                            bottom: index==(snapshot.data!.data!.length)-1?
                            SizeConfig.blockSizeVertical*6: SizeConfig.blockSizeVertical*0.5,
                            top: index==0?SizeConfig.blockSizeVertical*2:SizeConfig.blockSizeVertical*0
                        ),
                        child: Card(
                          child: Container(
                              height: SizeConfig.blockSizeVertical*13.8,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(3),
                                    topRight: Radius.circular(3),
                                    bottomLeft: Radius.circular(3),
                                    bottomRight: Radius.circular(3)
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: SizeConfig.blockSizeVertical*13,
                                    width: SizeConfig.blockSizeHorizontal*30 ,
                                    // color: Colors.red,
                                    child: Center(
                                      child:Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: SizeConfig.blockSizeVertical*1.2,
                                            horizontal: SizeConfig.blockSizeHorizontal*1.2
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: Helper.BASE_URL + snapshot.data!.data![index].productImage.toString(),
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.close),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: SizeConfig.blockSizeVertical*13,
                                    width: SizeConfig.blockSizeHorizontal*32 ,
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: SizeConfig.blockSizeVertical*.22,),
                                        Text(snapshot.data!.data![index].productName.toString(),
                                            style: TextStyle(
                                              //fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig.blockSizeVertical*2.4
                                            )
                                        ),
                                        Text(
                                          snapshot.data!.data![index].serviceName.toString(),
                                        ) ,
                                        SizedBox(height: SizeConfig.blockSizeVertical*.9,),
                                      ],
                                    ),



                                  ),
                                  Container(
                                    height: SizeConfig.blockSizeVertical*13,
                                    width: SizeConfig.blockSizeHorizontal*31 ,
                                    //color: Colors.brown.shade100,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('৳'+' '+snapshot.data!.data![index].price.toString(),style: TextStyle(fontStyle: FontStyle.italic),),
                                          SizedBox(height: SizeConfig.blockSizeVertical*0.5,),
                                          Container(
                                            height: SizeConfig.blockSizeVertical*5,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  int? id=prefs.getInt('customer_id');
                                                  String? token=prefs.getString('token');

                                                  if(token!=null){
                                                    var result = await  showDialog(
                                                        context: context,
                                                        builder: (context)=>CustomDialogBox(
                                                          customerId: id!,
                                                          serviceId: int.parse(snapshot.data!.data![index].serviceId.toString()),
                                                          productId: int.parse( snapshot.data!.data![index].productId.toString()),
                                                          // numberOfCloths: int.parse( numberOfClothes[index].text),
                                                          price: int.parse(snapshot.data!.data![index].price.toString()),
                                                          token: token,
                                                          productName: snapshot.data!.data![index].productName.toString(),
                                                          serviceName: snapshot.data!.data![index].serviceName.toString(),
                                                          image:snapshot.data!.data![index].productImage.toString(),
                                                          hPrice: snapshot.data!.data![index].hPrice!,
                                                        ) );
                                                    setState(() {
                                                      dialogResult = result?? false;
                                                    });
                                                    if (dialogResult==true) {
                                                      setState(() {
                                                        loadNumberOfProduct();
                                                      });
                                                    }

                                                  }
                                                  else{
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInPage()));
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>SignInPage()));
                                                  }

                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.indigo.shade400,
                                                  shape: const CircleBorder(),
                                                ),
                                                child:Center(child: Icon(Icons.add,color: Colors.white,))


                                            ),
                                          ),

                                        ],
                                      ),
                                    ),


                                  )
                                ],
                              )
                          ),
                        ),
                      );
                    });
              }
              else{
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

            }


        )
    );

  }



}

