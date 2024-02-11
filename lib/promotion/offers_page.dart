
import 'package:dhopai/Repository/repository.dart';
import 'package:dhopai/promotion/promo_model_class/offer_model_class.dart';
import 'package:dhopai/utils/Size.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Products/products.dart';
import '../utils/clip_path.dart';
import '../utils/utils.dart';
Repository repo = Repository();
class OfferPage extends StatefulWidget {
  const OfferPage({super.key});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  Future<List<dynamic>>? response;
  Repository repo = Repository();
  List image=[
    'assets/images/wash_iron.png',
    'assets/images/dry_clean.png',
    'assets/images/wash1.png',
    'assets/images/wash1.png',
  ];
  List slideImage=[
    'assets/images/slide_image_5.png',
    'assets/images/slide_image_6.png',
    'assets/images/slide_image_4.png',

  ];
  @override
  void initState() {
    // TODO: implement initState
    response = repo.fetchServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:Text('Offers & coupons',style: TextStyle(
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
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*6.3,
                // bottom: SizeConfig.blockSizeVertical*3,
                top: SizeConfig.blockSizeVertical*1,

              ),
              child: Text('Available Services:',
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical*2.3,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
            ),
            SizedBox(
              height:SizeConfig.blockSizeVertical*23 ,
              width: double.maxFinite,
              child: FutureBuilder(
                  future: response,
                  builder: (BuildContext context,AsyncSnapshot snapshot){
                    print(snapshot.data);
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
                                // bottom: SizeConfig.blockSizeVertical*3,
                                //top: SizeConfig.blockSizeVertical*3,

                              ),
                              child: services(
                                  snapshot.data[index]['name'],
                                  image[index],snapshot.data[index]['id'],
                                  index,
                                  context
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
            CarouselSlider.builder(
              itemCount: slideImage.length,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(slideImage[itemIndex],height: SizeConfig.blockSizeVertical*20,)),
              options: CarouselOptions(
                height: SizeConfig.blockSizeVertical*22,
                aspectRatio: 24/9,
                viewportFraction: 0.9,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.1,
                //onPageChanged: callbackFunction,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal*6.3,
                // bottom: SizeConfig.blockSizeVertical*3,
                top: SizeConfig.blockSizeVertical*3,

              ),
              child: Text('Available Coupons:',
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical*2.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
            ),
            Container(
              height:SizeConfig.blockSizeVertical*28 ,
              width: double.maxFinite,
              //  color: Colors.yellow,
              child: FutureBuilder<OfferModelClass>(
                  future: repo.getOffers(),
                  builder: ( context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          itemCount: snapshot.data!.data!.length,
                          scrollDirection: Axis.horizontal,
                          //cacheExtent: double.maxFinite,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder:(context,index){
                            return OfferCard(
                              title: snapshot.data!.data![index].description.toString(),
                              code: snapshot.data!.data![index].code.toString(),
                              discount:  snapshot.data!.data![index].discountPrice.toString(),
                              total:  double.parse(snapshot.data!.data![index].cartTotal.toString()),
                              colorCode: snapshot.data!.data![index].colorCode.toString(),
                            );

                          }
                      );
                    }
                    else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*4,
                  right: SizeConfig.blockSizeHorizontal*4
              ),
              child: Container(
                height: SizeConfig.blockSizeVertical*7,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.cyan.shade100
                ),
                child: Row(
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical*6.5,
                      width:SizeConfig.blockSizeHorizontal*60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.cyan.shade100
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left:SizeConfig.blockSizeHorizontal*5,
                            top: SizeConfig.blockSizeVertical*0.6
                        ),
                        child: Text(
                          'What do you want to wash today?',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical*2.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: SizeConfig.blockSizeVertical*6.5,
                      width:SizeConfig.blockSizeHorizontal*30,
                      child: Center(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductList(0)));
                          },
                          child: Text('View all',style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical*2.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.cyan.shade700
                          ),),
                        ),
                      ),

                    )
                  ],
                ),
              ),
            )




          ],
        )

    );
  }

}

Widget services(String serviceName, String imagePath,int id,int index,BuildContext context){
  SizeConfig().init(context);
  return Padding(
    padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2),
    child: Container(
      height: SizeConfig.blockSizeVertical*18,
      width: SizeConfig.blockSizeHorizontal*42,
      //color:  Colors.yellow.shade100,

      child: Center(
        // padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left:SizeConfig.blockSizeHorizontal*0.5,
                right: SizeConfig.blockSizeHorizontal*0.5,

              ),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductList(index)));
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    height: SizeConfig.blockSizeVertical*14,
                    width: SizeConfig.blockSizeHorizontal*40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),

                    child:Center(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.fill,
                          height: SizeConfig.blockSizeVertical*8,
                          width: SizeConfig.blockSizeHorizontal*26,
                        )),
                  ),
                ),
              ),
            ),
            Text(
              serviceName,
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical*2.0,
                  color: Colors.black,
                  letterSpacing: 1
              ),)
          ],
        ),
      ),
    ),
  );
}

