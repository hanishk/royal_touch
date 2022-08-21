import 'package:flutter/material.dart';

AppBar mainAppBar(BuildContext context,
        {@required String title,
        List<Widget> actions,
        Widget leading,
        bool automaticallyImplyLeading = true}) =>
    AppBar(
      title: Hero(
        tag: title,
        child: Material(
          color: Colors.transparent,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              // color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      leading: leading ?? (automaticallyImplyLeading ? null : Container()),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 12.0,
      shadowColor: Colors.black12,
      centerTitle: true,
      iconTheme: const IconThemeData(
        // color: Theme.of(context).primaryColor,
        color: Colors.black,
      ),
      actions: actions,
    );
