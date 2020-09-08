
import 'package:flutter/material.dart';
import 'package:flutter_app/generate.dart';
import 'package:flutter_app/scan.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String price =
      "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Johnny's Shop"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Image(image: NetworkImage("https://media.istockphoto.com/vectors/qr-code-scan-phone-icon-in-comic-style-scanner-in-smartphone-vector-vector-id1166145556")),
            //flatButton("Scan QR CODE", ScanPage()),
            SizedBox(height: 20.0,),
            TextField(
              /*controller: pricedataFeed,*/
              decoration: InputDecoration(
                hintText: "Enter the order info",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                /*controller: pricedataFeed,*/
                hintText: "Input your total (in dollars)",
              ),
            ),

            flatButton("Generate QR CODE", GeneratePage()),
          ],
        ),
      ),
    );
  }

  Widget flatButton(String text, Widget widget) {
    return FlatButton(
      padding: EdgeInsets.all(15.0),
      onPressed: () async {
        if (pricedataFeed.text.isEmpty) {        //a little validation for the textfield
          setState(() {
            price = "0";
          });
        } else {
          setState(() {
            price = pricedataFeed.text;
            print(price);
          });

        }
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue,width: 3.0),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }



  final pricedataFeed = TextEditingController();

}