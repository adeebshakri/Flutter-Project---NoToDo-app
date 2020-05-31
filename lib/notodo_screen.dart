import 'package:flutter/material.dart';
import 'package:notodo_app/database_client.dart';
import 'package:notodo_app/nodo_item.dart';

import 'date_formatter.dart';

class NoToDoScreen extends StatefulWidget {
  @override
  _NoToDoScreenState createState() => _NoToDoScreenState();
}

class _NoToDoScreenState extends State<NoToDoScreen> {
  final _textEditingController = new TextEditingController();
  var db = new DatabaseHelper();

  final List<NoDoItem> _itemList = <NoDoItem>[]; //each time the user adds an item , we'll add that to List _itemList
  //_itemList will be working for front end part ie to show on screen (not on backend(database))

  @override //overriding initState() method : What this initState() method is gonna do is  each time we have to reinstate our state(in this case our application) or draw our screen, this method will be called first!!
  void initState() {
    super.initState();
    _readNoDoList(); //calling _readNoDoList() everytime initState is called (Start of app)
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();
    NoDoItem noDoItem = new NoDoItem(text, dateFormatted());
    int savedItemId = await db.saveItem(noDoItem);
    print("Save Item Id: $savedItemId");

    NoDoItem addedItem = await db.getItem(savedItemId);
    setState(() {
      //in order to redraw our view(the NoToDo Screen) everytime we save
      _itemList.insert(0, addedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: new EdgeInsets.all(8.0), //padding around entire Listview
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int index) {
                //itemBuilder returns a widget
                return Card(
                  color: Colors.white10,
                  child: ListTile(
                    title: _itemList[index], //passing the object(the item)
                    onLongPress: () => _updateItem(_itemList[index] , index),
                    trailing: Listener(
                      //Listener(an object) allows us to listen to events
                      key: Key(_itemList[index].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (pointerEvent) => debugPrint(_deleteNoDo(_itemList[index].id, index)), //onPointerDown means our finger has tapped the screen, the circle there
                    ),
                  ),
                );
              },
            ),
          ),  
          Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: "Add Item",
        backgroundColor: Colors.redAccent,
        child: new ListTile(
          title: new Icon(Icons.add),
        ),
        onPressed: _showFormDialog,
      ),
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
            decoration: InputDecoration(
                labelText: "Item",
                hintText: "Eg. Don't buy this thing",
                icon: Icon(Icons.note_add)),
          ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(
                  context); //to get rid of the white dialog box evrytime we click save and go back to the context i.e the NoDo Screen
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          //    _ means context
          return alert;
        });
  }

  _readNoDoList() async {
    List items =
        await db.getItems(); //will get our database and get all the items
    items.forEach((item) {
      //NoDoItem noDoItem = NoDoItem.fromMap(item);

      setState(() {
        //setState method helps views(screen) to be redrawn everytime with new data (i.e refresh)
        _itemList.add(NoDoItem.map(
            item)); //as we loop through , it will go n get all our items in _itemList
      });
      // print("Db items: ${noDoItem.itemName}");
    });
  }

  _deleteNoDo(int id, int index) async{
  debugPrint("An Item Deleted!");
  await db.deleteItem(id);   // to delete it from the database(backend)
  setState(() {  //here setState method is used to refresh the screen(view) with latest data everytime we delete some item (ie to refresh the screen)
    _itemList.removeAt(index);
  });
  }

  _updateItem(NoDoItem item, int index) { //we could have refactored here too to loose extra fat code
    var alert = new AlertDialog(
      title: Text("Update an Item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                controller: _textEditingController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Item",
                    hintText: "Eg. Don't do this!!",
                    icon: Icon(Icons.update)),
              ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              NoDoItem newItemUpdated = NoDoItem.fromMap(
               {"itemName": _textEditingController.text,           //key-value pairs
                "dateCreated" : dateFormatted(),
                "id": item.id
               }
              );
              _handleSubmittedUpdate(index,item);  //redrawing the screen
              await db.updateItem(newItemUpdated);  //updating the item
              setState(() {
                _readNoDoList();   //redrawing the screen with all items saved in db
              });
              Navigator.pop(context);
            },
            child: Text("Update")),
        FlatButton(onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          //    _ means context
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, NoDoItem item) {  //_handleSubmittedUpdate will be called the moment we hit update
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName = item.itemName;

      });
    });

  }
                                           
}
