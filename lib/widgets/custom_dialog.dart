import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhopai/Products/search_product.dart';
import 'package:dhopai/utils/Size.dart';
import 'package:flutter/material.dart';

import '../Repository/repository.dart';
import '../SignIn/sign_in.dart';
import '../utils/helper_class.dart';
import '../utils/utils.dart';

class CustomDialogBox extends StatefulWidget {
  final String image;
  final String productName;
  final String serviceName;
  final int customerId;
  final int hPrice;
  final int serviceId;
  final int productId;
  final int price;
  final String token;


  const CustomDialogBox(
      {  super.key,
        required this.customerId,
        required this.serviceId,
        required this.productId,

        required this.price,
        required this.token,
        required this.productName,
        required this.serviceName,
        required this.image,
        required this.hPrice});

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  Repository repo= Repository();
  int numberOfProduct=0;
  bool checkValue=false;

  TextEditingController? _controller;
  static const snackBar = SnackBar(
    content: Text('You need to log in first!'),
  );
  loadNumberOfProduct()async{
    print('inside load number function');
    numberOfProduct= await repo.countProduct();
    print(numberOfProduct);
    setState(()  {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TextEditingController(text: '1');
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print('start for new product');
    print(checkValue);
    print('serviceId is ${widget.serviceId}');
    print('ServiceName is ${widget.serviceName}');
    print('ProductId is ${widget.productId}');
    print('ProductName is ${widget.productName}');
    print('Price is ${widget.price}');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:Dialog(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8)
          ),
          child: SingleChildScrollView(

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical*1,),
                CachedNetworkImage(
                  imageUrl: Helper.BASE_URL + widget.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: SizeConfig.blockSizeVertical*13,
                  width: SizeConfig.blockSizeVertical*40,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical*2,),
                Text(
                  widget.productName,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical*2.5,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical*2,),
                Row(

                  children: [
                    Container(

                      height: SizeConfig.blockSizeVertical*5,
                      width: SizeConfig.blockSizeHorizontal*40,
                      child: Center(
                        child:Text.rich(
                            TextSpan(
                                text: 'Service:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.blockSizeVertical*2.1,
                                    color: Colors.black
                                ),
                                children: <InlineSpan>[

                                  TextSpan(
                                    text: ' ${widget.serviceName}',
                                    style: TextStyle(
                                        fontSize:SizeConfig.blockSizeVertical*2.1,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.blue,
                                        fontStyle: FontStyle.italic
                                    ),
                                  )
                                ]
                            )
                        ),
                      ),
                    ),
                    Container(
                      height: SizeConfig.blockSizeVertical*5,
                      width: SizeConfig.blockSizeHorizontal*37,
                      child: Center(
                        child: Text.rich(
                            TextSpan(
                                text: 'MRP:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.blockSizeVertical*2.0,
                                    color: Colors.black
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: " ৳",
                                    style: TextStyle(
                                        fontSize:SizeConfig.blockSizeVertical*2.0 ,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${widget.price.toString()}',
                                    style: TextStyle(fontSize:SizeConfig.blockSizeVertical*2.0,fontWeight: FontWeight.normal),
                                  )
                                ]
                            )
                        ),

                      ),
                    ),

                  ],
                ),
                /*Text.rich(
                      TextSpan(
                          text: 'Qty:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockSizeVertical*2.0,
                            color: Colors.black
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' ${widget.numberOfCloths.toString()}',
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical*2.0,
                                  fontWeight: FontWeight.normal,
                                 color: Colors.black54
                              ),
                            )
                          ]
                      )
                  ),*/
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical*1
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Qty:',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockSizeVertical*2.0,
                          color: Colors.black
                      ),),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*1,),
                      Container(
                          height: SizeConfig.blockSizeVertical*3.8,
                          width: SizeConfig.blockSizeHorizontal*28,
                          color: Colors.grey.shade100,
                          child:ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: SizeConfig.blockSizeVertical*3.7,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: SizedBox(
                                height: SizeConfig.blockSizeVertical*3.7,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical*0.2,
                                      left: SizeConfig.blockSizeHorizontal*0.5
                                  ),
                                  child: Center(
                                    child: TextField(
                                      controller:_controller,
                                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.5),
                                      // cursorHeight: 2,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          //horizontal: 10.0
                                        ),


                                      ),

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ) ,
                    ],
                  ),
                ),


                if(widget.hPrice!=0)
                  CheckboxListTile(

                      value:checkValue,

                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        'With Hanger (৳${widget.hPrice})',
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.3),
                      ),
                      onChanged: (val){

                        print('onChanged value is $val');

                        setState(() {
                          checkValue= val!;
                        });

                      }

                  ),
                SizedBox(height: SizeConfig.blockSizeVertical*1.7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal*3,
                          bottom: SizeConfig.blockSizeVertical*2
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.blockSizeVertical*2,
                                horizontal: SizeConfig.blockSizeHorizontal*7
                            ),
                            backgroundColor: Colors.blue.shade100
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('No'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal*3,
                          bottom: SizeConfig.blockSizeVertical*2
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.blockSizeVertical*2,
                                horizontal: SizeConfig.blockSizeHorizontal*7
                            ),
                            backgroundColor: Colors.blue.shade100
                        ),
                        onPressed: () async {
                          if(widget.token.isNotEmpty){
                            // print('number of clothes ${widget.numberOfCloths}');

                            print('serviceId is ${widget.serviceId}');
                            print('ServiceName is ${widget.serviceName}');
                            print('ProductId is ${widget.productId}');
                            print('ProductName is ${widget.productName}');
                            print('Number of clothes is ${_controller!.text.toString()}');
                            print('Price is ${widget.price}');

                            await  repo.addCart(
                                widget.customerId,
                                widget.productId,
                                widget.serviceId,
                                int.parse(_controller!.text.toString()),
                                widget.price,
                                widget.token,
                                checkValue==true?widget.hPrice:0
                            );


                            _controller!.clear();

                            Utils().toastMessage('${widget.productName} added to card');
                            Navigator.pop(context,true);


                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInPage()));
                          }
                        },
                        child: Text('yes'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
