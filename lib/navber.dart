import 'package:dhopai/splashscreen.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {


  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder:(context,constraint) {
        if (constraint.maxWidth > 1200) {
          return DextopNavbar();
        }
        else if (constraint.maxWidth > 800 && constraint.maxWidth <= 1200) {
          return DextopNavbar();
        }
        else {
          return MobileDextop();
        }
      },
    );

  }
}
class DextopNavbar extends StatelessWidget {
  const DextopNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
class  MobileDextop extends StatelessWidget {
  const MobileDextop({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

