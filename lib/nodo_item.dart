import 'package:flutter/material.dart';
import 'package:notodo_app/notodo_screen.dart';

class NoDoItem extends StatelessWidget {
  String _itemName;
  String _dateCreated;
  int _id;

  NoDoItem(this._itemName,this._dateCreated);  //Constructor

  NoDoItem.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  //setters and getters
  set itemName(String value) {   //setter for only itemName was required (in _handleSubmittedUpdate method) so I only created a setter for that!
    _itemName = value;
  }
  //getters
  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  int get id => _id;

  Map<String,dynamic> toMap(){
    var map = new Map<String,dynamic>();
    map["itemName"] = _itemName;
    map["dateCreated"] = _dateCreated;
    if(_id!=null){
      map["id"] = _id;
    }
    return map;
  }
  NoDoItem.fromMap(Map<String,dynamic> map){
    this._itemName = map["itemName"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_itemName,style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize: 22.0),),
              Container(margin: const EdgeInsets.only(top:5.0),
                child: Text("Created on: $_dateCreated",
                  style: TextStyle(color: Colors.white70,fontSize: 13.5,fontStyle: FontStyle.italic),),)

            ],

          ),
        ],
      ),
    );
  }
}
