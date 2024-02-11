import 'package:flutter/material.dart';

import '../utils/Size.dart';
import '../database/db-handlar.dart';
import 'cartModel.dart';
class CartList extends StatefulWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  DBHelper? dbhelper;
  late Future<List<CartModel>> cartlist;
  void initState() {
    // TODO: implement initState
    super.initState();
    dbhelper=DBHelper();
    loadData();
  }
  loadData()async{
    cartlist= dbhelper!.getCartList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: SizeConfig.blockSizeVertical*100,
        width: double.infinity,
        child: FutureBuilder(
            future: cartlist,
            builder: (context,AsyncSnapshot<List<CartModel>> snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder:(context,index){
                      return SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Text(snapshot.data![index].name.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*3.5),),
                            SizedBox(width: SizeConfig.blockSizeHorizontal*17,),
                            IconButton(onPressed: (){}, icon:Image.asset('assets/images/add.png',),color: Colors.lightBlue,),
                            SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
                            Text('0',style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3.5),),
                            SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
                            IconButton(onPressed: (){}, icon:Image.asset('assets/images/minus.png'),color: Colors.lightBlue,),
                            Text('X'+snapshot.data![index].price.toString(),style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3.5),),
                          ],
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
      )

    );
  }
}
