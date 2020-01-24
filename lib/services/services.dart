import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:multi_shift/globals.dart' as globals;
import 'package:multi_shift/model/model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:multi_shift/globals.dart';
import 'package:location/location.dart';

import '../today_attendance_report.dart';

class Services {}
/////////// location punch
punch(comments, client_name, empid, location_addr1, lid, act, orgdir, latit,
    longi) {
  /*
  print('Location punch successfully');
  print("\nClient: " + client_name);
  print("\nComments: " + comments);
  print("\nempid: " + empid);
  print("\nlocation_addr1: " + location_addr1);
  print("\nlid: " + lid);
  print("\nact: " + act);
  print("\norgdir: " + orgdir);
  print("\nlatit: " + latit);
  print("\nlongi: " + longi);
  */
}
Future checkNow() async {
  final res = await http.get(globals.path+'getAppVersion?platform=Android');
  return ((json.decode(res.body.toString()))[0]['version']).toString();
}
Future<String> PunchSkip(lid) async {
  // print('push skip called');
  Map MarkPunchMap = {'status': 'failure'};
  try {
    Dio dio = new Dio();
    FormData formData = new FormData.from({
      "lid": lid,
    });
    Response<String> response1 =
    await dio.post(globals.path + "skipPunch", data: formData);
    MarkPunchMap = json.decode(response1.data);
    //  print('STATUS-1:' + MarkPunchMap['status'].toString());
    if (MarkPunchMap['status'].toString() == 'success') setPunchPrefs('0');
    return MarkPunchMap['status'].toString();
  } catch (e) {
    //  print("Unable to set visit: " + e.toString());
    return MarkPunchMap['status'].toString();
  }
}

Future<Map> PunchInOut(comments, client_name, empid, location_addr1, lid, act,
    orgdir, latit, longi) async {
/*  print("Punch in/out called");
  print('Location punch successfully');
  print("\nClient: "+client_name);
  print("\nComments: "+comments);
  print("\nempid: "+empid);
  print("\nlocation_addr1: "+location_addr1);
  print("\nlid: "+lid);
  print("\nact: "+act);
  print("\norgdir: "+orgdir);
  print("\nlatit: "+latit);
  print("\nlongi: "+longi);*/
  Map MarkPunchMap;
  try {
    Dio dio = new Dio();
    FormData formData = new FormData.from({
      "comment": comments,
      "cname": client_name,
      "uid": empid,
      "orgid": orgdir,
      "loc": location_addr1,
      "longi": longi,
      "latit": latit,
      "act": act,
      "lid": lid,
    });

    Response<String> response1 =
    await dio.post(globals.path + "punchLocation", data: formData);

    print(response1.toString());
    MarkPunchMap = json.decode(response1.data);
//    PunchLocation pnch=new PunchLocation();

    if (MarkPunchMap["status"].toString() == 'success') {
      /* print('------response done----------' +
          MarkPunchMap["status"].toString() +
          " shared data: ");*/
      setPunchPrefs(MarkPunchMap["lid"].toString());
      return MarkPunchMap;
    } else
      /* print('------response failer----------' +
          MarkPunchMap["status"].toString());*/
      return MarkPunchMap;
  } catch (e) {
    // print("Unable to set visit: " + e.toString());
    MarkPunchMap = {'status': 'failure', 'lid': lid};
    return MarkPunchMap;
  }
}

///////// check punch in or punch out--- depricated (NOT IN USE)
checkPunch(String empid, String orgid) async {
  var dio = new Dio();
  final prefs = await SharedPreferences.getInstance();
  return "PunchIn";
}

Future<Map> registerEmp(name,email,pass,phone) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '0';
  final response = await http.get(globals.path+"registerEmp?f_name= $name&username=$email&password=$pass"
      "&contact=$phone&org_id=$orgdir");
  /*print('globals.path+"registerEmp?f_name= $name&username=$email&password=$pass'
      '&contact=$phone&org_id=$orgdir');*/
  var res=json.decode(response.body.toString());
  print(res['id']);
  Map<String,String> data={'id':res['id'].toString(),'sts':res['sts'].toString()};

  print('---------------------------------');
  print(data);
  print('---------------------------------');
  return data;
}
Future<String> checkAdminSts() async{
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '0';
  String empid = prefs.getString('empid') ?? '0';
  final response = await http.get(globals.path+"getSuperviserSts?uid=$empid&refid=$orgdir");
  var res=json.decode(response.body.toString());
  print('------------checkAdminSts called-123------');
  print(res[0]['appSuperviserSts']);
  prefs.setString('sstatus', res[0]['appSuperviserSts'].toString());
  employee_permission=int.parse(res[0]['appSuperviserSts']);
  return res[0]['appSuperviserSts'].toString();

}
setPunchPrefs(lid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('lid', lid);
  /* print('Preferences set successfully: new lid- ' +
      prefs.getString('lid').toString());*/
}

navigateToPageAfterNotificationClicked(var pageString, BuildContext context){

  if(pageString=='reports'){
    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => TodayAttendance(),maintainState: false));
  }

}

////////////////////////////////////////////////-----
Future<List<Punch>> getSummaryPunch() async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  print('getSummaryPunch called');
  final response =
  await http.get(globals.path + 'getPunchInfo?uid=$empid&orgid=$orgdir');

  List responseJson = json.decode(response.body.toString());
  print("get summary punch"+responseJson.toString());
  List<Punch> userList = createUserList(responseJson);
  return userList;
}

