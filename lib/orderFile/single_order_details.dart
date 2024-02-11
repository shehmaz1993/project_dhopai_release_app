import 'package:dhopai/orderFile/order_history.dart';
import 'package:dhopai/orderFile/order_model_classes/past_order_view_model_class.dart';
import 'package:flutter/material.dart';

import '../Repository/repository.dart';
import '../utils/Size.dart';
class SingleOrderDetails extends StatefulWidget {
  final int id;
  const SingleOrderDetails({Key? key,required this.id}) : super(key: key);

  @override
  State<SingleOrderDetails> createState() => _SingleOrderDetailsState();
}

class _SingleOrderDetailsState extends State<SingleOrderDetails> {
  Repository _repo=Repository();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(_repo.viewOrderedProducts(widget.id));
    SizeConfig().init(context);
    return ListView(
      children:[
        Container(
         // height: SizeConfig.blockSizeVertical*90,
            child: buildPage())
      ]
    );
  }
  Widget buildPage(){
    return FutureBuilder<PastOrderView>(
        future:_repo.viewOrderedProducts(widget.id),
        builder: (BuildContext context,AsyncSnapshot<PastOrderView> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              print('inside building radio');
              print(snapshot.data!.amount);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* Container(
              height:SizeConfig.blockSizeVertical*10 ,
              width: double.infinity,
            )*/
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal*3,
                        top: SizeConfig.blockSizeVertical*2
                    ),
                    child: Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                            return OrderHistory();
                          }), (r){
                            return false;
                          });

                        },
                            icon: Icon(Icons.arrow_back,color: Colors.black45,size: SizeConfig.blockSizeVertical*3,)
                        ),
                        SizedBox(

                          width: SizeConfig.blockSizeHorizontal*18,
                          // height: SizeConfig.blockSizeVertical*2,
                        ),
                        Text('Order details',style: TextStyle(color: Colors.black45,fontSize:SizeConfig.blockSizeVertical*3.5 ),),
                        SizedBox(

                          width: SizeConfig.blockSizeHorizontal*18,
                          // height: SizeConfig.blockSizeVertical*2,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal*8,
                          top: SizeConfig.blockSizeVertical*4
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text.rich(
                              TextSpan(
                                  text: 'Order ID#',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3,fontWeight: FontWeight.bold,color: Colors.black54),
                                  children: [
                                    TextSpan(
                                      text: snapshot.data!.id.toString(),
                                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3,fontWeight: FontWeight.bold,color: Colors.redAccent),
                                    )
                                  ]
                              )
                          ),
                          SizedBox( height: SizeConfig.blockSizeVertical*3,),
                          Text.rich(
                              TextSpan(
                                  text: 'Name: ',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                  children: [
                                    TextSpan(
                                      text: snapshot.data!.customer?.fName.toString(),
                                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.black45),
                                    )
                                  ]
                              )
                          ),
                          Text.rich(
                              TextSpan(
                                  text: 'Customer Id: ',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                  children: [
                                    TextSpan(
                                      text: snapshot.data!.customer?.id.toString(),
                                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.black45),
                                    )
                                  ]
                              )
                          ),
                          Text.rich(
                              TextSpan(
                                  text: 'Phone number: ',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                  children: [
                                    TextSpan(
                                      text: snapshot.data!.customer!.phone.toString(),
                                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.black45),
                                    )
                                  ]
                              )
                          ),
                          Text.rich(
                              TextSpan(
                                  text: 'Date: ',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                  children: [
                                    TextSpan(
                                      text: snapshot.data!.ordDate,
                                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.black45),
                                    )
                                  ]
                              )
                          ),
                          Text.rich(
                              TextSpan(
                                  text: 'Total amount: ',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                  children: [
                                    TextSpan(
                                      text: snapshot.data!.amount.toString(),
                                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.black45),
                                    )
                                  ]
                              )
                          ),
                          /* Container(
                              height: SizeConfig.blockSizeVertical*15,
                              width: SizeConfig.blockSizeHorizontal*87,
                              color: Colors.grey.shade300,
                            ),*/
                               SizedBox(height: SizeConfig.blockSizeVertical*3,),
                               ListView.builder(
                                  itemCount: snapshot.data!.orderItems!.length,
                                  shrinkWrap: true,
                                  itemBuilder:(context,index){
                                    return  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                    Container(
                                    height: SizeConfig.blockSizeVertical*15,
                                      width: SizeConfig.blockSizeHorizontal*87,
                                      color: Colors.grey.shade300,
                                      child: Padding(
                                        padding:  EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal*4,
                                          top: SizeConfig.blockSizeVertical*4
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text.rich(
                                                TextSpan(
                                                    text: 'Product Id: ',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                                    children: [
                                                      TextSpan(
                                                        text: snapshot.data!.orderItems![index].productId.toString(),
                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.black45),
                                                      )
                                                    ]
                                                )
                                            ),
                                            Text.rich(
                                                TextSpan(
                                                    text: 'Service Id: ',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                                    children: [
                                                      TextSpan(
                                                        text: snapshot.data!.orderItems![index].serviceId.toString(),
                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.black45),
                                                      )
                                                    ]
                                                )
                                            ),
                                            Text.rich(
                                                TextSpan(
                                                    text: 'Quantity: ',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                                    children: [
                                                      TextSpan(
                                                        text: snapshot.data!.orderItems![index].qtn.toString(),
                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.black45),
                                                      )
                                                    ]
                                                )
                                            ),
                                            Text.rich(
                                                TextSpan(
                                                    text: 'Price: ',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                                    children: [
                                                      TextSpan(
                                                        text: snapshot.data!.orderItems![index].price.toString(),
                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2,fontWeight: FontWeight.bold,color: Colors.black45),
                                                      )
                                                    ]
                                                )
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                        SizedBox(height: SizeConfig.blockSizeVertical*3,)
                                      ],
                                    );
                                  }
                              ),


                        ],
                      )
                  ),

                ],
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

