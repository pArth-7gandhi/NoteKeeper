import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notekeeperdatabase/models/note.dart';
import 'package:notekeeperdatabase/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'note_details.dart';


class NoteList extends StatefulWidget {

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<Note> noteList;
  int count=0;
  @override
  Widget build(BuildContext context) {
    if(noteList== null)
      {
        noteList=List<Note>();
        updateListView();
      }
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),

      ),
      body: getNoteListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint('TTT');
           navigate(Note('','',2,''),'Add Note');
//          NoteDetail();
//          navigateToDetails('Add Note');
        },
        tooltip: 'Add Note',

        child: Icon(Icons.add),
      ),

    );
  }

  ListView getNoteListView(){
    TextStyle titleStyle= Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context,int position){
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(this.noteList[position].title,style: titleStyle),
              subtitle: Text(this.noteList[position].date),

              trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey,),
                  onTap: (){
                    delete(context, noteList[position]);
                  },
              ),
              onTap: (){
                debugPrint('XXX');
                navigate(Note.withId(this.noteList[position].id,this.noteList[position].title,this.noteList[position].date,this.noteList[position].priority,this.noteList[position].description),'Edit Note');
              },

            ),
          );
        }
    );
  }

  // Priority Color
  Color getPriorityColor(int priority)
  {
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.amber;
        break;
      default:
        return Colors.amber;
    }
  }

  //Priority Icon
  Icon getPriorityIcon(int priority)
  {
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }


  // Delete a Card
  void delete(BuildContext context,Note note) async{
    int result=await databaseHelper.deleteNote(note.id);
    if(result!=0){
      final snackBar = SnackBar(content: Text('Note deleted Successfully!'));
      Scaffold.of(context).showSnackBar(snackBar);
      updateListView();
    }
  }

  void navigate(Note note,String title) async{
   bool result=await Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetail(note:note,appBartitle: title,)),);

   if(result==true)
     {
       updateListView();
     }
  }

  void updateListView(){
    final Future<Database> dbFuture=databaseHelper.initializeDatabase();
    dbFuture.then((database)
    {
      Future<List<Note>> noteListFuture=databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList=noteList;
          this.count=noteList.length;
        });
      });
    });
  }
}