List<Punch> createUserList(List data) {
  List<Punch> list = new List();
  for (int i = data.length-1; i >=0; i--) {
    String id = data[i]["Id"];
    String client = data[i]["client"];
    String pi_time = data[i]["time_in"]=="00:00:00"?'-':data[i]["time_in"].toString().substring(0,5);
    String pi_loc = data[i]["loc_in"];
    String po_time = data[i]["time_out"]=="00:00:00"?'-':data[i]["time_out"].toString().substring(0,5);
    String po_loc = data[i]["loc_out"];
    String emp = data[i]["emp"];
    String latit_in = data[i]["latit"];
    String longi_in = data[i]["longi"];
    String latit_out = data[i]["latit_in"];
    String longi_out = data[i]["longi_out"];
    String desc = data[i]["desc"];
    String pi_img=data[i]["checkin_img"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["checkin_img"].toString();
    String po_img=data[i]["checkout_img"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["checkout_img"].toString();
    //print(data[i]["loc_out"]);
    Punch punches = new Punch(
        Id:id,
        Emp:emp,
        client: client,
        pi_time: pi_time,
        pi_loc: pi_loc.length>40?pi_loc.substring(0,40)+'...':pi_loc,
        po_time: po_time=='00:00'?'-':po_time,
        po_loc: po_loc.length>40?po_loc.substring(0,40)+'...':po_loc,
        pi_latit:latit_in,
        pi_longi:longi_in,
        po_latit:latit_out,
        po_longi:longi_out,
        desc:desc.length>40?desc.substring(0,40)+'...':desc,
        pi_img: pi_img,
        po_img: po_img
    );
    list.add(punches);
  }
  return list;
}

class Punch {
  String Id;
  String Emp;
  String client;
  String pi_time;
  String pi_loc;
  String po_time;
  String po_loc;
  String pi_longi;
  String pi_latit;
  String po_longi;
  String po_latit;
  String desc;
  String pi_img;
  String po_img;

  Punch({this.Id,this.Emp,this.client,this.pi_time,this.pi_loc,this.po_time,this.po_loc,this.pi_latit,this.pi_longi,this.po_latit,this.po_longi,this.desc,this.pi_img,this.po_img});
}

////////////////////////////////////////////////-----
///
/// ///////////////////common function
///
String FormatDay(String day){
  var dy = [
    'st',
    'nd',
    'rd',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'st',
    'nd',
    'rd',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'st'
  ];
  day=day+"" +dy[int.parse(day) - 1].toString();
  return day;
}
String Formatdate(String date_) {
  // String date_='2018-09-2';
  var months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  var dy = [
    'st',
    'nd',
    'rd',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'st',
    'nd',
    'rd',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'th',
    'st'
  ];
  var date = date_.split("-");
  return (date[2] +
      "" +
      dy[int.parse(date[2]) - 1] +
      " " +
      months[int.parse(date[1]) - 1]);
}
goToMap(String lat, String long) async{
  if((lat.toString()).startsWith('0',0) || (long.toString()).startsWith('0',0) )
    return false;
  String url = "https://maps.google.com/?q="+lat+","+long;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    //print( 'Could not launch $url');
  }
}
/////////////////////
Future<List<Map>> getDepartmentsList(int label) async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(globals.path + 'DepartmentMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  List<Map> depts = createList(data,label);
  return depts;
}
List<Map> createList(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-"});
  else
    list.add({"Id":"0","Name":"-Select-"});
  for (int i = 0; i < data.length; i++) {
    if(data[i]["archive"].toString()=='1') {
      Map tos={"Name":data[i]["Name"].toString(),"Id":data[i]["Id"].toString()};
      list.add(tos);
    }
  }
  return list;
}
Future<List<Map>> getDesignationsList(int label) async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(globals.path + 'DesignationMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  List<Map> depts = createList(data,label);
  return depts;
}
Future<List<Map>> getShiftsList() async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(globals.path + 'shiftMaster?orgid=$orgid');
  List data = json.decode(response.body.toString());
  List<Map> depts = createList(data,0);
  return depts;
}
bool validateMobile(String value) {
// Indian Mobile number are of 10 digit only
  if (value.length <6)
    return false;
  else
    return true;
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}
/// ///////////////////common function/
///
/// -////////////////////////////////////////////
Future<List<Map<String,String>>> getEmployeesWithIdName() async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(globals.path + 'getEmployeesList?refno=$orgid');
  List data = json.decode(response.body.toString());
  List<Map<String,String>> newList = createGetEmployeesWithIdName(data);
  print(newList);
  return newList;
}
List<Map<String,String>> createGetEmployeesWithIdName(List data){
  List<Map<String,String>> newList=List<Map<String,String>>();
  for (int i = 0; i < data.length; i++) {
    Map<String,String> emp=new Map<String,String>();
    String code='';
    if(data[i]["ecode"].toString()!='' && data[i]["ecode"].toString()!='null')
      code=' ['+data[i]["ecode"].toString()+']';
    if(data[i]["name"].toString()!='' && data[i]["name"].toString()!=null)
      emp={"display":data[i]["name"].toString()+code,"value":data[i]["Id"].toString()};
    newList.add(emp);
  }
  return newList;
}
Future<int> saveShiftAllocation(date,shift,employees) async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  String empid = prefs.getString('empid') ?? '';
  print(date+' '+shift);
  String empList='';
  for(int i=0;i<employees.length;i++){
    empList+=employees[i].toString()+',';
  }
  // print(globals.path + 'saveShiftAllocation?refno=$orgid&empid=$empid&date=$date&shift=$shift&empList=$empList');
  final response = await http.get(globals.path + 'saveShiftAllocation?refno=$orgid&empid=$empid&date=$date&shift=$shift&empList=$empList');

// print('response recieved: '+response.body.toString());
  return int.parse(response.body);
}
////////////////////////////////////////////////////////////////
/// ///////////////////////////////--generate employees list for DD
Future<List<Map>> getEmployeesList(int label) async{
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(globals.path + 'getEmployeesList?refno=$orgid');
  List data = json.decode(response.body.toString());
  List<Map> depts = createEMpListDD(data,label);
  print(depts);
  return depts;
}
List<Map> createEMpListDD(List data,int label) {
  List<Map> list = new List();
  if(label==1) // with -All- label
    list.add({"Id":"0","Name":"-All-","Code":""});
  else
    list.add({"Id":"0","Name":"-Select-","Code":""});
  for (int i = 0; i < data.length; i++) {
    Map tos;
    if(data[i]["name"].toString()!='' && data[i]["name"].toString()!=null)
      tos={"Name":data[i]["name"].toString(),"Id":data[i]["Id"].toString(),"Code":data[i]["ecode"].toString()};
    list.add(tos);
  }
  return list;
}
Future<List<Attn>> getEmpHistoryOf30(listType,emp) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  print( globals.path + 'getEmpHistoryOf30?refno=$orgdir&datafor=$listType&emp=$emp');
  final response = await http.get(
      globals.path + 'getEmpHistoryOf30?refno=$orgdir&datafor=$listType&emp=$emp');
  // print('================='+dept+'===================');
  final res = json.decode(response.body);
  // print('*************response**************');
