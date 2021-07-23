import "package:flutter/material.dart";
import 'package:watch_app_poc/models/watch_item.dart';
import 'package:watch_app_poc/views/watch_detail_page.dart';

class CartScreen extends StatefulWidget {
  List<WatchItem> cartItems = [];
  CartScreen({required this.cartItems});
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
      body: Container(
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return SafeArea(
      child: widget.cartItems.length != 0
          ? OrientationBuilder(builder: (context, orientation) {
              return Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: GridView.count(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 4,
                        childAspectRatio: 1 / 1.3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        padding: EdgeInsets.all(5.0),
                        children: widget.cartItems
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
                                                fontSize: 12,
                                                color: Colors.black),
                                            textAlign: TextAlign.center),
                                        Text(data.description,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black),
                                            textAlign: TextAlign.center),
                                        Text(data.price.toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            textAlign: TextAlign.center),
                                        Container(
                                          child: ElevatedButton(
                                            child: Text(
                                              'Remove from Cart',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              this.removeFromCart(data);
                                            },
                                          ),
                                          margin: EdgeInsets.only(top: 20.0),
                                        )
                                      ],
                                    ),
                                  )),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        child: Text(
                          'Place Order',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          this.placeOrder();
                        },
                      ),
                      margin: EdgeInsets.only(top: 20.0),
                    )
                  ],
                ),
              );
            })
          : OrientationBuilder(builder: (context, orientation) {
              return Center(
                  child: Text("Cart is Empty",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                      textAlign: TextAlign.center));
            }),
    );
  }

  void removeFromCart(WatchItem item) {
    setState(() {
      if (widget.cartItems.contains(item)) {
        widget.cartItems.removeAt(this.widget.cartItems.indexOf(item));
      }
    });
  }

  void placeOrder() {
    showAlertDialog(context);
    final snackBar = SnackBar(content: Text('Yay! Order Placed!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      widget.cartItems.removeRange(0, widget.cartItems.length);
    });
  }

  void showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order!"),
      content: Text("Order placed successfully"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
