import 'package:flutter/material.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/widgets/buttons.dart';

Size size(BuildContext context) => MediaQuery.of(context).size;

const Radius radius = Radius.circular(12.0);
final BorderRadius borderRadius = BorderRadius.circular(12.0);

String getServiceTimeText(double time) {
  final List<int> l =
      time.toStringAsFixed(2).split('.').map((e) => int.parse(e)).toList();
  if (l.length > 1 && l[1] != 0) {
    return l[0].toString() + 'hr ' + (.6 * l[1]).toInt().toString() + 'min';
  } else {
    return time.toInt().toString() + 'hr';
  }
}

Widget getServiceName(
  AllServices service, {
  TextStyle style = const TextStyle(),
  bool asTitle = false,
}) =>
    Material(
      color: Colors.transparent,
      child: Text(
        service.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: style.merge(
          TextStyle(
            fontSize: asTitle ? 18.0 : 16.0,
            fontWeight: FontWeight.w600,
            // color: bluePrimary,
          ),
        ),
      ),
    );
Widget getServiceDetails(
  AllServices service, {
  TextStyle style = const TextStyle(),
  bool asTitle = false,
}) {
  final TextStyle textStyle = style.merge(const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
  ));
  return Text.rich(
    TextSpan(children: [
      TextSpan(
        text: getServiceTimeText(service.time),
        style: textStyle,
      ),
      TextSpan(
        text: ' | ',
        style: textStyle,
      ),
      TextSpan(
        text: '\$' + service.price.toString(),
        style: textStyle,
      )
    ]),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(fontWeight: FontWeight.w300),
  );
}

Widget getSerivceImage({
  @required BuildContext context,
  @required AllServices service,
  @required double height,
  double width,
  BorderRadius borderRadius,
  bool allCornersRounded = false,
}) =>
    ClipRRect(
      borderRadius: borderRadius ??
          BorderRadius.only(
            topLeft: allCornersRounded ? radius : Radius.zero,
            topRight: allCornersRounded ? radius : Radius.zero,
            bottomLeft: allCornersRounded ? radius : Radius.zero,
            bottomRight: allCornersRounded ? radius : Radius.zero,
          ),
      child: Hero(
        tag: service.imageUrl,
        child: Material(
          color: Colors.transparent,
          child: Image.network(service.imageUrl,
              fit: BoxFit.cover,
              width: width ?? double.infinity,
              height: height),
        ),
      ),
    );

Widget serviceDetails(AllServices service, {bool asTitle = false}) => Padding(
      padding: bothHorAndVertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getServiceName(service, asTitle: asTitle),
          const SizedBox(height: 10.0),
          getServiceDetails(service, asTitle: asTitle),
        ],
      ),
    );
Widget serviceDesc(AllServices service,
        {TextStyle style = const TextStyle()}) =>
    Padding(
        padding: onlyHorizontal,
        child: Material(
            color: Colors.transparent,
            child: Text(service.description,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: style.merge(const TextStyle(fontSize: 14.0)))));
Widget serviceCard(BuildContext context, AllServices service) {
  return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        getSerivceImage(
          context: context,
          service: service,
          height: size(context).height * 0.23,
        ),
        serviceDetails(service)
      ]));
}
