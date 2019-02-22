class MarkTime{

  String uid;
  String location;
  String aid;
  String act;
  String shiftid;
  String refid;
  String latit;
  String longi;

  MarkTime(this.uid, this.location, this.aid, this.act, this.shiftid, this.refid, this.latit, this.longi);

  MarkTime.fromMap(Map map){
    uid = map[uid];
    location = map[location];
    aid = map[aid];
    act = map[act];
    shiftid = map[shiftid];
    refid = map[refid];
    latit = map[latit];
    longi = map[longi];
  }
  MarkTime.fromJson(Map map){
    uid = map[uid];
    location = map[location];
    aid = map[aid];
    act = map[act];
    shiftid = map[shiftid];
    refid = map[refid];
    latit = map[latit];
    longi = map[longi];
  }


}

class MarkVisit{

  String uid;
  String cid;
  String location;
  String refid;
  String latit;
  String longi;

  MarkVisit(this.uid,this.cid, this.location, this.refid, this.latit, this.longi);

  MarkVisit.fromMap(Map map){
    uid = map[uid];
    cid = map[cid];
    location = map[location];
    refid = map[refid];
    latit = map[latit];
    longi = map[longi];
  }
  MarkVisit.fromJson(Map map){
    uid = map[uid];
    cid = map[cid];
    location = map[location];
    refid = map[refid];
    latit = map[latit];
    longi = map[longi];
  }


}