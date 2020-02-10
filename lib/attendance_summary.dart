import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'Bottomnavigationbar.dart';
import 'drawer.dart';
import 'home.dart';
import 'globals.dart' as globals;
import 'package:multi_shift/services/services.dart';
import 'settings.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'reports.dart';
import 'attendance_detail.dart';
import 'globals.dart';
import 'mark_my_attendance.dart';
//import 'package:intl/intl.dart';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  String fname="";
  String lname="";
  String desination="";
  String profile="";
  String org_name="";
  int _currentIndex = 1;
  String admin_sts='0';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fname = prefs.getString('fname') ?? '';
      lname = prefs.getString('lname') ?? '';
      desination = prefs.getString('desination') ?? '';
      profile = prefs.getString('profile') ?? '';
      org_name = prefs.getString('org_name') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '';
    });
  }
  // This widget is the root of your application.
  Future<bool> sendToHome() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: ()=> sendToHome(),
    child: new Scaffold(
        appBar: new AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(org_name, style: new TextStyle(fontSize: 20.0)),
            ],
          ),
          leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MarkMyAttendance()),
            );
          },),
          backgroundColor: appBarColor(),
        ),
        bottomNavigationBar: Bottomnavigationbar(),
        endDrawer: new AppDrawer(),

        body: getWidgets(context),
      )
    );

  }
}

class User {
  String AttendanceDate;
  String thours;
  String TimeOut;
  String TimeIn;
  String bhour;
  String EntryImage;
  String checkInLoc;
  String ExitImage;
  String CheckOutLoc;
  String latit_in;
  String longi_in;
  String latit_out;
  String longi_out;
  String EmployeeId;
  String Name;

  int id=0;
  User({this.AttendanceDate,this.thours,this.id,this.TimeOut,this.TimeIn,this.bhour,this.EntryImage,this.checkInLoc,this.ExitImage,this.CheckOutLoc,this.latit_in,this.longi_in,this.latit_out,this.longi_out,this.Name,this.EmployeeId});
}

