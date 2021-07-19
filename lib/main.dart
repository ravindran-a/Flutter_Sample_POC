import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'views/home_watch_list_page.dart';

void main() => runApp(WatchApp());

class WatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Buy Watches!",
        theme: ThemeData.light(),
        home: HomeWatchListScreen());
  }
}