//  print(res);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings') responseJson = res['earlyLeavings'];

  List<Attn> userList = createListEmpHistoryOf30(responseJson);

  return userList;
}
List<Attn> createListEmpHistoryOf30(List data) {
  List<Attn> list = new List();
  for (int i = 0; i < data.length; i++) {
    String EmployeeId=data[i]["EmployeeId"].toString();
    String Name=data[i]["name"].toString();

    String AttendanceDate = data[i]["AttendanceDate"].toString(); // tepm given 'name' to attn date
    String TimeIn = data[i]["TimeIn"].toString();
    String TimeOut = data[i]["TimeOut"].toString() == '00:00'
        ? '-'
        : data[i]["TimeOut"].toString();
    String EntryImage = data[i]["EntryImage"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["EntryImage"].toString();
    String ExitImage = data[i]["ExitImage"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["ExitImage"].toString();
    String CheckInLoc = data[i]["checkInLoc"].toString();
    String CheckOutLoc = data[i]["CheckOutLoc"].toString();
    String LatitIn = data[i]["latit_in"].toString();
    String LatitOut = data[i]["latit_out"].toString();
    String LongiIn = data[i]["longi_in"].toString();
    String LongiOut = data[i]["longi_out"].toString();

    Attn tos = new Attn(
        EmployeeId:EmployeeId,
        Name: Name,
        TimeIn: TimeIn,
        TimeOut: TimeOut,
        EntryImage: EntryImage,
        ExitImage: ExitImage,
        CheckInLoc: CheckInLoc,
        CheckOutLoc: CheckOutLoc,
        LatitIn: LatitIn,
        LatitOut: LatitOut,
        LongiIn: LongiIn,
        LongiOut: LongiOut,
        Date:AttendanceDate);


    list.add(tos);
  }
  return list;
}
/// ///////////////////////////////--generate employees list for DD/
/// ////////////////////////////////////////////////-----
Future<List<TimeOff>> getTimeOffSummary() async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  final response = await http.get(globals.path + 'fetchTimeOffList?uid=$empid');
  // print(response.body);
//  print('--------------------getTimeOffList Called-----------------------');
  List responseJson = json.decode(response.body.toString());
  List<TimeOff> userList = createTimeOffList(responseJson);
  return userList;
}

List<TimeOff> createTimeOffList(List data) {
  List<TimeOff> list = new List();
  for (int i = 0; i < data.length; i++) {
    String TimeofDate = data[i]["date"];
    String TimeFrom = data[i]["from"];
    String TimeTo = data[i]["to"];
    String hrs = data[i]["hrs"];
    String Reason = data[i]["reason"];
    String ApprovalSts = data[i]["status"];
    String ApproverComment = data[i]["comment"];
    bool withdrawlsts = data[i]["withdrawlsts"];
    String TimeOffId = data[i]["timeoffid"];
    TimeOff tos = new TimeOff(
        TimeofDate: TimeofDate,
        TimeFrom: TimeFrom,
        TimeTo: TimeTo,
        hrs: hrs,
        Reason: Reason,
        ApprovalSts: ApprovalSts,
        ApproverComment: ApproverComment,
        withdrawlsts: withdrawlsts,
        TimeOffId: TimeOffId);
    list.add(tos);
  }
  return list;
}
////////////////////////////////////////////////-----

Future<bool> getOrgPerm(perm) async {
  final prefs = await SharedPreferences.getInstance();
  String org_perm = prefs.getString('org_perm') ?? '';
  List<String> permissions = org_perm.split(',');
  // for (var x = 0; x < permissions.length; x++)
  // print(permissions.contains(perm.toString()));
  //print("check perm: "+perm.toString());
  return permissions
      .contains(perm.toString()); // return true if permission found in list set
}

//********************************************************************************************//

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////DEPARTMENT CODE START////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//********************************************************************************************//
Future<List<Dept>> getDepartments() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
//  print('getDept called');
  final response =
  await http.get(globals.path + 'DepartmentMaster?orgid=$orgid');
  // print(response.body);
  List responseJson = json.decode(response.body.toString());
  List<Dept> deptList = createDeptList(responseJson);
  return deptList;
}

List<Dept> createDeptList(List data) {
  List<Dept> list = new List();
  for (int i = 0; i < data.length; i++) {
    String dept = data[i]["Name"];
    String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
    String id = data[i]["Id"];
    Dept dpt = new Dept(dept: dept, status: status, id: id);
    list.add(dpt);
  }
  return list;
}

class Dept {
  String dept;
  String status;
  String id;

  Dept({this.dept, this.status, this.id});
}

Future<String> addDept(name, status) async {
  //print('RECIEVED STATUS: '+status.toString());
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  status = status.toString() == 'Active' ? '1' : '0';
  final response = await http.get(globals.path +'addDept?uid=$empid&orgid=$orgdir,&name=$name&sts=$status');

  print(response.body.toString());
  print('Add dept response----------=='+response.body.toString());
  print(response.body.toString());
  return response.body.toString();
}

Future<String> updateDept(dept, sts, did) async {
  //print('RECIEVED STATUS: '+status.toString());
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  sts = sts.toString() == 'Active' ? '1' : '0';
  final response = await http
      .get(globals.path + 'updateDept?uid=$empid,&dept=$dept&sts=$sts&id=$did');
  return response.body.toString();
}
//********************************************************************************************//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////DEPARTMENT CODE End////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////DESIGNATION CODE START////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

Future<List<Desg>> getDesignation() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  // print('getDesg called');
  final response =
  await http.get(globals.path + 'DesignationMaster?orgid=$orgid');
  // print(response.body);
  List responseJson = json.decode(response.body.toString());
  List<Desg> desgList = createDesgList(responseJson);
  return desgList;
}

List<Desg> createDesgList(List data) {
  List<Desg> list = new List();
  for (int i = 0; i < data.length; i++) {
    String desg = data[i]["Name"];
    String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
    String id = data[i]["Id"];
    Desg dpt = new Desg(desg: desg, status: status, id: id);
    list.add(dpt);
  }
  return list;
}

class Desg {
  String desg;
  String status;
  String id;
  List modulepermissions;

  Desg({this.desg, this.status, this.id, this.modulepermissions});
}

Future<String> addDesg(name, status) async {
  //print('RECIEVED STATUS: '+status.toString());
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  status = status.toString() == 'Active' ? '1' : '0';
  final response = await http.get(globals.path +
      'addDesg?uid=$empid&orgid=$orgdir,&name=$name&sts=$status');
  return response.body.toString();
}

Future<String> updateDesg(desg, sts, did) async {
  //print('RECIEVED STATUS: '+status.toString());
  print(desg+"   "+sts+"   "+did);
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  sts = sts.toString() == 'Active' ? '1' : '0';
  final response = await http
      .get(globals.path + 'updateDesg?uid=$empid,&desg=$desg&sts=$sts&id=$did');
  print(response.body.toString());
  return response.body.toString();
}


