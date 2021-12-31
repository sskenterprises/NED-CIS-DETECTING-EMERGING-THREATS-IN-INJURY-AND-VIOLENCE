import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/request.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:simple_permissions/simple_permissions.dart';
import 'package:csv/csv.dart';
import 'package:json_annotation/json_annotation.dart';

void main(){
  runApp(MyApp());
}

// Future<void> caller() async {
//   var data = await getData('http://10.0.2.2:5000/');
//   var decodedData = jsonDecode(data);
//   // print(decodedData['myquery']);
//   print(decodedData["text"]);
//
// }
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var data;
  String qw = "";
  int c ;


// class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "App1",
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Home"),
          leading: Icon(Icons.home),
          backgroundColor: Colors.blueAccent,

        ),
        body: SingleChildScrollView(
          child: Center(

            child: Column(

              children: [

                Center(
                  child: Container(
                    // margin: EdgeInsets.only(top: 30.0),
                    margin: EdgeInsets.all(30.0),
                    height: 100,
                    // width: Width,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(100),
                        borderRadius: BorderRadius.circular(20),
                      color: Colors.lightBlueAccent,
                      border: Border.all(color: Colors.black,width: 2)
                    ),
                    child: Center(
                      child: Text("Web Crawler",
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.black
                        ) ,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      onChanged: (val){
                        this.qw=val;
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          
                          hintText: "Enter query keyword",
                          icon: Icon(Icons.description_outlined,color: Colors.black,)
                        // icon: Icon(Icons.person,color: Colors.black,)
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20,right: 20,bottom: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      // obscureText: true,
                      onChanged: (val){
                        this.c=int.parse(val);
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                         
                          hintText: "Enter the query count",
                          icon: Icon(Icons.account_tree_rounded,color: Colors.black)
                          // icon: Icon(Icons.lock,color: Colors.black)
                      ),
                    ),
                  ),
                ),

                FloatingActionButton.extended(
                  onPressed: () async {
                    var data = await getData('http://10.0.2.2:5000/api?qw=$qw&c=$c');
                    // var data = await getData('http://10.0.2.2:5000/');
                    // var decodedData = jsonDecode(data);
                    print('gotcha');

                    Directory tempDir = await getExternalStorageDirectory();
                    print(tempDir);
                    print("creating file...");
                    File file = new File("${tempDir.path}/scraped.csv");
                    file.writeAsString('$data');

                  },
                  label: Text("Go"),
                  icon: Icon(Icons.save),
                  foregroundColor: Colors.black,
                  hoverColor: Colors.grey,
                  backgroundColor: Colors.lightBlueAccent,

                )

              ],

            ),
          ),

        )
      )
    );
  }
}
