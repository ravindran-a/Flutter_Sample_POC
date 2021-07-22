import "package:flutter/material.dart";
import 'package:watch_app_poc/models/watch_item.dart';

class CartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartScreen();
  }
}

class _CartScreen extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart!"),
      ),
    );
  }
}