String dateFormatter(String date_) {
  // String date_='2018-09-2';
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun','Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  var dy = ['st', 'nd', 'rd', 'th', 'th', 'th','th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th', 'th','st','nd','rd', 'th', 'th', 'th', 'th', 'th', 'th', 'th','st'];
  var date = date_.split("-");
  return(date[2]+""+dy[int.parse(date[2])-1]+" "+months[int.parse(date[1])-1]);
}
getWidgets(context){
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Container(
          padding: EdgeInsets.only(top:12.0,bottom: 2.0),
          child:Center(
            child:Text('My Attendance Log',
                style: new TextStyle(fontSize: 22.0, color: appBarColor(),)),
          ),
        ),
        Divider(color: Colors.black54,height: 1.5,),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50.0,),
            SizedBox(width: MediaQuery.of(context).size.width*0.02),
            Container(
              width: MediaQuery.of(context).size.width*0.50,
              child:Text('Date',style: TextStyle(color: appBarColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
            ),

            SizedBox(height: 50.0,),
            Container(
              width: MediaQuery.of(context).size.width*0.2,
              child:Text('Time In',style: TextStyle(color: appBarColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
            ),
            SizedBox(height: 50.0,),
            Container(
              width: MediaQuery.of(context).size.width*0.2,
              child:Text('Time Out',style: TextStyle(color: appBarColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
            ),
          ],
        ),
        Divider(),

        Container(
            height: MediaQuery.of(context).size.height*0.60,
            child:
            FutureBuilder<List<User>>(
              future: getSummary(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  if(snapshot.data.length>0) {
                    return new ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 50.0,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.4,
                                      child:Text(Formatdate(snapshot.data[index].AttendanceDate)
                                          .toString(), style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),),
                                    ),
                                    SizedBox(height: 10.0,),
                                    InkWell(
                                      child: Container(
                                        height: 20.0,
                                        color: Colors.transparent,
                                        child: new Container(
                                            padding: EdgeInsets.only(left: 20.0,right: 20.0),
                                            decoration: new BoxDecoration(
                                                color: Colors.orangeAccent,
                                                borderRadius: BorderRadius.all(const Radius.circular(10.0))),
                                            child: new Center(
                                              child: new Text("View Detail",style: TextStyle(color: Colors.white),),
                                            )),
                                      ),
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => AttendanceDetail(snapshot.data[index].EmployeeId,snapshot.data[index].AttendanceDate,snapshot.data[index].Name)),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 50.0,),
                                Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.22,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Text(snapshot.data[index].TimeIn
                                            .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                        Container(
                                          width: 62.0,
                                          height: 62.0,
                                          child: Container(
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: new NetworkImage(
                                                          snapshot
                                                              .data[index]
                                                              .EntryImage)
                                                  )
                                              )),),

                                      ],
                                    )

                                ),
                                SizedBox(height: 50.0,),
                                Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.22,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Text(snapshot.data[index].TimeOut
                                            .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                        Container(
                                          width: 62.0,
                                          height: 62.0,
                                          child: Container(
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: new NetworkImage(
                                                          snapshot
                                                              .data[index]
                                                              .ExitImage)
                                                  )
                                              )),),

                                      ],
                                    )

                                ),
                              ],
                            ),
                            onTap: (){
                             // print(snapshot.data[index].EmployeeId+" "+snapshot.data[index].AttendanceDate+" "+snapshot.data[index].Name);
                              return null;

                              //showInSnackBar(snapshot.data[index].Date+" "+snapshot.data[index].EmployeeId);
                            },
                          );
                        }
                    );
                  }else{
                    return new Center(
                      child:Text("No attendance found"),
                    );
                  }
                } else if (snapshot.hasError) {
                  return new Text("Unable to connect server");
                }

                // By default, show a loading spinner
                return new Center( child: CircularProgressIndicator());
              },
            )
        ),
      ]
  );
}
Future<List<User>> getSummary() async {
  final prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString('empid') ?? '';
  String orgdir = prefs.getString('orgdir') ?? '';
 final response = await http.get(globals.path+'getHistory?uid=$empid&refno=$orgdir');
  print(response.body);
  List responseJson = json.decode(response.body.toString());
  List<User> userList = createUserList(responseJson);
  return userList;
}

List<User> createUserList(List data){
  List<User> list = new List();
  for (int i = 0; i < data.length; i++) {
    String Name=data[i]["Name"];
    String EmployeeId=data[i]["EmployeeId"];
    String title = data[i]["AttendanceDate"];
    String TimeOut=data[i]["TimeOut"]=="00:00:00"?'-':data[i]["TimeOut"].toString().substring(0,5);
    String TimeIn=data[i]["TimeIn"]=="00:00:00"?'-':data[i]["TimeIn"].toString().substring(0,5);
    String thours=data[i]["thours"]=="00:00:00"?'-':data[i]["thours"].toString().substring(0,5);
    String bhour=data[i]["bhour"]==null?'':'Time Off: '+data[i]["bhour"].substring(0,5);
    String EntryImage=data[i]["EntryImage"]!=''?data[i]["EntryImage"]:'http://ubishift.ubihrm.com/assets/img/avatar.png';
    String ExitImage=data[i]["ExitImage"]!=''?data[i]["ExitImage"]:'http://ubishift.ubihrm.com/assets/img/avatar.png';
    String checkInLoc=data[i]["checkInLoc"];
    String CheckOutLoc=data[i]["CheckOutLoc"];
    String Latit_in=data[i]["latit_in"];
    String Longi_in=data[i]["longi_in"];
    String Latit_out=data[i]["latit_out"];
    String Longi_out=data[i]["longi_out"];
    int id = 0;
    User user = new User(
        AttendanceDate: title,thours: thours,id: id,TimeOut:TimeOut,TimeIn:TimeIn,bhour:bhour,EntryImage:EntryImage,checkInLoc:checkInLoc,ExitImage:ExitImage,CheckOutLoc:CheckOutLoc,latit_in: Latit_in,longi_in: Longi_in,latit_out: Latit_out,longi_out: Longi_out,Name:Name,EmployeeId:EmployeeId);
    list.add(user);
  }
  return list;
}