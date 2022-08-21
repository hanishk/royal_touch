import 'dart:io';
import 'package:flutter/material.dart';
import 'package:royaltouch/config/colors.dart';

enum Cut { TR, TL, BR, BL }
enum P { Right, Left }

class Button extends StatefulWidget {
  const Button({
    @required this.text,
    @required this.color,
    @required this.onPressed,
    this.fontSize = 18,
    this.cut = Cut.BL,
    this.position = P.Right,
    this.iconPosition = P.Right,
    this.showIcon = false,
    this.style = const TextStyle(),
    this.textColor,
    this.iconData,
  });
  final String text;
  final Color color;
  final Color textColor;
  final void Function() onPressed;
  final P position;
  final P iconPosition;
  final bool showIcon;
  final double fontSize;
  final TextStyle style;
  final Cut cut;
  final IconData iconData;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool click = false;

  @override
  Widget build(BuildContext context) {
    final Alignment alignment = widget.position == P.Left
        ? Alignment.centerLeft
        : Alignment.centerRight;
    final Cut c =
        widget.cut ?? (alignment == Alignment.centerLeft ? Cut.TR : Cut.BL);

    final Color childColor = widget.color == bluePrimary ? white : bluePrimary;

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () => widget.onPressed(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: ClipPath(
            clipper: MyCustomClipper(c),
            clipBehavior: Clip.antiAlias,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16).copyWith(
                left: alignment == Alignment.centerRight ? 70 : 15,
                right: alignment == Alignment.centerLeft ? 70 : 15,
              ),
              decoration: BoxDecoration(
                color: widget.color,
              ),
              child: widget.showIcon
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.showIcon && widget.iconPosition == P.Left)
                          Icon(
                            widget.iconData ??
                                (Platform.isIOS
                                    ? Icons.keyboard_arrow_right
                                    : Icons.arrow_forward),
                            color: widget.textColor ?? childColor,
                          ),
                        if (widget.showIcon && widget.iconPosition == P.Left)
                          const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            widget.text.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: widget.style.copyWith(
                              color: widget.textColor ?? childColor,
                              fontWeight: FontWeight.w500,
                              fontSize: widget.fontSize,
                            ),
                          ),
                        ),
                        if (widget.showIcon && widget.iconPosition == P.Right)
                          const SizedBox(width: 10),
                        if (widget.showIcon && widget.iconPosition == P.Right)
                          Icon(
                            widget.iconData ??
                                (Platform.isIOS
                                    ? Icons.keyboard_arrow_right
                                    : Icons.arrow_forward),
                            color: widget.textColor ?? childColor,
                          )
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.text.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: (widget.style ?? const TextStyle()).copyWith(
                            color: widget.textColor ?? childColor,
                          ),
                        ),
                        SizedBox(height: IconTheme.of(context).size)
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  MyCustomClipper(this.cut);
  final Cut cut;

  @override
  Path getClip(Size size) {
    final Path bottomLeftPath = Path()
      ..lineTo(30, size.height - 20)
      ..arcToPoint(
        Offset(70, size.height),
        radius: const Radius.circular(60.0),
        clockwise: false,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    final Path bottomRightPath = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 30, size.height - 20)
      ..arcToPoint(
        Offset(size.width - 70, size.height),
        radius: const Radius.circular(60.0),
      )
      ..lineTo(0, size.height)
      ..close();

    final Path topLeftPath = Path()
      ..lineTo(70, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(30, 20)
      ..arcToPoint(
        const Offset(70, 0),
        radius: const Radius.circular(60.0),
        clockwise: true,
      )
      ..close();

    final Path topRightPath = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - 30, 20)
      ..arcToPoint(
        Offset(size.width - 70, 0),
        radius: const Radius.circular(60.0),
        clockwise: false,
      )
      ..close();

    if (cut == Cut.BR) {
      return bottomRightPath;
    }
    if (cut == Cut.BL) {
      return bottomLeftPath;
    }
    if (cut == Cut.TL) {
      return topLeftPath;
    }
    if (cut == Cut.TR) {
      return topRightPath;
    }
    return bottomLeftPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
