import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:notekeeperdatabase/models/note.dart';
import 'package:notekeeperdatabase/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'note_list.dart';

class NoteDetail extends StatefulWidget {
  final String appBartitle;
  final Note note;
  NoteDetail({this.note, this.appBartitle});
  @override
   State<StatefulWidget> createState() {
    return _NoteDetailState(this.note,this.appBartitle);
  }
  }

class _NoteDetailState extends State<NoteDetail> {
  String appBartitle;
  Note note;
  DatabaseHelper databaseHelper=DatabaseHelper();
  static var _priorities=["High","Low"];

  final title=TextEditingController();
  final desc=TextEditingController();

  _NoteDetailState(this.note,this.appBartitle);
  final _formKey = GlobalKey<FormState>();
//  final myController = TextEditingController();
  bool _validate = false;

  void dispose() {
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =Theme.of(context).textTheme.title;
    title.text=note.title;
    desc.text=note.description;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appBartitle),
      ),
      body:Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(top: 40.0, left: 10.0,right: 10.0),
            child: ListView(
//            shrinkWrap: true,

              children: <Widget>[
                Text('Select Note priority: ',
                style : TextStyle(
                  fontSize: 20.0,
                )
                ),
                SizedBox(width: 20.0),

                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String item){
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    style: textStyle,
                    value:updatePrioritytoString(note.priority),
                    onChanged:(value){
                      setState(()
                      {
                        debugPrint('User selected $value');
                        updatePriority(value);
                      });
                    },
                  ),
                ),

                  SizedBox(height: 15.0),

                  Padding(

                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: title,
                    style: textStyle,

                    onChanged: (value){
                      debugPrint('Something Changed in title');
                      if(value.isNotEmpty)
                        {
                          updateTitle();
                        }

                    },


                    decoration: InputDecoration(
                      labelText: 'Title',
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                  ),

                SizedBox(height: 15.0),

                Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: desc,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something Changed in description');
                      updateDesc();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                SizedBox(height: 15.0),

                Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.grey,
                          textColor: Colors.black,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: (){


                            if(title.text.isEmpty)
                              {
//                                valueEmpty(context);
                              showAlertDialog(context,"Enter Valid Data.");
                            }
                            else {
                              setState(() {
                                title.text.isEmpty ? _validate = true : _validate = false;
                                debugPrint('SAVEDD');
                                save();
                              });
                            }
                          },
                        )
                      ),

                      SizedBox(width: 20.0),

                      Expanded(
                          child: RaisedButton(
                            color: Colors.grey,
                            textColor: Colors.black,
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: (){
                              setState(() {

                                debugPrint('DELETE');
                                delete();
                              });
                            },
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      ),
      
    );
  }

  showAlertDialog(BuildContext context,String val) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert."),
      content: Text(val),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void moveToLastScreen(){
    if(title.text!=null)
      {
        Navigator.pop(context,true);
      }

  }
  
  void updatePriority(String value)
  {
    switch(value){
      case 'High':
        note.priority=1;
        break;
      case 'Low':
        note.priority=2;
        break;
    }
  }

  String updatePrioritytoString(int value)
  {
    String priority;
    switch(value){
      case 1:
        priority=_priorities[0];
        break;
      case 2:
        priority=_priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle(){
    note.title=title.text;
  }

  void updateDesc(){
    note.description=desc.text;
  }

  void valueEmpty(BuildContext context)
  {
    final snackBar = SnackBar(content: Text('Value cant be empty!'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void save() async{
//    moveToLastScreen();
  if(_validate!=true)
    {
      moveToLastScreen();
    }

    note.date= DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id !=null){
     result= await databaseHelper.updateNote(note);
    }
    else{
      result=await databaseHelper.insertNote(note);
    }

    if(result!=0) {
      return showDialog(child: AlertDialog(
        title: Text("Error."),
        content: Text("Data added."),
      ));
    }
    else
      {
        return showDialog(child: AlertDialog(
            title: Text("Error."),
        content: Text("Data added."),
            ));
      }
  }

  void delete() async{

    if(note.title==null )
      {
        showAlertDialog(context,"Note in Empty.");
      }

    int result=await databaseHelper.deleteNote(note.id);
    if(result!=0) {
      if(appBartitle=='Edit Note')
      {
        moveToLastScreen();
      }
      else{
        showAlertDialog(context,"Note was Deleted successfully.");
      }
    }
    else if(note.id==null &&note.title!=null)
      {
        moveToLastScreen();
      }
    else
    {
      showAlertDialog(context,"Error occoured while deleting note.");
    }
  }
  
}
