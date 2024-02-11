import 'package:dhopai/home.dart';
import 'package:dhopai/orderFile/order_track_folder/order_track_ui.dart';
import 'package:flutter/material.dart';

import '../utils/Size.dart';
class OrderConfirmationUI extends StatelessWidget {
  const OrderConfirmationUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Padding(
              padding:  EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*12,
                right: SizeConfig.blockSizeHorizontal*16,
                top: SizeConfig.blockSizeVertical*10,
                bottom: SizeConfig.blockSizeVertical*3
              ),
              child: Image.asset('assets/images/delivery_man.jpg',height: SizeConfig.blockSizeVertical*32,width: SizeConfig.blockSizeHorizontal*70,),
            ),
            Text("Congratulation!",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo.shade500,fontSize: SizeConfig.blockSizeVertical*4),),
            SizedBox(height: SizeConfig.blockSizeVertical*1,),
            Text(
              "Your order has been confirmed",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black38,
                  fontSize: SizeConfig.blockSizeVertical*3,
                  fontStyle: FontStyle.italic
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical*15,
            ),
            Container(
                width: SizeConfig.blockSizeHorizontal*60, //266.0,
                height: SizeConfig.blockSizeVertical*6.2,  //48.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: Colors.indigo.shade500,
                ),
                child:  MaterialButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>OrderTrackUI()));
                    },
                  child: FittedBox(
                      child: Padding(
                        padding: EdgeInsets.all(SizeConfig.blockSizeVertical*0.5),
                        child: Text(
                          'Track your Order!', style: TextStyle(color: Colors.white),),
                      )),
                ),
              ),
            SizedBox(height: SizeConfig.blockSizeVertical*1,),
            Container(
              width: SizeConfig.blockSizeHorizontal*60, //266.0,
              height: SizeConfig.blockSizeVertical*6.2,  //48.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Colors.redAccent.shade200,
              ),
              child:  MaterialButton(
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                    return Home();
                  }), (r){
                    return false;
                  });
                },
                child: FittedBox(
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical*0.5),
                      child: Text(
                        'Back to Home', style: TextStyle(color: Colors.white),),
                    )),
              ),
            ),

            
          ],
        ),
      ),
    );
  }
}
