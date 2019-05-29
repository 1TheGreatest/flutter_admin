import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'tickets.dart';

class TransportPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => new _TransportPageState();

}

class _TransportPageState extends State<TransportPage> {

  List<TransportTickets> _transportTicketsList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _transportTicketsQuery;

  @override
  void initState() {
    super.initState();



    _transportTicketsList = new List();

    _transportTicketsQuery = _database
        .reference()
        .child("transport tickets")
        .orderByChild("userId");
    _onTodoAddedSubscription = _transportTicketsQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription = _transportTicketsQuery.onChildChanged.listen(_onEntryChanged);

  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  _onEntryChanged(Event event) {
    var oldEntry = _transportTicketsList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      _transportTicketsList[_transportTicketsList.indexOf(oldEntry)] = TransportTickets.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      _transportTicketsList.add(TransportTickets.fromSnapshot(event.snapshot));
    });
  }

  _updateTransport (TransportTickets tickets){
    //Toggle completed
    tickets.completed = "Successful";
    if (tickets != null) {
      _database.reference().child("transport tickets").child(tickets.key).set(tickets.toJson());
    }
  }

  _deleteTodo(String ticketsId, int index) {
    _database.reference().child("transport tickets").child(ticketsId).remove().then((_) {
      print("Delete $ticketsId successful");
      setState(() {
        _transportTicketsList.removeAt(index);
      });
    });
  }

  _showTicketList() {
    if (_transportTicketsList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _transportTicketsList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _transportTicketsList[index].key;
            String typeofTicket = _transportTicketsList[index].typeofTicket;
            String numberOfTicket = _transportTicketsList[index].numberOfTicket;
            String time = _transportTicketsList[index].time;
            String amountPaid = _transportTicketsList[index].amountPaid;
            String subject = _transportTicketsList[index].subject;
            String completed = _transportTicketsList[index].completed;
            String userId = _transportTicketsList[index].userId;
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
                            _updateTransport (_transportTicketsList[index]);
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
          ' Transport Ticket Orders ',
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

      body: _showTicketList()

    );
  }


}