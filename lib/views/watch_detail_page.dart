import "package:flutter/material.dart";
import 'package:watch_app_poc/models/watch_item.dart';

class ItemDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ItemDetailScreen();
  }
}

class _ItemDetailScreen extends State<ItemDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Detail!"),
      ),
    );
  }
}