class OfferCard extends StatelessWidget{
  final String title;
  final String code;
  final String discount;
  final double total;
  final String colorCode;
  OfferCard({super.key, required this.title, required this.code, required this.discount,  required this.colorCode, required this.total});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding:  EdgeInsets.all(SizeConfig.blockSizeVertical*2),
      child:  ClipPath(
        clipper: DolDurmaClipper(holeRadius: 20),
        child: Card(
          color: Color(Utils().getColorFromHex(colorCode.toString())),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),

          ),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(20),
            dashPattern: [10, 10],
            color: Colors.teal.shade500,
            strokeWidth: 2,
            child: Container(
              height: SizeConfig.blockSizeVertical*25,
              width: SizeConfig.blockSizeHorizontal*50,
              //  color:  Color(Utils().getColorFromHex(colorCode.toString())),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //  color:  Colors.grey.shade700,

              ),
              child: Center(
                // padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical*2.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),),
                    SizedBox(height: SizeConfig.blockSizeVertical*3,),
                    Row(
                      children: List.generate(150~/5, (index) => Expanded(
                        child: Container(
                          color: index%2==0?Colors.transparent
                              :Colors.teal.shade700,
                          height: 1,
                        ),
                      )),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical*2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text('Code:',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockSizeVertical*1.7,
                            color: Colors.black
                        ),),
                        TextSelectionTheme(
                          data: TextSelectionThemeData(selectionColor: Colors.yellow),
                          child: SelectableText(
                            " $code",
                            cursorColor: Colors.red,
                            showCursor: true,
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical*1.7,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue.shade600
                            ),
                            onTap: (){
                              var copy = code;
                              if(copy == code)
                                Fluttertoast.showToast(msg: 'Copied');
                            },

                          ),
                        )
                      ],
                    ),

                    Text.rich(
                        TextSpan(
                            text: 'Discount:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeVertical*1.7,
                                color: Colors.black
                            ),
                            children: <InlineSpan>[
                              TextSpan(
                                text: " ${discount.toString()}",
                                style: TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical*1.7,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54
                                ),
                              )
                            ]
                        )
                    ),
                    Text.rich(
                        TextSpan(
                            text: 'Minimum amount:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeVertical*1.7,
                                color: Colors.black
                            ),
                            children: <InlineSpan>[
                              TextSpan(
                                text: " ${total.toString()}",
                                style: TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical*1.7,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54
                                ),
                              )
                            ]
                        )
                    ),


                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }

}

/*class OfferCard extends StatelessWidget {
  final String title;
  final String code;
  final String discount;
 // final double total;
  final String colorCode;
   OfferCard({super.key, required this.title, required this.code, required this.discount,  required this.colorCode});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body:Padding(
        padding:  EdgeInsets.all(SizeConfig.blockSizeVertical*2),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
           height: SizeConfig.blockSizeVertical*15,
            width: SizeConfig.blockSizeHorizontal*50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:  Color(Utils().getColorFromHex(colorCode.toString()))
            ),
            child: Center(
             // padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical*2.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700
                  ),),
                  SizedBox(height: SizeConfig.blockSizeVertical*1.5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Code:',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockSizeVertical*1.7,
                          color: Colors.black
                      ),),
                      TextSelectionTheme(
                        data: TextSelectionThemeData(selectionColor: Colors.yellow),
                        child: SelectableText(
                            " $code",
                            cursorColor: Colors.red,
                            showCursor: true,
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical*1.7,
                              fontWeight: FontWeight.normal,
                              color: Colors.blue.shade600
                            ),
                         
                           ),
                      )
                    ],
                  ),

                  Text.rich(
                      TextSpan(
                          text: 'Discount:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockSizeVertical*1.7,
                              color: Colors.black
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: " ${discount.toString()}",
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical*1.7,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54
                              ),
                            )
                          ]
                      )
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/
/*
Padding(
        padding:  EdgeInsets.only(
              top: SizeConfig.blockSizeVertical*1
        ),
        child: FutureBuilder<OfferModelClass>(
              future:repo.getOffers(),
              builder:(context,snapshot){
                   if(snapshot.hasData){
                       return  GridView.builder(
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
                                return OfferCard(
                                   title: snapshot.data!.data![index].description.toString(),
                                   code: snapshot.data!.data![index].code.toString(),
                                   discount:  snapshot.data!.data![index].discountPrice.toString(),
                                  // total:  double.parse(snapshot.data!.data![index].cartTotal.toString()),
                                   colorCode: snapshot.data!.data![index].colorCode.toString(),
                                );

                         });
                    }else{
                       return Center(
                            child: CircularProgressIndicator(),
                         );
                 }
              }
          ),
      ),
 */
