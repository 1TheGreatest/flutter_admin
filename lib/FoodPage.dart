import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'tickets.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:http/http.dart' as http ;

class FoodPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => new _FoodPageState();

}

class _FoodPageState extends State<FoodPage> {

  List<FoodTickets> _foodTicketsList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _foodTicketsQuery;

  @override
  void initState() {
    super.initState();

    _foodTicketsList = new List();

    _foodTicketsQuery = _database
        .reference()
        .child("food tickets")
        .orderByChild("userId");
    _onTodoAddedSubscription = _foodTicketsQuery.onChildAdded.listen(_fonEntryAdded);
    _onTodoChangedSubscription = _foodTicketsQuery.onChildChanged.listen(_fonEntryChanged);

  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  _fonEntryChanged(Event event) {
    var oldEntry = _foodTicketsList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      _foodTicketsList[_foodTicketsList.indexOf(oldEntry)] = FoodTickets.fromSnapshot(event.snapshot);
    });
  }

  _fonEntryAdded(Event event) {
    setState(() {
      _foodTicketsList.add(FoodTickets.fromSnapshot(event.snapshot));
    });
  }

  _updateFood (FoodTickets tickets){
    //Toggle completed
    tickets.completed = "Successful";
    if (tickets != null) {
      _database.reference().child("food tickets").child(tickets.key).set(tickets.toJson());
    }
  }


  _deleteTodo(String ticketsId, int index) {
    _database.reference().child("transport tickets").child(ticketsId).remove().then((_) {
      print("Delete $ticketsId successful");
      setState(() {
        _foodTicketsList.removeAt(index);
      });
    });
  }

  _showFoodTicketList() {
    if (_foodTicketsList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _foodTicketsList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _foodTicketsList[index].key;
            String typeofTicket = _foodTicketsList[index].typeofTicket;
            String numberOfPacks = _foodTicketsList[index].numberOfTicket;
            String size = _foodTicketsList[index].size;
            String amountPaid = _foodTicketsList[index].amountPaid;
            String subject = _foodTicketsList[index].subject;
            String completed = _foodTicketsList[index].completed;
            String userId = _foodTicketsList[index].userId;
            return Dismissible(
              key: Key(todoId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                _deleteTodo(todoId, index);
              },
              child: GestureDetector(
                  child: ListTile(
                    title: Text(
                      subject,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    trailing: GestureDetector(
                        child: Text(
                          completed,
                          /*icon: (completed !='Successful')
                              ? Icon(
                            Icons.done_outline,
                            color: Colors.green,
                            size: 20.0,
                          )
                              : Icon(Icons.done, color: Colors.grey, size: 20.0),
                        icon: (completed =='Successful')
                            ? Icon(Icons.done, color: Colors.grey, size: 20.0)
                            : Icon(Icons.done_outline,color: Colors.green,size: 20.0,
                      )*/
                        ),
                        onTap: () {
                          setState(() {
                            _updateFood (_foodTicketsList[index]);
                          });
                        }
                    ),
                  ),
                  //onTap: () => _showTicketDetailsDialog(subject.toString() ,typeofTicket.toString() , time.toString(), numberOfTicket.toString() ,amountPaid.toString(), date.toString() )
              ),


            );

          });
    } else {
      return Center(child: Text("Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0),));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff01A0C7),
        title: new Text(
          ' Food Ticket Orders ',
          style: new TextStyle(color: Colors.white,
            fontFamily: 'Arvo',
            fontWeight: FontWeight.bold,),
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout', style: new TextStyle(
                  fontSize: 17.0, color: Colors.white)),
              onPressed: (){
                Navigator.pushReplacementNamed(context,'/LoginPage');
              }
          )
        ],

      ),

      body: _showFoodTicketList(),

    );

  }


}