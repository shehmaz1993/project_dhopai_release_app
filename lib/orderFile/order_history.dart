import 'package:dhopai/orderFile/order_model_classes/all_order_model_class.dart';
import 'package:dhopai/orderFile/order_track_folder/order_track_ui.dart';
import 'package:flutter/material.dart';

import '../Repository/repository.dart';
import '../utils/Size.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  Repository _repo =Repository();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo.shade500,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.white)),
      ),
      body: ListView(
        children: [
          generateOrderList(),
          SizedBox(height: SizeConfig.blockSizeVertical*3,)
        ],
      ),
    );
  }
  Widget generateOrderList(){
    return  FutureBuilder<List<AllOrderModelClass>>(
        future:_repo.getAllOrders(),
        builder: (BuildContext context,AsyncSnapshot<List<AllOrderModelClass>> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              print('inside building radio');
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
  Widget orderList(String date,int id,String ref,int amount,String status){
    //String ref,String status,int amount,String date
    return Padding(
      padding:  EdgeInsets.all(SizeConfig.blockSizeVertical*1),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          height: SizeConfig.blockSizeVertical*12,
          width: double.infinity,
          // color: Colors.white30,
          decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey.shade200,
              border: Border.all(color:Colors.white10,),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 2.0,
                  offset: Offset(3.0, 6.0),
                  color: Colors.white30,
                ),
                BoxShadow(
                  blurRadius: 2.0,
                  offset: Offset(-1.0, -3.0),
                  color: Colors.white30,
                )
              ]

          ),
          child: Row(
            children: [
              Padding(
                padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*2),
                child: Container(
                  height: SizeConfig.blockSizeVertical*8,
                  width: SizeConfig.blockSizeHorizontal*18,
                  //color: Colors.orangeAccent,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/images/order_image.png"),fit: BoxFit.fill),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                height: SizeConfig.blockSizeVertical*11,
                width: SizeConfig.blockSizeHorizontal*68,
                // color: Colors.orangeAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*1,left: SizeConfig.blockSizeHorizontal*2),
                      child: Row(
                        children: [
                          Text.rich(
                            TextSpan(
                                text: 'Order No# ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*1.5),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: ref,
                                    style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black54,fontSize: SizeConfig.blockSizeVertical*1.5),
                                  )
                                ]
                            ),
                          ),
                          //Text('Order No# 8787878',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*4.5,),
                          Text(date,style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black54,fontSize: SizeConfig.blockSizeVertical*1.5),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                            text: 'status: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*1.5),
                            children: <InlineSpan>[
                              TextSpan(
                                text: status,
                                style: TextStyle(fontWeight: FontWeight.normal,color: Colors.redAccent,fontSize: SizeConfig.blockSizeVertical*1.5),
                              )
                            ]
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(top:SizeConfig.blockSizeVertical*0,left: SizeConfig.blockSizeHorizontal*1.2),
                      child: Row(
                        children: [
                          Text('৳$amount',style: TextStyle(fontStyle: FontStyle.italic,color: Colors.blue,fontSize: SizeConfig.blockSizeVertical*1.5),),
                          // Text('Order No# 8787878',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*37,),
                          GestureDetector(
                            onTap: (){
                              //_repo.viewOrderedProducts(id);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>OrderTrackUI(orderId:id)));
                            },
                            child: Container(
                              height: SizeConfig.blockSizeVertical*3,
                              width: SizeConfig.blockSizeHorizontal*20,
                              // color: Colors.redAccent,
                              decoration: BoxDecoration(
                                // color:clr, //const Color(0xFF0DCAD0),
                                color: Colors.indigo,
                                borderRadius: const BorderRadius.only(
                                    topLeft:Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)
                                ),

                              ),
                              child: Center(child: Text('View',style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeVertical*1.5),)),
                            ),
                          )

                        ],
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
