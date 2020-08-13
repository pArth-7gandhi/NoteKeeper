import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notekeeperdatabase/models/note.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;   //singleton DatabaseHelper
  static Database _database;

  String noteTable='note_table';
  String colId='id';
  String colTitle ='title';
  String description='description';
  String priority='priority';
  String date= 'date';


  DatabaseHelper._createInstance();    //Named constructor to create instance

  factory DatabaseHelper(){

    _databaseHelper=DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  //Only runs once
  Future<Database> get database async{
    if (_database ==null)
      {
        _database= await initializeDatabase();
      }
    return _database;
  }

  Future<Database> initializeDatabase() async{
//    Get directory or path in your mobile
    Directory directory=await getApplicationDocumentsDirectory();
    String path =directory.path+ 'notes.db';

//    Create or Open the database
    var notesDatabase=await openDatabase(path,version: 1,onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db,int newVersion) async{
    var sql='Create table $noteTable($colId integer primary key autoincrement,$colTitle String,$description String,$priority int,$date String)';
    await db.execute(sql);
  }

  //Get all Note object from DB
   Future<List<Map<String,dynamic>>> getNoteMapList() async{
    Database db=await this.database;
    var result= await db.rawQuery('Select *from $noteTable order by $priority asc ');
    return result;
  }

  //Insert into DB
  Future<int> insertNote(Note note) async{
    Database db=await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // Update in DB
  Future<int> updateNote(Note note) async{
    Database db=await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId=?',whereArgs: [note.id] );
    return result;
  }

  // Delete fro DB
  Future<int> deleteNote(int id) async{
    Database db=await this.database;
    var result = await db.rawDelete('delete from $noteTable where $colId=$id');
    return result;
  }


  // Get number of Note objects in DB
  Future<int> getCount() async{
    Database db=await this.database;
    List<Map<String,dynamic>> x=await db.rawQuery('Select count *from $noteTable');
    int result= Sqflite.firstIntValue(x);
    return result;
  }

  //Get Map List and convert it into a Note List
  Future<List<Note>> getNoteList() async{
    var noteMapList =await getNoteMapList();
    int count =noteMapList.length;
    List<Note> noteList= List<Note>();
    for (int i=0;i<count;i++)
      {
        noteList.add(Note.fromMapObj(noteMapList[i]));
      }
    return noteList;

  }


}