//********************************************************************************************//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////DESIGNATION CODE End////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////Employee CODE START////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

Future<List<Emp>> getEmployee() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
//  print('getEmp called');
  final response = await http.get(globals.path + 'getUsersMobile?refno=$orgid');
//  print(response.body);
//  print('fun end here1');
  List responseJson = json.decode(response.body.toString());
  // print('fun end here2');
  List<Emp> empList = createEmpList(responseJson);
  // print('fun end here3');
//  print(empList);
  return empList;
}

List<Emp> createEmpList(List data) {
  // print('Create list called');
  List<Emp> list = new List();
  for (int i = 0; i < data.length; i++) {
    String name = data[i]["name"];
    String dept = data[i]["Department"];
    String desg = data[i]["Designation"];
    String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
    String id = data[i]["Id"];
    //  print(name+'**'+dept+'**'+desg);
    Emp emp = new Emp(
        Name: name,
        Department: dept,
        Designation: desg,
        Status: status,
        Id: id);
    list.add(emp);
  }
  return list;
}

class Emp {
  String Name;
  String Department;
  String Designation;
  String Status;
  String Id;

  Emp({this.Name, this.Department, this.Designation, this.Status, this.Id});
}

Future<int> addEmployee(
    fname, lname, email, countryCode, countryId, contact, password,dept,desg,shift) async {
  //print('RECIEVED STATUS: '+status.toString());
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
//  print('addEmp function called, parameters :');
/*  print(fname +
      '--' +
      lname +
      '--' +
      email +
      '--' +
      countryCode +
      '--' +
      countryId +
      '--' +
      contact +
      '--' +
      password);*/
//  print(globals.path+'registerEmp?uid=$empid&org_id=$orgdir,&f_name=$fname,&l_name=$lname,&password=$password,&username=$email,&contact=$contact,&country=$countryId,&countrycode=$countryCode,&admin=1');
  final response = await http.get(globals.path +
      'registerEmp?uid=$empid&org_id=$orgdir&f_name=$fname&l_name=$lname&password=$password&username=$email&contact=$contact&country=$countryId&countrycode=$countryCode&admin=1&designation=$desg&department=$dept&shift=$shift');
  var res = json.decode(response.body);
  print("--------> Adding employee"+res.toString());
  return res['sts'];
}
//********************************************************************************************//
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////Employee CODE End////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

// //////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////SHIFT HANDELING START////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//********************************************************************************************//

Future<List<Shift>> getShifts() async {
  // print('shifts called');
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  // print(globals.path + 'shiftMaster?orgid=10');
  final response = await http.get(globals.path + 'shiftMaster?orgid=$orgid');
  List responseJson = json.decode(response.body.toString());
  List<Shift> shiftList = createShiftList(responseJson);
//  print(shiftList);
  return shiftList;
}

List<Shift> createShiftList(List data) {
  List<Shift> list = new List();
  for (int i = 0; i < data.length; i++) {
    String name = data[i]["Name"];
    String timein = data[i]["TimeIn"];
    String timeout = data[i]["TimeOut"];
    String id = data[i]["Id"];
    String status = data[i]["archive"] == '0' ? 'Inactive' : 'Active';
    String type =
    data[i]["shifttype"] == '1' ? 'One Day Shift' : 'Two Day Shift';

    Shift shift = new Shift(
        Id: id,
        Name: name,
        TimeIn: timein,
        TimeOut: timeout,
        Status: status,
        Type: type);
    list.add(shift);
  }
  return list;
}

class Shift {
  String Id;
  String Name;
  String TimeIn;
  String TimeOut;
  String Status;
  String Type;

  Shift(
      {this.Id, this.Name, this.TimeIn, this.TimeOut, this.Status, this.Type});
}

Future<int> createShift(name, type, from, to, from_b, to_b) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(globals.path +
      'addShift?name=$name&org_id=$orgdir&ti=$from&to=$to&tib=$from_b&tob=$to_b&sts=1&shifttype=$type');
  int res = int.parse(response.body);
  return res;
}

Future<String> updateShift(shift, sts, did) async {
  //print('RECIEVED STATUS: '+status.toString());
  print(shift+"   "+sts+"   "+did);
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  sts = sts.toString() == 'Active' ? '1' : '0';
  final response = await http
      .get(globals.path + 'updateShift?uid=$empid,&shift=$shift&sts=$sts&id=$did');
  print(response.body.toString());
  return response.body.toString();
}

//********************************************************************************************//
// //////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////SHIFT HANDELING End////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////RESET/Forgot PASSWORD START////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//********************************************************************************************//
Future<int> changeMyPassword(oldPass, newPass) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  //  print(oldPass+'--'+newPass);
  final response = await http.get(globals.path +
      'changePassword?uid=$empid&refno=$orgdir&pwd=$oldPass&npwd=$newPass');
  if(int.parse(response.body)==1){
    prefs.setString('usrpwd', newPass);
  }
  return int.parse(response.body);
}

Future<int> resetMyPassword(username) async {
  print('Forgot password rew sbmit'+ username);
  final response = await http.get(globals.path +
      'resetPasswordLink?una=$username');
  print("response for forgot pass::::"+response.body.toString());
  return int.parse(response.body);
}//'https://ubiattendance.ubihrm.com/index.php/services/resetPasswordLink?una='+una+'&refno='+refno,
//********************************************************************************************//
// ////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////RESET/FORGOT PASSWORD END////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

Future<List<Attn>> getAttnDetail(listType,empId,aDate) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(
      globals.path + 'getAttendances_details?refno=$orgdir&datafor=$listType&empId=$empId&aDate=$aDate');
  final res = json.decode(response.body);
  // print(res);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings') responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}
// ////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////REPORTS SERVICES STARTS////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//********************************************************************************************//
Future<List<Attn>> getTodaysAttn(listType) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(
      globals.path + 'getAttendances_new?refno=$orgdir&datafor=$listType');
  final res = json.decode(response.body);
  // print(res);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings') responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}

