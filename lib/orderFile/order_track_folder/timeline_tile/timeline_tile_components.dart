import 'package:dhopai/utils/Size.dart';
import 'package:dhopai/orderFile/order_track_folder/timeline_tile/event_card.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
class MyTimeLineTile extends StatelessWidget {

  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final eventCard;
  const MyTimeLineTile({super.key, required this.isFirst, required this.isLast, required this.isPast, this.eventCard});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.blockSizeVertical*12,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(color:isPast==true? Colors.indigoAccent:Colors.grey.shade200),
        indicatorStyle: IndicatorStyle(
          width: SizeConfig.blockSizeHorizontal*7.5,
          color: isPast==true?Colors.indigoAccent:Colors.grey.shade400,
          iconStyle: IconStyle(
              iconData:isPast==true? Icons.check:Icons.circle_outlined,
              color:isPast==true? Colors.white:Colors.grey.shade400
          )
        ),
        endChild: EventCard(
            isPast: isPast,
            child: eventCard,

        ),
      ),
    );
  }
}
