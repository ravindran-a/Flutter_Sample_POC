import "package:flutter/material.dart";
import 'package:watch_app_poc/models/add_watch_item.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class AddNewItemScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddNewItemScreen();
  }
}

class _AddNewItemScreen extends State<AddNewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  AddNewWatchItem _item = new AddNewWatchItem();

  @override
  void initState() {
    super.initState();
  }

  Future<void> submit() async {
    // First validate form.
    if (this._formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save our form now.
      final response = await http.post(
        Uri.parse(
            'https://react-my-burger-64464-default-rtdb.firebaseio.com/products.json'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': this._item.title,
          'description': this._item.description,
          'price': this._item.price,
          'imageUrl': this._item.imageUrl
        }),
      );

      if (response.statusCode == 200) {
        _formKey.currentState!.reset();
        final snackBar = SnackBar(content: Text('Yay! Item Added!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        throw Exception('Failed to add item.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Item For Sale!"),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: SafeArea(
              child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                TextFormField(
                  keyboardType:
                      TextInputType.text, // Use email input type for emails.
                  decoration: new InputDecoration(
                      hintText: 'Armani/Rolex', labelText: 'Item Title'),
                  onSaved: (String? value) {
                    this._item.title = value;
                  },
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? "Title is required"
                        : null;
                  },
                ),
                TextFormField(
                  keyboardType:
                      TextInputType.text, // Use secure text for passwords.
                  decoration: new InputDecoration(
                      hintText: 'Details', labelText: 'Item Description'),
                  onSaved: (String? value) {
                    this._item.description = value;
                  },
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? "Description is required"
                        : null;
                  },
                ),
                TextFormField(
                    keyboardType:
                        TextInputType.text, // Use secure text for passwords.
                    decoration: new InputDecoration(
                        hintText: 'Image', labelText: 'Item Image URL'),
                    onSaved: (String? value) {
                      this._item.imageUrl = value;
                    }),
                TextFormField(
                    keyboardType:
                        TextInputType.text, // Use secure text for passwords.
                    decoration: new InputDecoration(
                        hintText: 'Price', labelText: 'Item Price'),
                    onSaved: (String? value) {
                      this._item.price = value;
                    },
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? "Price is required"
                          : null;
                    }),
                new Container(
                  width: screenSize.width,
                  child: ElevatedButton(
                    child: new Text(
                      'Submit',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      this.submit();
                    },
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          ))),
    );
  }
}
