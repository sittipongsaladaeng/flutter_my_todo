import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_todo/add_todo_screen.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'MY TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('MyTodo')
            .orderBy('datetime', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (snapshot.data.documents.length == 0)
            return Center(child: Text('Empty', style: TextStyle(fontSize: 16)));
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(
                      document['title'],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          decoration: document['check']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    subtitle: Text(
                      "Create At: " + document['datetime'],
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    trailing: Checkbox(
                      value: document['check'],
                      onChanged: (check) {
                        _updateTodo(document.documentID, check);
                      },
                    ),
                  );
                }).toList(),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoPage();
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTODOScreen(
              callback: _addDataToFireStore,
            ),
      ),
    );
  }

  _addDataToFireStore(String title) {
    Firestore.instance
        .collection('MyTodo')
        .document()
        .setData({'title': title, 'check': false, 'datetime': _getTimeStamp()});
  }

  _updateTodo(String documentId, bool check) {
    Firestore.instance
        .collection('MyTodo')
        .document(documentId)
        .updateData({'check': check});
  }

  String _getTimeStamp() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy/mm/dd kk:mm:ss').format(now);
    print(formattedDate);
    return formattedDate;
  }
}
