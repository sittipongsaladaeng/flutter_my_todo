import 'package:flutter/material.dart';

class AddTODOScreen extends StatefulWidget {
  AddTODOScreen({this.callback});

  final void Function(String) callback;

  @override
  _AddTODOScreenState createState() => _AddTODOScreenState();
}

class _AddTODOScreenState extends State<AddTODOScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _ctrEdtTODO = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('ADD'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 50,
              width: double.maxFinite,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _ctrEdtTODO,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      filled: true,
                      hintText: 'Enter TODO here...',
                      fillColor: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: RaisedButton(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue)),
                child: Text(
                  'ADD TODO',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                color: Colors.blue,
                elevation: 0.0,
                highlightElevation: 0.0,
                splashColor: Colors.blue,
                onPressed: () {
                  _add();
                },
              ),
              width: double.maxFinite,
              height: 45.0,
            )
          ],
        ),
      ),
    );
  }

  void _add() {
    if (_ctrEdtTODO.text != null && _ctrEdtTODO.text != '') {
      widget.callback(_ctrEdtTODO.text);
      Navigator.pop(context);
    }
  }
}