List<Attn> createTodayEmpList(List data) {
  // print('Create list called/*******************');
  List<Attn> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Name = data[i]["name"].toString();
    String TimeIn = data[i]["TimeIn"].toString();
    String TimeOut = data[i]["TimeOut"].toString() == '00:00'
        ? '-'
        : data[i]["TimeOut"].toString();
    String EntryImage = data[i]["EntryImage"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["EntryImage"].toString();
    String ExitImage = data[i]["ExitImage"].toString() == ''
        ? 'http://ubiattendance.ubihrm.com/assets/img/avatar.png'
        : data[i]["ExitImage"].toString();
    String CheckInLoc = data[i]["checkInLoc"].toString();
    String CheckOutLoc = data[i]["CheckOutLoc"].toString();
    String LatitIn = data[i]["latit_in"].toString();
    String LatitOut = data[i]["latit_out"].toString();
    String LongiIn = data[i]["longi_in"].toString();
    String LongiOut = data[i]["longi_out"].toString();
    String date=data[i]["AttendanceDate"].toString();
    String EmployeeId=data[i]["EmployeeId"].toString();
    Attn tos = new Attn(
        Name: Name,
        TimeIn: TimeIn,
        TimeOut: TimeOut,
        EntryImage: EntryImage,
        ExitImage: ExitImage,
        CheckInLoc: CheckInLoc,
        CheckOutLoc: CheckOutLoc,
        LatitIn: LatitIn,
        LatitOut: LatitOut,
        LongiIn: LongiIn,
        LongiOut: LongiOut,
        EmployeeId: EmployeeId,
        Date:date);
    list.add(tos);
  }
  return list;
}

class Attn {
  String Name;
  String TimeIn;
  String TimeOut;
  String EntryImage;
  String ExitImage;
  String CheckInLoc;
  String CheckOutLoc;
  String LatitIn;
  String LatitOut;
  String LongiIn;
  String LongiOut;
  String EmployeeId;
  String Date;

  Attn(
      {this.Name,
        this.TimeIn,
        this.TimeOut,
        this.EntryImage,
        this.ExitImage,
        this.CheckInLoc,
        this.CheckOutLoc,
        this.LatitIn,
        this.LatitOut,
        this.LongiIn,
        this.LongiOut,
        this.EmployeeId,
        this.Date});
}

//******************Cdate Attn List Data
Future<List<Attn>> getCDateAttn(listType, date) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(
      globals.path + 'getCDateAttendances_new?refno=$orgdir&date=$date&datafor=$listType');
  final res = json.decode(response.body);
  // print(res);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings') responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}


//******************Cdate Attn List Data

//******************Cdate Attn DepartmentWise
Future<List<Attn>> getCDateAttnDeptWise(listType, date,dept) async {

  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  print( globals.path + 'getCDateAttnDeptWise_new?refno=$orgdir&date=$date&datafor=$listType&dept=$dept');
  final response = await http.get(
      globals.path + 'getCDateAttnDeptWise_new?refno=$orgdir&date=$date&datafor=$listType&dept=$dept');
  // print('================='+dept+'===================');
  final res = json.decode(response.body);
  // print('*************response**************');
  print(res);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings') responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}

//******************Cdate Attn DepartmentWise//
//******************Cdate Attn DesignationWise
Future<List<Attn>> getCDateAttnDesgWise(listType, date,desg) async {

  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
//print( globals.path + 'getCDateAttnDeptWise_new?refno=$orgdir&date=$date&datafor=$listType&dept=$dept');
  final response = await http.get(
      globals.path + 'getCDateAttnDesgWise_new?refno=$orgdir&date=$date&datafor=$listType&desg=$desg');
  // print('================='+dept+'===================');
  final res = json.decode(response.body);
  // print('*************response**************');
  print(res);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings') responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}
//******************Cdate Attn DesignationWise//

//******************yesterday Attn List Data
Future<List<Attn>> getYesAttn(listType) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(
      globals.path + 'getAttendances_yes?refno=$orgdir&datafor=$listType');
  final res = json.decode(response.body);
  // print(res);
  List responseJson;
  if (listType == 'present')
    responseJson = res['present'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings') responseJson = res['earlyLeavings'];
  List<Attn> userList = createTodayEmpList(responseJson);
  return userList;
}
//******************yesterday Attn List Data

// getData list for last 7/30 days- start
Future<List<Attn>> getAttnDataLast(days, listType) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  //print(globals.path + 'getAttnDataLast?refno=$orgdir&datafor=$listType&limit=$days');
  print("days");
  print(days);
  final response = await http.get(
      globals.path + 'getAttnDataLast?refno=$orgdir&datafor=$listType&limit=$days');
  final res = json.decode(response.body);
  print("response");
  print(res);
  List responseJson;
  responseJson = res['elist'];
  /* if (listType == 'present')
    responseJson = res['elist'];
  else if (listType == 'absent')
    responseJson = res['absent'];
  else if (listType == 'latecomings')
    responseJson = res['lateComings'];
  else if (listType == 'earlyleavings')
    responseJson = res['earlyLeavings'];*/
  print(responseJson);
  List<Attn> userList = createLastEmpList(responseJson);
  return userList;
}

// getData list for last 7/30 days- close
List<Attn> createLastEmpList(List data) {
  data = data.reversed.toList();
  List<Attn> list = new List();

  for (int i = 0; i < data.length; i++) {
    //  print('Create list called*******************');
    // print(data[i][0]['name']);
    String Name = '';
    String TimeIn = '';
    String TimeOut = '';
    String date = '';
    String ExitImage = '';
    String CheckInLoc = '';
    String CheckOutLoc = '';
    String LatitIn = '';
    String LatitOut = '';
    String LongiIn = '';
    String LongiOut = '';
    if (data[i].length != 0) {
      for (int j = 0; j < data[i].length; j++) {
        Name = data[i][j]["name"].toString();
        TimeIn = data[i][j]["TimeIn"].toString() == '00:00:00'||data[i][j]["TimeIn"].toString() == '-'
            ? '-'
            : data[i][j]["TimeIn"].toString().substring(0, 5);
        TimeOut = data[i][j]["TimeOut"].toString() == '00:00:00' ||data[i][j]["TimeOut"].toString() == '-'
            ? '-'
            : data[i][j]["TimeOut"].toString().substring(0, 5);
        date = Formatdate(data[i][j]["AttendanceDate"].toString());
        ExitImage = '';
        CheckInLoc = '';
        CheckOutLoc = '';
        LatitIn = '';
        LatitOut = '';
        LongiIn = '';
        LongiOut = '';


        Attn tos = new Attn(
            Name: Name,
            TimeIn: TimeIn,
            TimeOut: TimeOut,
            EntryImage: date,
            ExitImage: ExitImage,
            CheckInLoc: CheckInLoc,
            CheckOutLoc: CheckOutLoc,
            LatitIn: LatitIn,
            LatitOut: LatitOut,
            LongiIn: LongiIn,
            LongiOut: LongiOut,
            EmployeeId: '',
            Date: '');
        list.add(tos);
      }
    }
  }
  return list;
}

//********************************************************************************************//
// ////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////REPORTS SERVICES ENDS///////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////Get chart data start///////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//********************************************************************************************//
Future<List<Map<String, String>>> getChartDataToday() async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  //print(globals.path + 'getChartDataToday?refno=$orgdir');
  final response = await http.get(
      globals.path + 'getChartDataToday?refno=$orgdir');
  final data = json.decode(response.body);
  List<Map<String, String>> val = [
    {
      "present": data['present'].toString(),
      "absent": data['absent'].toString(),
      "late": data['late'].toString(),
      "early": data['early'].toString()
    }
  ];
  //print('==========');
  //print(val);
  return val;
}

