import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhopai/Products/productModel.dart';
import 'package:dhopai/Products/search_model_class.dart';
import 'package:dhopai/utils/Size.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Repository/repository.dart';
import '../SignIn/sign_in.dart';
import '../utils/helper_class.dart';
import '../orderFile/order_rev.dart';
import '../utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

import '../widgets/custom_dialog.dart';
class SearchProduct extends StatefulWidget {
  const SearchProduct({Key? key}) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<List<dynamic>>? catagory;
  Repository repo= Repository();
  final _debouncer = Debouncer();

  List cateList=[];
  List<SearchModel> tempList=[];
  List<TextEditingController> numberOfClothes = [TextEditingController()];
  int? selecctedRadioTile=0;
  // int changed=0;
  List<bool> checkValues =[];
  int numberOfSelectedproduct=0;
  int numberOfProduct=0;
  var searchController=TextEditingController();


  Future<ProductModel> getProductfromApi(int service_id)async{
    String urls = Helper.BASE_URL+Helper.extDefault +'item/service/'+service_id.toString();
    final response= await http.get(Uri.parse(urls));
    var data=jsonDecode(response.body);
    if(response.statusCode==200){
      return ProductModel.fromJson(data);
      // return data.map((job) => new ProductModel.fromJson(job)).toList();
    }
    else{
      return ProductModel.fromJson(data);
      // print('error');
      // return data.map((job) => new ProductModel.fromJson(job)).toList();
    }
  }
  loadNumberOfProduct()async{
    numberOfProduct= await repo.countProduct();
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
  void createCheckBoxValues(int numberOfIndexes) {
    for (int i = 0; i < numberOfIndexes; i++) {
      checkValues.add(false);
    }
  }

  void disposeControllers() {
    for (TextEditingController controller in  numberOfClothes) {
      controller.dispose();
    }
  }

  @override
  void initState() {
    // TODO: implement initStat
    super.initState();
    loadNumberOfProduct();
    searchController.clear();

  }
  static const snackBar = SnackBar(
    content: Text('You need to log in first!'),
  );


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(

      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(SizeConfig.blockSizeVertical*8),
        child: AppBar(
          backgroundColor: Colors.indigo.shade500,
          leading: Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
            child: IconButton(
              icon: Icon(Icons.arrow_back), color: Colors.white,
              onPressed: () {
               Navigator.pop(context);
              },
            ),
          ),

          title: Padding(
            padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*1.1),
            child: Container(
               // height:SizeConfig.blockSizeVertical*5.5 ,
               // width: SizeConfig.blockSizeHorizontal*75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height:SizeConfig.blockSizeVertical*4.5 ,
                        width: SizeConfig.blockSizeHorizontal*60,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                          maxHeight: SizeConfig.blockSizeVertical*4.4,
                        ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: SizedBox(
                              height: SizeConfig.blockSizeVertical*4.3,
                              child: TextField(

                                   controller: searchController,
                                   style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2),
                                   cursorColor: Colors.black45,
                                   decoration: InputDecoration(
                                     prefixIcon: Icon(Icons.search),
                                    hintText: 'Search...',
                                    hintStyle: TextStyle(color: Colors.black54,fontSize: SizeConfig.blockSizeVertical*2),
                                    border: InputBorder.none,

                                  ),
                                  onChanged: (value1) {
                                    _debouncer.run(() {
                                      repo.getSearchList(value1).then((value){
                                        setState(() {
                                          tempList = value;
                                        });
                                      });
                                    });
                                  },
                                ),

                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          )
        ),
      ),
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
          height: SizeConfig.blockSizeVertical*6.5,
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
                //
                //
                // color: Colors.indigo.shade700,
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
      body:buildItems()

    );
  }
  Widget buildItems(){

    createControllers(tempList.length);
    createCheckBoxValues(tempList.length);
    return searchController.text.isNotEmpty?
      ListView.builder(
        itemCount:tempList.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return  Padding(
            padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*2,
                right: SizeConfig.blockSizeHorizontal*2,
                bottom: SizeConfig.blockSizeVertical*0.5,
                top: index==0?SizeConfig.blockSizeVertical*1
                    :SizeConfig.blockSizeVertical*0
            ),
            child: Card(
              child: Container(
                height: SizeConfig.blockSizeVertical*15.8,
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
                            imageUrl: Helper.BASE_URL + tempList[index].productImage.toString(),
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
                          Text(tempList[index].productName.toString(),
                              style: TextStyle(
                                //fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.blockSizeVertical*2.4
                              )
                          ),
                          Text(
                            tempList[index].serviceName.toString(),
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.lightBlueAccent,
                                fontSize: SizeConfig.blockSizeVertical*2.3
                            ),
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
                            Text('৳'+' '+tempList[index].price.toString(),style: TextStyle(fontStyle: FontStyle.italic),),
                            SizedBox(height: SizeConfig.blockSizeVertical*0.5,),
                            Container(
                              height: SizeConfig.blockSizeVertical*5,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    int? id=prefs.getInt('customer_id');
                                    String? token=prefs.getString('token');

                                    if(token!=null){
                                      print('number of clothes ${numberOfClothes[index].text}');
                                      print('price ${numberOfClothes[index].text}');

                                      /* await  repo.addCart(
                                                    id!,
                                                    int.parse(snapshot.data!.data![index].serviceId.toString()),
                                                    int.parse( snapshot.data!.data![index].productId.toString()),
                                                    int.parse( numberOfClothes[index].text) ?? 1,
                                                    int.parse(snapshot.data!.data![index].price.toString()),
                                                    token!,
                                                    int.parse( snapshot.data!.data![index].hPrice!.toString())
                                                );
                                                Utils().toastMessage('${snapshot.data!.data![index].productName} added to card');
                                                setState(() {
                                                  loadNumberOfProduct();
                                                });*/
                                      var result = await  showDialog(
                                          context: context,
                                          builder: (context)=>CustomDialogBox(
                                            customerId: id!,
                                            serviceId: int.parse(tempList[index].serviceId.toString()),
                                            productId: int.parse( tempList[index].productId.toString()),
                                            // numberOfCloths: int.parse( numberOfClothes[index].text),
                                            price: int.parse(tempList[index].price.toString()),
                                            token: token,
                                            productName: tempList[index].productName.toString(),
                                            serviceName: tempList[index].serviceName.toString(),
                                            image:tempList[index].productImage.toString(),
                                            hPrice: int.parse(tempList[index].hPrice.toString()),
                                          ) );
                                      print('result is $result');
                                      if(result==true){
                                        if (this.mounted) {
                                          setState(() {
                                            loadNumberOfProduct();
                                          });
                                        }
                                      }

                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInPage()));
                                    }

                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
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

        }):Container();
  }
