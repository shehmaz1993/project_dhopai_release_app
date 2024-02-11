import 'package:dhopai/utils/Size.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final bool isPast;
  final child;
  const EventCard({super.key, required this.isPast, this.child});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.only(
          left:SizeConfig.blockSizeHorizontal*20,
          right:SizeConfig.blockSizeHorizontal*20
      ),
      child: Container(
        height: SizeConfig.blockSizeVertical*7,
        decoration: BoxDecoration(
            color: isPast==true? Colors.indigoAccent.shade200:Colors.grey.shade400,
            borderRadius:BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}
