import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ClassWork'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<String> countries;
  late Random r;
  late GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    // TODO: implement initState
    refreshKey = GlobalKey<RefreshIndicatorState>();
    super.initState();
    r = Random();
    countries = [];
    addCountries();
  }

  addCountries() {
    countries.add("America");
    countries.add("Russia");
    countries.add("Canada");
    countries.add("Bangladesh");
    countries.add("AUstrila");
    countries.add("Mexico");
  }

  Widget showList() {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: countries.length,
        itemBuilder: (BuildContext context, int index) {
          return rowItem(context, index);
        });
  }

  Widget rowItem(context, index) {
    return Dismissible(
      key: Key(countries[index]),
      onDismissed: (direction) {
        var country = countries[index];
        showSnacBar(context, country, index);
        removeCountry(index);
      },
      background: deleteBgItem(),
      child: Card(
        child: ListTile(
          title: Text(countries[index]),
        ),
      ),
    );
  }

  Widget deleteBgItem() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  showSnacBar(context, country, index) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$country deleted'),
      action: SnackBarAction(
        label: "UNDO ITEM",
        onPressed: () {
          undoDelete(index, country);
        },
      ),
    ));
  }

  undoDelete(index, country) {
    setState(() {
      countries.insert(index, country);
    });
  }

  removeCountry(index) {
    setState(() {
      countries.removeAt(index);
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    addRabdomCountry();
    return null;
  }

  addRabdomCountry() {
    int nextItem = r.nextInt(200);
    setState((){
      countries.add('Country $nextItem');
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: showList(),
        onRefresh: () async {
          await refreshList();
        },
      ),
    );
  }
}
