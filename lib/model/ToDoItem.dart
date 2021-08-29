import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  String? _itemName;
  String? _dataCreated;
  int? _id;

  TodoItem(this._itemName, this._dataCreated);

  TodoItem.map(dynamic obj) {
    this._itemName = obj['itemName'];
    this._dataCreated = obj['dateCreated'];
    this._id = obj['id'];
  }
  TodoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map['itemName'];
    this._dataCreated = map['dateCreated'];
    this._id = map['id'];
  }
  String? get itemName => _itemName;

  String? get dataCreated => _dataCreated;

  int? get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['itemName'] = _itemName;
    map['dateCreated'] = _dataCreated;

    if (_id != null) {
      map['id'] = _id;
    }
    return map;
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
              new Text(
                _itemName!,
                style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.9),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(
                  "Created on:$_dataCreated",
                  style: new TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
