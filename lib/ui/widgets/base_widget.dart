import 'package:flutter/material.dart';

class BaseWidget extends StatelessWidget {
  const BaseWidget({
    Key? key,
    required this.title,
    this.appBarLeading,
    this.appBarActions,
    required this.child,
  }) : super(key: key);
  final String title;
  final Widget? appBarLeading;
  final List<Widget>? appBarActions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: appBarLeading,
        actions: appBarActions,
      ),
      body: child,
    );
  }
}
