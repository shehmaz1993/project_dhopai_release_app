
import 'package:dhopai/Products/product_count_provider.dart';
import 'package:dhopai/Profile/edit_profile.dart';
import 'package:dhopai/Profile/edit_profile_provider.dart';
import 'package:dhopai/Profile/personal_information.dart';
import 'package:dhopai/Routing/global_navigator_key.dart';
import 'package:dhopai/Side_Navigator/main_side_bar.dart';
import 'package:dhopai/Side_Navigator/main_side_bar_provider.dart';
import 'package:dhopai/SignIn/sign_in.dart';
import 'package:dhopai/SignIn/sign_in_info.dart';
import 'package:dhopai/SignUp/sign_up.dart';
import 'package:dhopai/SignUp/sign_up_info.dart';
import 'package:dhopai/Products/products.dart';

import 'package:dhopai/orderFile/addressmodification/addressmodificationfordeliveryUPDATE.dart';
import 'package:dhopai/orderFile/addressmodification/assressmodificationforpickupUPDATE.dart';
import 'package:dhopai/orderFile/addressmodification/delivery_info.dart';
import 'package:dhopai/orderFile/order_confirmation_ui.dart';

import 'package:dhopai/push-notification_services/firebase.dart';
import 'package:dhopai/push-notification_services/local_notification.dart';
import 'package:dhopai/splashscreen.dart';
import 'package:dhopai/widgets/successful_message_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Profile/personal_information_provider.dart';

import 'orderFile/addressmodification/pickup_info.dart';
import 'orderFile/order_track_folder/order_track_provider.dart';


void main() async{
 //HttpOverrides.global = new MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 SharedPreferences prefs = await SharedPreferences.getInstance();
  if((prefs.getString('com.dhopai.user.deviceToken'))==null){
    await FirebaseApi().initNotifications();
  }
 FirebaseApi().initializePushNotification();
 LocalNotificationService().init();
  runApp( const MyApp());
  configLoading();
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
   // ..customAnimation = CustomAnimation();
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>SignInInfo(),
          child: const SignInPage(),
        ),
        ChangeNotifierProvider(
          create: (context)=>SignUpInfo(),
          child: const SignUpPage(),
        ),


        ChangeNotifierProvider(
          create: (context)=>PickUpInfo(),
          child:  AddressModificationPickUpUpdate(),
        ),

        ChangeNotifierProvider(
          create: (context)=>DeliveryInfo(),
          child:  AddressModificationDeliveryUpdate(),

        ),
        ChangeNotifierProvider(
          create: (context)=>ProfileInfoProvider(),
          child:  EditProfile(),

        ),
        ChangeNotifierProvider(
          create: (context)=>PersonalUpdateInfo(),
          child:  PersonalInformation(),
        ),
        ChangeNotifierProvider(
          create: (context)=>ProductCountProvider(),
          child:  ProductList(0),
        ),
        ChangeNotifierProvider(
          create: (context)=>OrderTrackProvider(),
          child: OrderConfirmationUI(),
        ),
        ChangeNotifierProvider(
          create: (context)=>MainSideBarInfo(),
          child: MainSideBar(),
        ),
      ],
      child: MaterialApp(
        // title: 'Flutter Demo',
         navigatorKey: MyApp.navigatorKey,
         debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

/*class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host,
          int port) => true;
  }
}*/