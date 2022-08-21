import 'package:flutter/material.dart';

class AppButtons {
  AppButtons._();
  static Widget textButton(
    BuildContext context, {
    @required Function onPressed,
    @required String buttonText,
    bool toUpperCase = false,
    Color bgColor,
    bool rounded = false,
  }) =>
      Container(
        width: 170,
        child: RaisedButton(
          elevation: rounded ? 0.0 : 5.0,
          shape: rounded
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200.0))
              : Theme.of(context).buttonTheme.shape,
          onPressed: onPressed,
          color: bgColor,
          child: Text(
            toUpperCase ? buttonText.toUpperCase() : buttonText,
          ),
          disabledColor: Theme.of(context).disabledColor,
          textTheme: Theme.of(context).buttonTheme.textTheme,
        ),
      );

  static FlatButton textButtonPlainBg(
    BuildContext context, {
    @required Function onPressed,
    @required String buttonText,
    bool toUpperCase = false,
    bool rounded = false,
    bool padding = true,
  }) =>
      FlatButton(
        splashColor: Theme.of(context).splashColor,
        shape: rounded
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0))
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding ? 16 : 0.0),
          child: Text(
            toUpperCase ? buttonText.toUpperCase() : buttonText,
            style:
                onPressed != null ? Theme.of(context).textTheme.button : null,
          ),
        ),
        colorBrightness: Theme.of(context).brightness,
        disabledColor: Colors.transparent,
      );

  static Widget appBarBackButtons(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: IconButton(
            padding: const EdgeInsets.only(left: 8.0),
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      );
}

const EdgeInsets onlyHorizontal = EdgeInsets.symmetric(horizontal: 15.0);

const EdgeInsets onlyVertical = EdgeInsets.symmetric(vertical: 20.0);

const EdgeInsets bothHorAndVertical =
    EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0);
