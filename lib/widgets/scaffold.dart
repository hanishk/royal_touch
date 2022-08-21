import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({this.appBar, this.body, this.drawer, this.color});
  final Widget appBar, body, drawer;
  final Color color;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      backgroundColor: color ?? Theme.of(context).canvasColor,
      body: body ??
          Container(
            child: const Center(child: Text('No body')),
          ),
    );
  }
}
