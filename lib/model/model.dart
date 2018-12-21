/*class TimeOff{

  String timeoffdate;
  String starttime;
  String endtime;
  String reason;
  String empid;
  String orgid;

 TimeOff(this.timeoffdate,this.starttime,this.endtime,this.reason,this.empid, this.orgid);

  TimeOff.fromMap(Map map) {
    timeoffdate = map[timeoffdate];
    starttime = map[starttime];
    endtime = map[endtime];
    reason = map[reason];
    empid = map[empid];
    orgid = map[orgid];
  }

}*/

class TimeOff {
  String EmpId;
  String OrgId;
  String TimeOffId;
  String TimeofDate;
  String TimeFrom;
  String TimeTo;
  String hrs;
  String Reason;
  String ApprovalSts;
  String ApproverComment;
  bool withdrawlsts;
  TimeOff({this.TimeofDate,this.TimeFrom,this.TimeTo,this.hrs,this.Reason,this.ApprovalSts,this.ApproverComment,this.withdrawlsts, this.TimeOffId, this.EmpId, this.OrgId});
}

class Profile{
  String uid;
  String orgid;
  String mobile;
  String countryid;

  Profile(this.uid,this.orgid,this.mobile,this.countryid);
}

class Leave{
  String uid, leavefrom, leaveto, orgid, reason, leavetypeid, leavetypefrom, leavetypeto, halfdayfromtype, halfdaytotype, leavedays, approverstatus, comment, attendancedate, leaveid;
  bool withdrawlsts;
  Leave({this.uid, this.leavefrom, this.leaveto, this.orgid, this.reason, this.leavetypeid, this.leavetypefrom, this.leavetypeto, this.halfdayfromtype, this.halfdaytotype, this.leavedays, this.approverstatus, this.comment, this.attendancedate, this.leaveid, this.withdrawlsts});
}