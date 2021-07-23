import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:watch_app_poc/models/watch_item.dart';
import 'package:watch_app_poc/views/cart_page.dart';
import 'package:watch_app_poc/views/watch_detail_page.dart';

import 'add_watch_item_form_page.dart';

class HomeWatchListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeWatchListScreen();
  }
}

class _HomeWatchListScreen extends State<HomeWatchListScreen> {
  List<WatchItem> watchItems = [];
  List<WatchItem> cartItems = [];
  List<String> cartItemIds = [];
  int cartCount = 0;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
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
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          Stack(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CartScreen(cartItems: cartItems)));
                    setState(() {
                      cartCount = this.cartItems.length;
                    });
                  }),
              Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6)),
                    constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                    child: Text(
                      '$cartCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ))
            ],
          ),
        ],
      ),
      body: Container(
        child: _buildList(),
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
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewItemScreen()));
          setState(() {});
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildList() {
    return SafeArea(
        child: watchItems.length != 0
            ? RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: getWatches,
                child: OrientationBuilder(builder: (context, orientation) {
                  return GridView.count(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                    childAspectRatio: 1 / 1.3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    padding: EdgeInsets.all(5.0),
                    children: watchItems
                        .map(
                          (data) => GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ItemDetailScreen()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Image.network(
                                        data.imageUrl.isNotEmpty
                                            ? data.imageUrl
                                            : "https://images-na.ssl-images-amazon.com/images/I/81wGRwNp2VL._UL1500_.jpg",
                                        width: 250,
                                        height: 100),
                                    Text(data.title,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                        textAlign: TextAlign.center),
                                    Text(data.description,
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.black),
                                        textAlign: TextAlign.center),
                                    Text(data.price.toString(),
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        textAlign: TextAlign.center),
                                    Container(
                                      child: ElevatedButton(
                                        child: Text(
                                          this.cartItems.contains(data)
                                              ? 'Remove from Cart'
                                              : 'Add to Cart',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          this.addToCart(data);
                                        },
                                      ),
                                      margin: EdgeInsets.only(top: 20.0),
                                    )
                                  ],
                                ),
                              )),
                        )
                        .toList(),
                  );
                }),
              )
            : Center(child: CircularProgressIndicator()));
  }

  void addToCart(WatchItem item) {
    setState(() {
      if (this.cartItems.contains(item)) {
        this.cartItems.removeAt(this.cartItems.indexOf(item));
      } else {
        this.cartItems.add(item);
      }
      cartCount = this.cartItems.length;
    });
  }

  Future<void> getWatches() async {
    List<WatchItem> localItems = [];
    http.Response response = await http.get(Uri.parse(
        "https://react-my-burger-64464-default-rtdb.firebaseio.com/products.json"));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      var keys = responseData.keys;
      print(keys);
      for (String item in keys) {
        var value = responseData[item];
        if (value is Map<String, dynamic>) {
          WatchItem item = new WatchItem(
              id: value["id"] ?? "",
              title: value["title"] ?? "",
              description: value["description"] ?? "",
              imageUrl: value["imageUrl"] ??
                  "https://images-na.ssl-images-amazon.com/images/I/81wGRwNp2VL._UL1500_.jpg",
              price: value["price"] ?? "");
          localItems.add(item);
        }
      }
      setState(() {
        if (watchItems.isNotEmpty) {
          watchItems.removeRange(0, watchItems.length);
        }
        if (cartItems.isNotEmpty) {
          cartItems.removeRange(0, cartItems.length);
        }
        cartCount = this.cartItems.length;
        watchItems.addAll(localItems);
      });
    } else {
      throw Exception('Failed to fetch items.');
    }
  }
}