Future<List<Map<String, String>>> getChartDataYes() async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(
      globals.path + 'getChartDataYes?refno=$orgdir');
  final data = json.decode(response.body);
  List<Map<String, String>> val = [
    {
      "present": data['present'].toString(),
      "absent": data['absent'].toString(),
      "late": data['late'].toString(),
      "early": data['early'].toString()
    }
  ];
  // print('==========');
  // print(val);
  return val;
}

Future<List<Map<String, String>>> getChartDataCDate(date) async {
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  final response = await http.get(
      globals.path + 'getChartDataCDate?refno=$orgdir&date=$date');
  final data = json.decode(response.body);
  //print(response);
  List<Map<String, String>> val = [
    {
      "present": data['present'].toString(),
      "absent": data['absent'].toString(),
      "late": data['late'].toString(),
      "early": data['early'].toString()
    }
  ];
  print('==========++++++++++');
  print(val);
  return val;
}

Future<List<Map<String, String>>> getChartDataLast(dys) async {
  // dys: no. of days
  final prefs = await SharedPreferences.getInstance();
  String orgdir = prefs.getString('orgdir') ?? '';
  List<Map<String, String>> val = [];
  if (dys.toString() == 'l7') {
    final response = await http
        .get(globals.path + 'getChartDataLast_7?refno=$orgdir&limit=$dys');
    final data = json.decode(response.body);
    for (int i = 0; i < data.length; i++)
      val.add({
        "date": data[i]['event'].toString(),
        "total": data[i]['total'].toString()
      });
  } else if (dys.toString() == 'l30') {
    final response = await http
        .get(globals.path + 'getChartDataLast_30?refno=$orgdir&limit=$dys');
    final data = json.decode(response.body);
    for (int i = 0; i < data.length; i++)
      val.add({
        "date": data[i]['event'].toString(),
        "total": data[i]['total'].toString()
      });
  }
  return val;
}
//********************************************************************************************//
// ////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////Get chart data ends///////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////Get late/early/timeoff emp reports///////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//********************************************************************************************//
Future<List<EmpList>> getLateEmpDataList(date) async {
  if (date == '' || date == null) return null;
  // print('shifts called');
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(
      globals.path + 'getlateComings?refno=$orgid&cdate=$date');
  List responseJson = json.decode(response.body.toString());
  List<EmpList> list = createListLateComings(responseJson);
  //print(list);
  return list;
}

List<EmpList> createListLateComings(List data) {
  List<EmpList> list = new List();
  for (int i = 0; i < data.length; i++) {
    String diff = data[i]["lateby"];
    String timeAct = data[i]["timein"];
    String name = data[i]["name"];
    String shift = data[i]["shift"];
    String date = data[i]["date"];
    EmpList row = new EmpList(
        diff: diff, timeAct: timeAct, name: name, shift: shift, date: date);
    list.add(row);
  }
  return list;
}

class EmpList {
  String diff;
  String timeAct; // timein or timeout
  String name;
  String shift;
  String date;

  EmpList({this.diff, this.timeAct, this.name, this.shift, this.date});
}

////*********************************************************************
Future<List<EmpList>> getEarlyEmpDataList(date) async {
  if (date == '' || date == null) return null;
  // print('shifts called');
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(
      globals.path + 'getEarlyLeavings?refno=$orgid&cdate=$date');
  print("date");
  print(date);
  List responseJson = json.decode(response.body.toString());
  List<EmpList> list = createListEarlyLeaving(responseJson);
  // print(list);
  return list;
}

List<EmpList> createListEarlyLeaving(List data) {
  List<EmpList> list = new List();
  for (int i = 0; i < data.length; i++) {
    String diff = data[i]["earlyby"];
    String timeAct = data[i]["timeout"];
    String name = data[i]["name"];
    String shift = data[i]["shift"];
    String date = data[i]["date"];
    EmpList row = new EmpList(
        diff: diff, timeAct: timeAct, name: name, shift: shift, date: date);
    list.add(row);
  }
  return list;
}

//*******************************************************
Future<List<EmpListTimeOff>> getTimeOFfDataList(date) async {
  if (date == '' || date == null) return null;
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(globals.path + 'getTimeoffList?fd=$date&to=$date&refno=$orgid');

  List responseJson = json.decode(response.body.toString());
  print(responseJson.toString());
  List<EmpListTimeOff> list = createTimeOFfDataList(responseJson);
//  print(list);
  return list;
}

List<EmpListTimeOff> createTimeOFfDataList(List data) {
  List<EmpListTimeOff> list = new List();
  for (int i = 0; i < data.length; i++) {
    String diff = data[i]["diff"];
    String to = data[i]["TimeTo"];
    String from = data[i]["TimeFrom"];
    String name = data[i]["name"];
    String date = data[i]["tod"];
    String ApprovalSts = data[i]["ApprovalSts"];
    EmpListTimeOff row = new EmpListTimeOff(
        diff: diff, to: to, from: from, name: name, date: date, ApprovalSts: ApprovalSts);
    list.add(row);
  }
  return list;
}

class EmpListTimeOff {
  String diff;
  String to;
  String from;
  String name;
  String date;
  String ApprovalSts;

  EmpListTimeOff({this.diff, this.to, this.from, this.name, this.date, this.ApprovalSts});
}
//********************************************************************************************//
// ////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/////////////////////////Get late/early emp reports/timeoff close///////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////
////////////////////////////Punch location/visits  reports start////////////////////////
///////////////////////////////////////////////////////////////////////

Future<List<Punch>> getVisitsDataList(date, emp) async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
  // print(globals.path + 'getPunchInfo?orgid=$orgdir&date=$date');
  final response =
  await http.get(globals.path + 'getPunchInfo?orgid=$orgdir&date=$date&uid=$emp');
  List responseJson = json.decode(response.body.toString());
  List<Punch> userList = createUserList(responseJson);
  // print('getSummaryPunch called--1');
