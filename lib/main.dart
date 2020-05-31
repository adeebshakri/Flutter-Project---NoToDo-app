import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NoToDo",
      home: new Home(),
    );
  }
}
