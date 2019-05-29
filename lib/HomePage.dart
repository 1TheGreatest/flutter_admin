import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'tickets.dart';

class HomePage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => new _HomePageState();

}

class _HomePageState extends State<HomePage> {


  List<MovieTickets> _movieTicketsList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _movieTicketsQuery;

  @override
  void initState() {
    super.initState();



    _movieTicketsList = new List();

    _movieTicketsQuery = _database
        .reference()
        .child("movie tickets")
        .orderByChild("userId");
    _onTodoAddedSubscription = _movieTicketsQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription = _movieTicketsQuery.onChildChanged.listen(_onEntryChanged);

  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  _onEntryChanged(Event event) {
    var oldEntry = _movieTicketsList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      _movieTicketsList[_movieTicketsList.indexOf(oldEntry)] = MovieTickets.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      _movieTicketsList.add(MovieTickets.fromSnapshot(event.snapshot));
    });
  }

  _updateMovie (MovieTickets tickets){
    //Toggle completed
    tickets.completed = "Successful";
    if (tickets != null) {
      _database.reference().child("movie tickets").child(tickets.key).set(tickets.toJson());
    }
  }

  _deleteTodo(String ticketsId, int index) {
    _database.reference().child("movie tickets").child(ticketsId).remove().then((_) {
      print("Delete $ticketsId successful");
      setState(() {
        _movieTicketsList.removeAt(index);
      });
    });
  }

  _showMovieTicketList() {
    if (_movieTicketsList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _movieTicketsList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _movieTicketsList[index].key;
            String typeofTicket = _movieTicketsList[index].typeofTicket;
            String numberOfTicket = _movieTicketsList[index].numberOfTicket;
            String time = _movieTicketsList[index].time;
            String amountPaid = _movieTicketsList[index].amountPaid;
            String subject = _movieTicketsList[index].subject;
            String completed = _movieTicketsList[index].completed;
            String userId = _movieTicketsList[index].userId;
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
                            _updateMovie (_movieTicketsList[index]);
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
          ' Movie Ticket Orders ',
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

      body: _showMovieTicketList(),
    );
  }


}