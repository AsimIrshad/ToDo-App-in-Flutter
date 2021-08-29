import 'package:flutter/material.dart';
import 'package:todoapp/model/ToDoItem.dart';
import 'package:todoapp/util/dbhelper.dart';

import 'date_formatter.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  var db = new DatabaseHelper();
  final List<TodoItem>? _itemlist = <TodoItem>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readNoDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _itemlist!.length,
                itemBuilder: (_, int index) {
                  return new Card(
                      color: Colors.white10,
                      child: new ListTile(
                        title: _itemlist![index],
                        onLongPress: () =>
                            _updateitem(_itemlist![index], index),
                        trailing: new Listener(
                          key: new Key(_itemlist![index].itemName!),
                          child: new Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                          ),
                          onPointerDown: (pointerEvent) =>
                              _deleteNode(_itemlist![index].id, index),
                        ),
                      ));
                }),
          ),
          new Divider(
            height: 1.0,
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: 'Add Item',
          backgroundColor: Colors.redAccent,
          child: ListTile(title: Icon(Icons.add)),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "item",
                hintText: "e.g Dont but stuff",
                icon: new Icon(Icons.note_add)),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text('Save')),
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();

    TodoItem noDoItem = TodoItem(text, dateFormatted());
    int SavedItemId = await db.saveItem(noDoItem);
    TodoItem? addedItem = await db.getItem(SavedItemId);
    setState(() {
      _itemlist!.insert(0, addedItem!);
    });
  }

  void _readNoDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      setState(() {
        _itemlist!.add(TodoItem.map(item));
      });
    });
  }

  _deleteNode(int? id, int index) async {
    debugPrint("Deleted Item!");
    await db.deleteItem(id!);
    setState(() {
      _itemlist!.removeAt(index);
    });
  }

  _updateitem(TodoItem itemlist, int index) {
    var alert = new AlertDialog(
      title: new Text("Update item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "item",
                hintText: "e.g Dont but stuff",
                icon: new Icon(Icons.note_add)),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              TodoItem newItemUpdated = TodoItem.fromMap({
                "itemName": _textEditingController.text,
                "dateCreated": dateFormatted(),
                "id": itemlist.id,
              });
              _handleSubmittedUpdate(index, itemlist);
              await db.updateItem(newItemUpdated);
              setState(() {
                _readNoDoList();
              });
              Navigator.pop(context);
            },
            child: Text('Update')),
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, TodoItem itemlist) {
    setState(() {
      _itemlist!.removeWhere(
          (element) => _itemlist![index].itemName == itemlist.itemName);
    });
  }
}
