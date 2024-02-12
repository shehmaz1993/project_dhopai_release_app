import 'package:dhopai/utils/Size.dart';
import 'package:dhopai/orderFile/order_track_folder/timeline_tile/timeline_tile_components.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order_track_provider.dart';

class OrderTrackUI extends StatefulWidget {
  int? orderId;
  OrderTrackUI({Key? key,id, this.orderId}) : super(key: key);

  @override
  State<OrderTrackUI> createState() => _OrderTrackUIState();
}

class _OrderTrackUIState extends State<OrderTrackUI> {


  @override
  void initState() {
    // TODO: implement initState
    final OrderTrackProvider info = Provider.of<OrderTrackProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      await Provider.of<OrderTrackProvider>(context,listen: false).updateOrderInfo(widget.orderId);

    });

    super.initState();
    print(info.items);
  }

  @override
  Widget build(BuildContext context) {
    OrderTrackProvider info = Provider.of<OrderTrackProvider>(context);
    SizeConfig().init(context);
    return info.map!=null? Scaffold(
      appBar:  PreferredSize(
        preferredSize: const Size.fromHeight(63.0),
        child:AppBar(
          title:Text('Track Order',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.indigo.shade500,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: ()=>{Navigator.pop(context)},
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical*1,),
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*5),
              child: Text(
                info.updateDate!,
                style: TextStyle(
                    fontSize:SizeConfig.blockSizeVertical*2.0,
                    color: Colors.black54
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical*1,),
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*5),
              child: RichText(
                text: TextSpan(
                  // style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: 'Order ref# ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize:SizeConfig.blockSizeVertical*2.0,
                      ),
                    ),
                    TextSpan(
                      text: info.ref,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize:SizeConfig.blockSizeVertical*2.0
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical*1,),
            Padding(
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*5),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: 'OTK- ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:SizeConfig.blockSizeVertical*2.0,
                            ),
                          ),
                          TextSpan(
                            text: info.otk,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:SizeConfig.blockSizeVertical*2.0
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width:SizeConfig.blockSizeHorizontal*34),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: 'Amount: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:SizeConfig.blockSizeVertical*2.0,
                            ),
                          ),
                          TextSpan(
                            text: '৳${info.amount}',
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize:SizeConfig.blockSizeVertical*2.0
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(height: SizeConfig.blockSizeVertical*2,),

            Padding(
              padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*10),
              child: Column(
                children: [
                  MyTimeLineTile(
                    isFirst: true,
                    isLast: false,
                    isPast:info.statusList!.contains('1')?true: false,
                    eventCard: Center(child: Text('Order Complete',style: TextStyle(color: Colors.white70),)),
                  ) ,
                  MyTimeLineTile(
                    isFirst: false,
                    isLast: false,
                    isPast: info.statusList!.contains('2')?true: false,
                    eventCard: Center(child: Text('Pickup Process',style: TextStyle(color: Colors.white70))),
                  ) ,
                  MyTimeLineTile(
                    isFirst: false,
                    isLast: false,
                    isPast: info.statusList!.contains('3')?true: false,
                    eventCard: Center(child: Text('Ready to Pickup',style: TextStyle(color: Colors.white70))),
                  ) ,
                  MyTimeLineTile(
                    isFirst: false,
                    isLast: false,
                    isPast: info.statusList!.contains('4')?true: false,
                    eventCard: Center(child: Text('Pickup Completed',style: TextStyle(color: Colors.white70))),
                  ) ,
                  MyTimeLineTile(
                    isFirst: false,
                    isLast: false,
                    isPast: info.statusList!.contains('5')?true: false,
                    eventCard: Center(child: Text('Processing',style: TextStyle(color: Colors.white70))),
                  ) ,
                  MyTimeLineTile(
                    isFirst: false,
                    isLast: false,
                    isPast:info.statusList!.contains('6')?true: false,
                    eventCard: Center(child: Text('Ready to Deliver',style: TextStyle(color: Colors.white70))),
                  ) ,
                  MyTimeLineTile(
                    isFirst: false,
                    isLast: false,
                    isPast: info.statusList!.contains('7')?true: false,
                    eventCard: Center(child: Text('On the Way',style: TextStyle(color: Colors.white70))),
                  ) ,
                  MyTimeLineTile(
                    isFirst: false,
                    isLast: true,
                    isPast: info.statusList!.contains('8')?true: false,
                    eventCard: Center(child: Text('Completed',style: TextStyle(color: Colors.white70))),
                  ) ,
                ],
              ),
            ),
            Padding(
              padding:EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*3.8,
                  top: SizeConfig.blockSizeVertical*5

              ),
              child: Text('Staffs Information:',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize:SizeConfig.blockSizeVertical*2.2
                ),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical*2,
                  horizontal:SizeConfig.blockSizeHorizontal*5
              ),
              child: Container(
                height: SizeConfig.blockSizeVertical*20,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal*3,
                          vertical: SizeConfig.blockSizeVertical*1.5
                      ),
                      child: SizedBox(
                        height: SizeConfig.blockSizeVertical*19,
                        width: SizeConfig.blockSizeHorizontal*40,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(' Recipient:', style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical*2.0,
                                color: Colors.indigo.shade900,
                                fontWeight: FontWeight.bold
                            ),),
                            SizedBox(height: SizeConfig.blockSizeVertical*3,),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: 'name:',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:SizeConfig.blockSizeVertical*1.5,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    TextSpan(
                                      text:' ${info.fName} ${info.lName}',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize:SizeConfig.blockSizeVertical*1.5
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: 'Nid:',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:SizeConfig.blockSizeVertical*1.5,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${info.nid}',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize:SizeConfig.blockSizeVertical*1.5
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: 'Phone:',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:SizeConfig.blockSizeVertical*1.5,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${info.phone}',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize:SizeConfig.blockSizeVertical*1.5
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal*2,),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal*0,
                          vertical: SizeConfig.blockSizeVertical*1.5
                      ),
                      child: SizedBox(
                        height: SizeConfig.blockSizeVertical*19,
                        width: SizeConfig.blockSizeHorizontal*40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery '
                                'man:', style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical*1.7,
                                color: Colors.indigo.shade900,
                                fontWeight: FontWeight.bold
                            ),),
                            SizedBox(height: SizeConfig.blockSizeVertical*3,),
                            Expanded(
                              child:  Container(
                                height: SizeConfig.blockSizeVertical*3,

                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: 'name:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:SizeConfig.blockSizeVertical*1.5,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      TextSpan(
                                        text:' ${info.rfName} ${info.rlName}',
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize:SizeConfig.blockSizeVertical*1.5
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: 'Nid:',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:SizeConfig.blockSizeVertical*1.5,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${info.rnid}',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize:SizeConfig.blockSizeVertical*1.5
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: 'Phone:',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:SizeConfig.blockSizeVertical*1.5,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${info.rphone}',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize:SizeConfig.blockSizeVertical*1.5
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height:SizeConfig.blockSizeHorizontal*5 ,),
            Padding(
              padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*4),
              child: Text('Your products:',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize:SizeConfig.blockSizeVertical*2.2
                ),
              ),
            ),
            SizedBox(height:SizeConfig.blockSizeHorizontal*5 ,),
            Padding(
              padding:  EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*8),
              child: Row(
                children: [
                  Text('clothes', style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:SizeConfig.blockSizeVertical*2.0
                  ),),
                  SizedBox(width: SizeConfig.blockSizeHorizontal*27,),
                  Text('qty', style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:SizeConfig.blockSizeVertical*2.0
                  ),),
                  SizedBox(width: SizeConfig.blockSizeHorizontal*8,),
                  Text('Price', style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:SizeConfig.blockSizeVertical*2.0
                  ),),
                  SizedBox(width: SizeConfig.blockSizeHorizontal*10,),
                  Text('Total', style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:SizeConfig.blockSizeVertical*2.0
                  ),)
                ],
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical*1,),
            info.items!=null? ListView.builder(
                shrinkWrap: true,
                itemCount: info.items!.length,
                itemBuilder: (context,index){
                  return showProducts(
                      info.items![index].product.name.toString(),
                      info.items![index].service!=null? info.items![index].service.name.toString():" ",
                      info.items![index].price.toString(),
                      info.items![index].qtn.toString(),
                      info.items![index].hPrice.toString()
                  );
                }):Container(),

            // SizedBox(height: SizeConfig.blockSizeVertical*3,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding:  EdgeInsets.only(
                    // left:SizeConfig.blockSizeHorizontal*59,
                      top: SizeConfig.blockSizeVertical*1,
                      right: SizeConfig.blockSizeHorizontal*2.3
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: 'Sub total:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:SizeConfig.blockSizeVertical*1.8,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text: ' ৳${double.parse(info.amount.toString())}',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize:SizeConfig.blockSizeVertical*1.8
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(
                    //left:SizeConfig.blockSizeHorizontal*47,
                      top: SizeConfig.blockSizeVertical*1,
                      right: SizeConfig.blockSizeHorizontal*2.3

                  ),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: 'Delivery charge:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:SizeConfig.blockSizeVertical*1.8,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text: ' ৳${double.parse(info.charge.toString())}',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize:SizeConfig.blockSizeVertical*1.8
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(
                    //left:SizeConfig.blockSizeHorizontal*59,
                      top: SizeConfig.blockSizeVertical*1,
                      right: SizeConfig.blockSizeHorizontal*2.3
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: 'Discount:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:SizeConfig.blockSizeVertical*1.8,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text: '     ৳${double.parse(info.discount.toString())}',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize:SizeConfig.blockSizeVertical*1.8
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal*61,
                      right: SizeConfig.blockSizeHorizontal*2.3
                  ),
                  child: Divider(
                    height: SizeConfig.blockSizeVertical*0.5,
                    // thickness:SizeConfig.blockSizeVertical*1,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(
                    // left:SizeConfig.blockSizeHorizontal*66,
                      top: SizeConfig.blockSizeVertical*1,
                      right: SizeConfig.blockSizeHorizontal*2.3
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: 'Total:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:SizeConfig.blockSizeVertical*1.8,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text: '৳${(double.parse(info.amount.toString()))+(double.parse(info.charge.toString()))-(double.parse(info.discount.toString()))}',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize:SizeConfig.blockSizeVertical*1.8
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeVertical*10,),
          ],
        ),
      ),
    ):Center(
      child:CircularProgressIndicator() ,
    );
  }
  Widget showProducts(String cloth,String service,String price,String qty,String hPrice){
    return Padding(
      padding:  EdgeInsets.only(
        left:SizeConfig.blockSizeHorizontal*3,
        right:SizeConfig.blockSizeHorizontal*3,
      ),
      child: DottedBorder(
        color: Colors.grey.shade700,
        strokeWidth: 1,
        child: Container(
          height: SizeConfig.blockSizeVertical*9.5,
          width: SizeConfig.blockSizeHorizontal*90,
          //color: Colors.greenAccent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: SizeConfig.blockSizeVertical*8.7,
                width: SizeConfig.blockSizeHorizontal*38,
                //color: Colors.greenAccent,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical*0.9,
                    left: SizeConfig.blockSizeHorizontal*0.5,
                    // bottom: SizeConfig.blockSizeVertical*0.7
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cloth,style: TextStyle(fontSize:SizeConfig.blockSizeVertical*2.0,color: Colors.black ),),
                      SizedBox(height: SizeConfig.blockSizeVertical*0.2,),
                      hPrice=="0"?  Text(
                        service,
                        style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.blueAccent ),
                      ):Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text:service,style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.blueAccent ),),
                            TextSpan(
                              text: '+',
                              style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.black54 ),
                            ),
                            TextSpan(
                              text: 'Hanger',
                              style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.black54 ),
                            ),
                            TextSpan(
                              text: '(',
                              style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.black54 ),
                            ),
                            TextSpan(
                              text: '৳',
                              style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.red ),
                            ),
                            TextSpan(
                              text: hPrice,
                              style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.black54 ),
                            ),
                            TextSpan(
                              text: ')',
                              style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.black54 ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              /* ListTile(
                title: Text('Bed Sheet Large',style: TextStyle(fontSize:SizeConfig.blockSizeVertical*2,color: Colors.black54 ),),
                subtitle:Text('Wash & Iron + Fold',style: TextStyle(fontSize:SizeConfig.blockSizeVertical*2,color: Colors.black54 ),),
              ),*/
              // SizedBox(width: SizeConfig.blockSizeHorizontal*2,),
              Container(
                  height: SizeConfig.blockSizeVertical*6,
                  width: SizeConfig.blockSizeHorizontal*15,
                  //color: Colors.green,
                  child: Center(
                    child: Text(
                      qty,
                      style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.black),),
                  )),
              //SizedBox(width: SizeConfig.blockSizeHorizontal*2,),
              Container(
                  height: SizeConfig.blockSizeVertical*6,
                  width: SizeConfig.blockSizeHorizontal*15,
                  // color: Colors.greenAccent,
                  child: Center(child: Text('৳$price',style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.black ),))),
              Container(
                  height: SizeConfig.blockSizeVertical*6,
                  width: SizeConfig.blockSizeHorizontal*22,
                  // color: Colors.green,
                  child: Center(
                      child: Text('৳${(int.parse(qty)*(double.parse(price)))+(int.parse(qty)*(double.parse(hPrice)))}',
                        style: TextStyle(fontSize:SizeConfig.blockSizeVertical*1.7,color: Colors.black ),))),
            ],
          ),
        ),
      ),
    );
  }
}