/*  Widget buildItems(){

    print('lets go');
    return FutureBuilder<List<SearchModel>>(
        future:repo.getSearchList(),
        builder:(BuildContext context,AsyncSnapshot<List<SearchModel>> snapshot){
          if(snapshot.hasData && searchController.text.isNotEmpty){
            createControllers(tempList.length);
            return ListView.builder(
                itemCount:tempList.length,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return  Padding(
                    padding:  EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal*2,
                        right: SizeConfig.blockSizeHorizontal*2,
                        bottom: SizeConfig.blockSizeVertical*0.5,
                        top: index==0?SizeConfig.blockSizeVertical*1
                            :SizeConfig.blockSizeVertical*0
                    ),
                    child: Card(
                      child: Container(
                        height: SizeConfig.blockSizeVertical*12,
                        width: double.infinity,
                        //  color:  Colors.lightBlueAccent.withOpacity(0.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          /* gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.cyan.shade400,
                                       Colors.cyan.shade300,
                                       Colors.cyan.shade200,
                                      ]
                          ),*/
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                              bottomLeft: Radius.circular(3),
                              bottomRight: Radius.circular(3)
                          ),
                          /* boxShadow: [
                            BoxShadow(
                              color: Colors.lightBlueAccent.withOpacity(0.5),
                              spreadRadius: 0.5,
                              blurRadius: 0.5,
                              offset: Offset(3, 3), // changes position of shadow
                            ),
                          ],*/

                        ),
                        child: ListTile(

                            title: Padding(
                              padding:  EdgeInsets.only(top: SizeConfig.blockSizeVertical*1.6),
                              child: Text(tempList[index].productName.toString(),
                                  style: TextStyle(
                                    //fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ),
                            subtitle:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: SizeConfig.blockSizeVertical*.10,),
                                Text('৳'+' '+tempList[index].price.toString(),style: TextStyle(fontStyle: FontStyle.italic),) ,
                                Container(
                                    height: SizeConfig.blockSizeVertical*3.3,
                                    width: SizeConfig.blockSizeHorizontal*28,
                                    color: Colors.grey.shade100,
                                    child:Center(
                                      child: TextField(
                                        controller:numberOfClothes[index],
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                        /* onChanged:(value){
                                          //infoOfProvider.setProductCount(value, index);
                                        } ,*/
                                        //onSubmitted: infoOfProvider.setProductCount,
                                      ),
                                    )
                                  //Text('10',style: TextStyle(fontStyle: FontStyle.italic),)
                                ) ,
                              ],
                            ),
                            leading: Container(

                              height: SizeConfig.blockSizeVertical*11,
                              width: SizeConfig.blockSizeHorizontal*20,
                              /* decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.lightBlueAccent.shade100,
                              ),*/
                              child: Image.network(Helper.BASE_URL + tempList[index].productImage.toString()),
                            ),
                            trailing:Container(
                              height: SizeConfig.blockSizeVertical*11,
                              width: SizeConfig.blockSizeHorizontal*20,


                              child: Column(
                                children: [
                                  Text('৳'+' '+tempList[index].price.toString(),style: TextStyle(fontStyle: FontStyle.italic),),

                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          int? id=prefs.getInt('customer_id');
                                          String? token=prefs.getString('token');

                                          if(token!=null){
                                            await  repo.addCart(
                                                id!,
                                                int.parse(tempList[index].serviceId.toString()),
                                                int.parse( tempList[index].productId.toString()),
                                                int.parse( numberOfClothes[index].text) ?? 1,
                                                int.parse(tempList[index].price.toString()),
                                                token!
                                            );
                                            Utils().toastMessage('${tempList[index].productName.toString()} added to card');
                                            setState(() {
                                              loadNumberOfProduct();
                                            });
                                          }
                                          else{
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInPage()));
                                          }


                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.indigo,
                                          fixedSize:  Size(20, 20),
                                          shape: const CircleBorder(),
                                        ),
                                        child:Center(child: Icon(Icons.add))


                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                    ),
                  );
                });


          }
          else if(snapshot.hasData && searchController.text.isEmpty){
            return Container();
          }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

        }


    );

  }*/
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}
