import 'dart:convert';
import 'package:flutter/material.dart';
import 'models.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Nasa>> nasa;
  final String url = 'http://apodapi.herokuapp.com/api/?count=5';

  Future<List<Nasa>> fetchNasa() async {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body);

      if (jsonList is List) {
        return jsonList.map((json) => Nasa.fromJson(json)).toList();
      }
    }
    throw Exception('Http call not made');
  }

  @override
  void initState() {
    super.initState();
    nasa = fetchNasa();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        elevation: 16,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'Nasa APOD',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: () {
              setState(() {
                nasa = fetchNasa();
              });
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: nasa,
        builder: (BuildContext context, AsyncSnapshot<List<Nasa>> snapshot){
          if(snapshot.hasData){
            return ListView(
              padding: EdgeInsets.all(16),
              children: snapshot.data.map((nasa) => NasaCard(nasa: nasa)).toList(),
            );
          }
          else if (snapshot.hasError){
            return Error(error: snapshot.error);
          }
          else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            )
          }
      },
      ),
    );
  }
}
