class Note{
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title,this._date,this._priority,this._description);

  Note.withId(this._id,this._title,this._date,this._priority,[this._description]);

  int get id =>_id;
  String get title=> _title;
  String get description=> _description;
  String get date=> _date;
  int get priority=> _priority;

  set id(int id)
  {
    this._id=id;
  }

  set title(String newTitle){
    if(newTitle.length<=200)
      {
        this._title=newTitle;
      }
  }

  set description(String newDes){
    if(newDes.length<=200)
    {
      this._description=newDes;
    }
  }

  set priority(int newP){
    if(newP>=1 && newP<=2 )
    {
      this._priority=newP;
    }
  }

  set date(String newDate){
      this._date=newDate;
  }

  //Convert Note obj into map obj
  Map<String, dynamic > toMap()
  {
    var map= Map<String,dynamic> ();


    map['id']=_id;
    map['title']=_title;
    map['description']=_description;
    map['priority']=_priority;
    map['date']=_date;

    return map;
  }

  //Extract Note obj from map obj
  Note.fromMapObj(Map<String,dynamic> map)
  {
    this._id=map['id'];
    this._title=map['title'];
    this._date=map['date'];
    this._priority=map['priority'];
    this._description=map['description'];
  }

}