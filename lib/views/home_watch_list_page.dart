import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";

import 'package:watch_app_poc/main.dart';
import 'package:watch_app_poc/models/watch_item.dart';

class HomeWatchListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeWatchListScreen();
  }
}

class _HomeWatchListScreen extends State<HomeWatchListScreen> {
  List<WatchItem> watchItems = [];

  @override
  void initState() {
    super.initState();
    getWatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy Watches!"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: watchItems
            .map(
              (data) => GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Text(data.title,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            textAlign: TextAlign.center),
                        Text(data.description,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            textAlign: TextAlign.center)
                      ],
                    ),
                  )),
            )
            .toList(),
      ),
      drawer: Drawer(
        child: ListView(
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Hello',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void getWatches() async {
    http.Response response = await http.get(Uri.parse(
        "https://react-my-burger-64464-default-rtdb.firebaseio.com/products.json?print=pretty"));
    Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    WatchItem item = new WatchItem(
        id: responseData["id"],
        title: responseData["title"],
        description: responseData["description"],
        imageUrl: responseData["imageUrl"],
        price: responseData["price"]);
    setState(() {
      print(item);
      watchItems.add(item);
    });
  }
}
