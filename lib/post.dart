import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/generate.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(String title) async {
  final http.Response response = await http.post(
    'https://192.168.1.102:5000/payment',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "storeName": "Johnny's Hut",
      "orderNumber": "997",
      "orderList": "Bagel, Extra Cream Cheese, Coffee",
      "totalPrice": "9",
      "userName": "john"
    }),
  );

  if (response.statusCode == 201) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Album {
  final String id;
  final String title;
  final String storeName;
  final String orderNumber;
  final String orderList;
  final String totalPrice;
  final String userName;

  Album({this.id, this.title, this.storeName, this.orderNumber, this.orderList, this.totalPrice, this.userName});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
        storeName: json['storeName'],
        orderNumber: json['orderNumber'],
        orderList: json['orderList'],
        totalPrice: json['totalPrice'],
        userName: json['userName']
    );
  }
}

void main() {
  runApp(MyAppp());
}

class MyAppp extends StatefulWidget {
  MyAppp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyAppp> {
  final TextEditingController _controller = TextEditingController();
  Future<Album> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null)
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Enter Order'),
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Enter Price'),
              ),
              RaisedButton(
                child: Text('Submit'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                  setState(() {
                    _futureAlbum = createAlbum(_controller.text);
                  });
                },
              ),
            ],

          )
              : FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.orderNumber);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return HomePage();
    return GeneratePage();
  }
}