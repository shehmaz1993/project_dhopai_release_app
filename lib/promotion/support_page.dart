import 'package:accordion/accordion.dart';
import 'package:dhopai/promotion/promo_model_class/support_catagory_model.dart';
import 'package:dhopai/promotion/promo_model_class/support_model_class.dart';
import 'package:dhopai/utils/Size.dart';
import 'package:dhopai/utils/utils.dart';
import 'package:flutter/material.dart';

import '../Repository/repository.dart';

Repository repo = Repository();
class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
//  Repository repo = Repository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:Text('Help & Supports',style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Colors.indigo.shade500,
        leading:IconButton(
          onPressed:(){
            Navigator.pop(context);
          },
          icon:  Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
          padding:  EdgeInsets.only(
              top: SizeConfig.blockSizeVertical*1
          ),
          child: ListView(
            children: [
              Container(
                height:double.maxFinite,//SizeConfig.blockSizeVertical*58 ,
                width: double.maxFinite,
                //  color: Colors.yellow,
                child: FutureBuilder<SupportModelClass>(
                    future:repo.getSupport(),
                    builder:(context,snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          //cacheExtent: double.maxFinite,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.data!.length,
                          itemBuilder: (BuildContext context,int index){
                            return  Padding(
                                padding:EdgeInsets.only(
                                  left:index==0? SizeConfig.blockSizeHorizontal*0.3:
                                  SizeConfig.blockSizeHorizontal*0.2,
                                  bottom: SizeConfig.blockSizeVertical*1,
                                  top:index==0? SizeConfig.blockSizeVertical*2:SizeConfig.blockSizeVertical*0,

                                ),
                                child: SupportCard(
                                    color: snapshot.data!.data![index].colorCode.toString(),
                                    cataName: snapshot.data!.data![index].cateName.toString(),
                                    id: snapshot.data!.data![index].id!
                                )
                            );
                          },
                        );

                      }else{
                        return Center(
                          child: Container(),
                        );
                      }
                    }
                ),
              ),
            ],
          )
      ),

    );;
  }
}
//Color(Utils().getColorFromHex(color.toString()))
class SupportCard extends StatelessWidget {
  const SupportCard (
      {Key? key, required this.color, required this.cataName, required this.id,})
      : super(key: key);

  final String color, cataName;
  final int id;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);


    return FutureBuilder<SupportCatagoryModel>(
        future:repo.getSupportCatagory(id),
        builder:(context,snapshot){
          if(snapshot.hasData){
            return Container(

              child: Accordion(
                  paddingListBottom: 0.0,
                  paddingListTop: 0.0,
                  children: [
                    AccordionSection(
                        header: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),

                          child: Container(
                            height: SizeConfig.blockSizeVertical*8,

                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:Color(Utils().getColorFromHex(color.toString()))
                            ),
                            child: Center(
                              child: Text(
                                cataName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, letterSpacing: 0.6
                                ),
                              ),
                            ),
                          ),

                        ),
                        content:snapshot.data!.data!.isNotEmpty?
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount:snapshot.data!.data!.length ,
                            itemBuilder: (context,index){
                              return  Padding(
                                padding:  EdgeInsets.only(
                                    top:SizeConfig.blockSizeVertical*1,
                                    bottom: SizeConfig.blockSizeVertical*1
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot.data!.data![index].title.toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent.shade700),
                                    ),
                                    SizedBox(height: SizeConfig.blockSizeVertical*1,),
                                    Text(snapshot.data!.data![index].description.toString(),style: TextStyle(fontWeight: FontWeight.w400),)
                                  ],
                                ),
                              );

                            })
                            :Container()
                    )

                  ]
              ),
            );

          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}
/*Column(
children: [
Text(
snapshot.data!.data![0].title.toString(),
style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent.shade700),
),
SizedBox(height: SizeConfig.blockSizeVertical*1,),
Text(snapshot.data!.data![0].description.toString())
],
),*/
/*
Padding(
      padding: EdgeInsets.all(SizeConfig.blockSizeVertical*2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),

        child: Container(
          //color: kWhiteColor,
          height: SizeConfig.blockSizeVertical*8,
          width: SizeConfig.blockSizeHorizontal*50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
           color:Color(Utils().getColorFromHex(color.toString()))
          ),
          child: Center(
            child: Text(
              cataName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, letterSpacing: 0.6
              ),
            ),
          ),
        ),

      ),
    );
 */
/*GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.data!.length ?? 0,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        childAspectRatio: 1
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return SupportCard(
                          color: snapshot.data!.data![index].colorCode.toString(),
                          cataName: snapshot.data!.data![index].cateName.toString(),
                          id: snapshot.data!.data![index].id!
                      );

                    });*/