//  print(userList);
  // print('getSummaryPunch called--2');
  return userList;
}

// ///////////////////////////////////////////////////////////////////
////////////////////////////Punch location/visits  reports ends////////////////////////
///////////////////////////////////////////////////////////////////////
Future <Map> checkOrganization(crn) async{
  final response =
  await http.get(globals.path + 'checkOrganization?refid=$crn');

  var responseJson = json.decode(response.body.toString());
  Map<String,String> res ;
  if(responseJson['sts'].toString()=='1')
    res={'sts':responseJson['sts'].toString(),'Id':responseJson['result'][0]['Id'].toString(),'Name':responseJson['result'][0]['Name'].toString()};
  else
    res={'sts':responseJson['sts'].toString()};
  return res;
}

Future<List> getAttentancees() async {

  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  final response = await http.get(globals.path + 'getAttendancees?orgid=$orgid');
  List responseJson = json.decode(response.body.toString());
  print(responseJson);
  return responseJson;
  // List<Shift> shiftList = createShiftList(responseJson);

  // return shiftList;
}

MarkAttendance(data){
  print('bulk attendance mark successfully');
  print(data);
}

Future<Info> getTodayInfo(date) async{
  Info data=new Info();
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '0';
  String orgid = prefs.getString('orgdir') ?? '0';
  try {
    date=date.substring(0, 10);
    print(globals.path + 'getTodayInfo?orgid=$orgid&empid=$empid&date=$date');
    final response = await http.get(
        globals.path + 'getTodayInfo?orgid=$orgid&empid=$empid&date=$date');
    List res = json.decode(response.body.toString());
    print('-----------------');
    print(res[0]);
    print('-----------------');
    data.status = res[0]['status'];
    data.date = res[0]['date'];
    data.shiftName = res[0]['shiftName'];
    data.shiftTime = res[0]['shiftTime'];
    data.timeIn = res[0]['timeIn'];
    data.timeOut = res[0]['timeOut'];
    data.lateBy = res[0]['lateBy'];
    data.earlyBy = res[0]['earlyBy'];
    data.timeOffStart = res[0]['timeOffStart'];
    data.timeOffEnd = res[0]['timeOffEnd'];
  }catch(e){
    print('Exception occured--1: '+e.toString());
  }
  return data;
}

class Info{
  String status,date,shiftName,shiftTime,timeIn,timeOut,lateBy,earlyBy,timeOffStart,timeOffEnd;
  Info({this.date,this.shiftName,this.shiftTime,this.timeIn,this.timeOut,this.lateBy,this.earlyBy,this.timeOffStart,this.timeOffEnd,this.status});
}



// ///////////////////////////////////////////////////////////////////
////////////////////////////Bulk Attendance////////////////////////
///////////////////////////////////////////////////////////////////////

class grpattemp {
  String Name;
  String Department;
  String Designation;
  String Status;
  String Id;
  String img;
  String attsts;
  String timein;
  String timeout;
  String todate;
  String shift;
  String shifttype;
  int csts;

  grpattemp(
      {this.Name,
        this.Department,
        this.Designation,
        this.Status,
        this.csts,
        this.img,
        this.attsts,
        this.timein,
        this.timeout,
        this.todate,
        this.shift,
        this.shifttype,
        this.Id});
}

Future<List<grpattemp>> getDeptEmp() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
  //print(globals.path + 'getDeptEmp?orgid=$orgid&dept=13');
  final response =
  await http.get(globals.path + 'getDeptEmp?orgid=$orgid');

  //print(globals.path + 'getDeptEmp?orgid=$orgid&dept=15');
  List responseJson = json.decode(response.body.toString());
  print(responseJson);
  List<grpattemp> deptList = createDeptempList(responseJson);
  print(responseJson);
  if(deptList.length>0)
    return deptList;
  else
    return null;
}
Future<Map<String, dynamic>> sendPushNotification(String title,String nBody,String topic) async {

  String url='https://fcm.googleapis.com/fcm/send';
  var body = json.encode({
    'condition': topic,
    'notification': {'body': nBody,
      'title': title,
    }
  });

  print('Body: $body');

  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization':'key=AAAAon3mTHE:APA91bF2klpbwpL3--jf4cRA2wWL5_oNFWPzwNWe43wciBiy-SiBRsd2j0gafDTx8QTd5qCIC9-sMTmo6EWv7NxM3n01z5CiyvXKHYAetaDdTrHZfoSLCU78WzH96Gbyl9dP1kIKUWiI'
    },
    body: body,
  );

  // todo - handle non-200 status code, etc

  //return json.decode(response.body);
}

List<grpattemp> createDeptempList(List data) {
  List<grpattemp> list = new List();
  for (int i = 0; i < data.length; i++) {
    String name = data[i]["name"];
    // String status=data[i]["archive"]=='1'?'Active':'Inactive';
    String id = data[i]["id"];
    int csts = data[i]["csts"];
    String img = data[i]["img"];
    // String timein=data[i]["timein"];
    String timein=data[i]["timein"];
    String timeout = data[i]["timeout"];//(hour: data[i]["timeout"].split(":")[0], minute: data[i]["timeout"].split(":")[1]);
    print(timein+' and '+timeout);
    String attsts = '1';
    String todate = data[i]["todate"];
    String shift = data[i]["shift"];
    String shifttype = data[i]["shifttype"];
    grpattemp dpt =
    new grpattemp(Name: name, csts: csts, img: img, attsts: attsts, timein: timein, timeout: timeout, todate: todate, shift: shift, shifttype: shifttype, Id: id);
    list.add(dpt);
  }
  return list;
}

addBulkAtt(List <grpattemp> data) async {

  var dio = new Dio();
  String location = globals.globalstreamlocationaddr;
  LocationData _currentLocation =
  globals.list[globals.list.length - 1];
  String lat = _currentLocation.latitude.toString();
  String long = _currentLocation.longitude.toString();
  print("global Address: "+ location);
  print("global lat" + lat);
  print("global long" + long);

  List<Map> list = new List();
  print(data);
  //print(list);
  for (int i = 0; i < data.length; i++) {
    Map per = {
      "Id":data[i].Id.toString(),
      "Name":data[i].Name.toString(),
      "timein":data[i].timein,
      "timeout":data[i].timeout,
      "attsts":data[i].attsts.toString(),
      "todate":data[i].todate.toString(),
      "shift":data[i].shift.toString(),
    };

    list.add(per);
  }
  var jsonlist;
  jsonlist = json.encode(list);
  print(jsonlist);

  //print('RECIEVED STATUS: '+status.toString());
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
//  print('addEmp function called, parameters :');
  print(globals.path+'CreateBulkAtt?uid=$empid&org_id=$orgdir&attlist=$jsonlist');
  try {
    FormData formData = new FormData.from({
      "attlist": jsonlist,
      "org_id": orgdir,
      "uid": empid,
      "location": location,
      "lat": lat,
      "long": long,
    });
    Response response = await dio.post(
        globals.path+"CreateBulkAtt/",data: formData
    );//, options: new Options(contentType:ContentType.parse("application/json"))
    //print(response.data.toString());
    //Map permissionMap = json.decode(response.data.toString());
    if (response.statusCode == 200) {
      //print("successfully");
      return "success";
    }else{
      //print("failed");
      return "failed";
    }
  }catch(e){
    //print("connection error");
    return "connection error";
    //print(e.toString());
  }
  final response = await http.get(globals.path +
      'CreateBulkAtt?uid=$empid&org_id=$orgdir&attlist=$jsonlist');
  var res = json.decode(response.body);
  print("--------> Adding Bulk Attendance" + res.toString());
  return res['sts'];
}
///////////////////////////////////////////////////////////
////////////////////////////group attendance ends///////////////////////////////
////////////////////////////////////////////////////////////

Future checkMandUpdate() async {
  final res = await http.get(globals.path+'checkMandUpdate?platform=Android');
  print(globals.path+'checkMandUpdate?platform=Android');
  // print('*****************************'+((json.decode(res.body.toString()))[0]['is_update']).toString()+'*****************************');
  return ((json.decode(res.body))[0]['is_update']).toString();

}
/*Shift Planner Object*/

class Shiftplanner {
  String Name;
  String DefaultShift;
  String DefaultTimes;
  String type;
  List<Shiftdetails> Details;
  List<SpecialShift> Special;
  String Id;
  String months;
  String ActiveFrom;
  String days;
  bool Expansionsts;
  Shiftplanner({this.Name,this.DefaultShift, this.DefaultTimes,this.type, this.Details,this.Special, this.Id, this.Expansionsts, this.months, this.ActiveFrom, this.days});
}

class Shiftdetails {
  String FromDay;
  String ToDay;
  String Shift;
  String Timings;
  String EffectiveFrom;
  Shiftdetails({this.FromDay, this.ToDay, this.Shift, this.Timings, this.EffectiveFrom});
}

class SpecialShift {
  String Shift;
  String Timings;
  String ShiftDate;
  SpecialShift({this.Shift, this.Timings, this.ShiftDate});
}

Future<List<Shiftplanner>> getShiftEmployee() async {
  final prefs = await SharedPreferences.getInstance();
  String orgid = prefs.getString('orgdir') ?? '';
//  print('getEmp called');
  final response = await http.get(globals.path + 'getShiftPlaned?refno=$orgid');
  print(response.body);
//  print('fun end here1');
  List responseJson = json.decode(response.body.toString());
  // print('fun end here2');
  List<Shiftplanner> empList = createShiftEmpList(responseJson);
  print('fun end here3');
  print(empList);
  return empList;
}

List<Shiftplanner> createShiftEmpList(List data) {
  // print('Create list called');
  List<Shiftplanner> list = new List();
  for (int i = 0; i < data.length; i++) {
    String name = data[i]["Name"];
    String defaultShift = data[i]["defaultShift"];
    String defaultShiftTimes = data[i]["defaultShiftTimes"];
    String type = data[i]["Type"];
    print(type);
    String months = '';
    String ActiveFrom = '';
    String days = '';
    if (type == '1')
      months = data[i]["Months"];

    if (type == '0')
      days = data[i]["Days"];
    List<Shiftdetails> Details = new List();
    List<SpecialShift> Special = new List();
    List detailshift = data[i]["Detail"];
    List detailspecial = data[i]["special"];


    if(detailshift!=null){
      for (int j = 0; j < detailshift.length; j++) {
        String FromDay = detailshift[j]["FromDay"];
        // print(FromDay);
        String ToDay = detailshift[j]["ToDay"];
        String Shift = detailshift[j]["Shift"];
        String Timings = detailshift[j]["Timings"];
        String EffectiveFrom = detailshift[j]["EffectiveFrom"];
        print(EffectiveFrom);
        Shiftdetails detail = new Shiftdetails(
            FromDay: FromDay,
            ToDay: ToDay,
            Shift: Shift,
            Timings: Timings,
            EffectiveFrom: EffectiveFrom
        );
        Details.add(detail);
      }
    }
    /* print('00000000000000');
    print(detailspecial);
    print('00000000000000');*/
    if(detailspecial!=null){
      for (int j = 0; j < detailspecial.length; j++) {
        String Shift = detailspecial[j]["Shift"];
        String Timings = detailspecial[j]["Timings"];
        String ShiftDate = detailspecial[j]["ShiftDate"];
        SpecialShift detail = new SpecialShift(
            Shift: Shift,
            Timings: Timings,
            ShiftDate: ShiftDate
        );
        Special.add(detail);
        // print(detail.FromDay);
      }
    }
    // print(Details);
    //  String status = data[i]["archive"] == '1' ? 'Active' : 'Inactive';
    //String id = data[i]["Id"];
    bool Expansionsts = false;
    //  print(name+'**'+dept+'**'+desg);
    Shiftplanner emp = new Shiftplanner(
      Name: name,
      DefaultShift: defaultShift,
      DefaultTimes: defaultShiftTimes,
      type: type,
      Details: Details,
      Special: Special,
      days: days,
      months: months,
      Expansionsts: Expansionsts,
    );
    list.add(emp);
  }
  return list;
}


Future<List<Map>> getAllShiftPlans(date) async{
  final prefs = await SharedPreferences.getInstance();
  date=date.substring(0, 10);
  String orgid = prefs.getString('orgdir') ?? '';
  print(globals.path + 'getAllShiftPlans?refno=$orgid&date=$date');
  final response = await http.get(globals.path + 'getAllShiftPlans?refno=$orgid&date=$date');
  List data = json.decode(response.body.toString());
  List<Map> depts = getShiftMap(data);
  // print(depts);
  return depts;
}
List<Map> getShiftMap(data){
  List<Map> newData= new List<Map>();
  for(int i =0;i<data.length;i++){
    Map item= {"Name":data[i]['Name'],"Shift":data[i]['shiftName'],"Timings":data[i]['shiftTime']};
    newData.add(item);
  }
  // newData.add({"AJAY":"Morning_Shift"});
  return newData;

}