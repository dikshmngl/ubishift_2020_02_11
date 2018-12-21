// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:multi_shift/services/fetch_location.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:multi_shift/services/gethome.dart';
import 'package:multi_shift/services/saveimage.dart';
import 'package:multi_shift/model/timeinout.dart';
import 'attendance_summary.dart';
import 'punchlocation.dart';
import 'drawer.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:multi_shift/model/model.dart';
import 'package:multi_shift/services/newservices.dart';
import 'leave_summary.dart';
import 'settings.dart';
import 'home.dart';
import 'reports.dart';
import 'profile.dart';

// This app is a stateful, it tracks the user's current choice.
class LeavePage extends StatefulWidget {
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  List<Map> leavetimeList = [{"id":"2","name":"Half Day"},{"id":"1","name":"Full Day"}];
  String leavetimevalue = "1";
  String leavetimevalue1 = "1";
  bool isloading = false;
  String admin_sts='0';
  DateTime Date1 = new DateTime.now();
  DateTime Date2 = new DateTime.now();
  final _dateController = TextEditingController();
  final _dateController1 = TextEditingController();
  final _leavetimevalueController = TextEditingController();
  final _leavetimevalueController1 = TextEditingController();
  final _reasonController = TextEditingController();
  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textthirdFocusNode = new FocusNode();
  FocusNode textfourthFocusNode = new FocusNode();
  final dateFormat = DateFormat("d MMMM");
  final timeFormat = DateFormat("h:mm a");
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _defaultimage = new NetworkImage(
      "http://ubiattendance.ubihrm.com/assets/img/avatar.png");
  var profileimage;
  bool _checkLoaded = true;
  int _currentIndex = 1;
  bool _visible = true;
  String location_addr="";
  String location_addr1="";
  String act="";
  String act1="";
  int response;
  String leavetypeid="";
  String fname="", lname="", empid="", email="", status="", orgid="", orgdir="", sstatus="", org_name="", desination="", profile,latit="",longi="";
  String aid="";
  String shiftId="";
  String _radioValue = "1"; // half day from type
  String _radioValue1 = "1"; // half day to type
  bool visibilityFromHalf = false;
  bool visibilityToHalf = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    admin_sts = prefs.getString('sstatus') ?? '';
    response = prefs.getInt('response') ?? 0;
    if(response==1) {
      Loc lock = new Loc();
      location_addr = await lock.initPlatformState();

      Home ho = new Home();
      act = await ho.checkTimeIn(empid, orgdir);

      print("this is main "+location_addr);
      setState(() {
        location_addr1 = location_addr;
        response = prefs.getInt('response') ?? 0;
        fname = prefs.getString('fname') ?? '';
        lname = prefs.getString('lname') ?? '';
        empid = prefs.getString('empid') ?? '';
        email = prefs.getString('email') ?? '';
        status = prefs.getString('status') ?? '';
        orgid = prefs.getString('orgid') ?? '';
        orgdir = prefs.getString('orgdir') ?? '';
        sstatus = prefs.getString('sstatus') ?? '';
        org_name = prefs.getString('org_name') ?? '';
        desination = prefs.getString('desination') ?? '';
        profile = prefs.getString('profile') ?? '';
        leavetypeid = prefs.getString('leavetypeid') ?? '';

        profileimage = new NetworkImage(profile);
        print("1-"+profile);
        profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        });
        print("2-"+_checkLoaded.toString());
        latit = prefs.getString('latit') ?? '';
        longi = prefs.getString('longi') ?? '';
        aid = prefs.getString('aid') ?? "";
        shiftId = prefs.getString('shiftId') ?? "";
        print("this is set state "+location_addr1);
        act1=act;
        print(act1);
      });
    }
  }

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
    });
  }

  void _handleRadioValueChange1(String value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (response==0) ? new LoginPage() : getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getmainhomewidget(){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(org_name, style: new TextStyle(fontSize: 20.0)),
          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
          Navigator.of(context).pop();
        },),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
            return;
          }
          if(newIndex==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          }else if (newIndex == 0) {
            (admin_sts == '1')
                ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Reports()),
            )
                : Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            return;
          }
          setState((){_currentIndex = newIndex;});
        }, // this will be set when a new tab is tapped
        items: [
          (admin_sts == '1')
              ? BottomNavigationBarItem(
            icon: new Icon(
              Icons.library_books,
            ),
            title: new Text('Reports'),
          )
              : BottomNavigationBarItem(
            icon: new Icon(
              Icons.person,
            ),
            title: new Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home,color: Colors.black54,),
            title: new Text('Home',style: TextStyle(color: Colors.black54),),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          )
        ],
      ),
      endDrawer: new AppDrawer(),
      body: (act1=='') ? Center(child : loader()) : checkalreadylogin(),
    );

  }
  checkalreadylogin(){
    if(response==1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          mainbodyWidget(),
          underdevelopment()
        ],
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
      ),
    );
  }
  underdevelopment(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.android,color: Colors.teal,),Text("Under development",style: new TextStyle(fontSize: 30.0,color: Colors.teal),)
            ]),
      ),
    );
  }

  mainbodyWidget(){
    return Center(
      child: Form(
        key: _formKey,
        child: SafeArea(
            child: Column( children: <Widget>[
              SizedBox(height: 20.0),
              Text('Request Leave',
                  style: new TextStyle(fontSize: 22.0, color: Colors.teal)),
              new Divider(color: Colors.black54,height: 1.5,),
              new Expanded(child: ListView(
                //padding: EdgeInsets.symmetric(horizontal: 15.0),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                       //Enter date
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DateTimePickerFormField(

                              firstDate: new DateTime.now(),
                              initialDate: new DateTime.now(),

                              dateOnly: true,
                              format: dateFormat,
                              controller: _dateController,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Icon(
                                    Icons.date_range,
                                    color: Colors.grey,
                                  ), // icon is 48px widget.
                                ), // icon is 48px widget.
                                labelText: 'From Date',
                              ),
                              validator: (date) {
                                if (date==null){
                                  return 'Please enter Leave From date';
                                }
                              },
                              onChanged: (dt) {
                                setState(() {
                                  Date1 = dt;
                                });
                                print("----->Changed date------> "+Date1.toString());
                                },
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: new InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Leave Type',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Icon(
                                    Icons.tonality,
                                    color: Colors.grey,
                                  ), // icon is 48px widget.
                                ),
                              ),
                              //   isEmpty: _color == '',
                              child:  new DropdownButton<String>(
                                isDense: true,
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black
                                ),
                                value: leavetimevalue,
                                onChanged: (String newValue) {
                                  setState(() {
                                    leavetimevalue = newValue;
                                    if(leavetimevalue=="2"){
                                      visibilityFromHalf = true;
                                    }else{
                                      visibilityFromHalf = false;
                                    }
                                  });
                                },
                                items: leavetimeList.map((Map map) {
                                  return new DropdownMenuItem<String>(
                                    value: map["id"].toString(),
                                    child: new Text(
                                      map["name"],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      (visibilityFromHalf)?Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Radio(
                            value: "1",
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          Text("First Half",style: TextStyle(fontSize: 16.0),),
                          SizedBox(width: 30.0,),
                          new Radio(
                            value: "2",
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          Text("Second Half",style: TextStyle(fontSize: 16.0),)
                        ],
                      ):Container(),
                      SizedBox(height: 10.0,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DateTimePickerFormField(
                              firstDate: new DateTime.now(),
                              initialDate: new DateTime.now(),
                              dateOnly: true,
                              format: dateFormat,
                              controller: _dateController1,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Icon(
                                    Icons.date_range,
                                    color: Colors.grey,
                                  ), // icon is 48px widget.
                                ), // icon is 48px widget.

                                labelText: 'To Date',
                              ),
                              onChanged: (dt) {
                                setState(() {
                                  Date2 = dt;
                                });
                                print("----->Changed date------> "+Date1.toString());
                              },
                              validator: (dt) {
                                if (dt==null){
                                  return 'Please enter Leave to date';
                                }
                                if(Date2.isBefore(Date1)){
                                  print("Dat1 ---->"+Date1.toString());
                                  print("Date2---->"+Date2.toString());
                                  return '\"To Date\" can\'t be smaller.';
                                }

                              },
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child:new InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Leave Type',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Icon(
                                    Icons.tonality,
                                    color: Colors.grey,
                                  ), // icon is 48px widget.
                                ),
                              ),
                              //   isEmpty: _color == '',
                              child:  new DropdownButton<String>(
                                isDense: true,
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black
                                ),
                                value: leavetimevalue1,
                                onChanged: (String newValue) {
                                  setState(() {
                                    leavetimevalue1 = newValue;
                                    if(leavetimevalue1=="2"){
                                      visibilityToHalf = true;
                                    }else{
                                      visibilityToHalf = false;
                                    }
                                  });
                                },
                                items: leavetimeList.map((Map map) {
                                  return new DropdownMenuItem<String>(
                                    value: map["id"].toString(),
                                    child: new Text(
                                      map["name"],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ),
                        ],
                      ),
                (visibilityToHalf)?Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Radio(
                            value: "1",
                            groupValue: _radioValue1,
                            onChanged: _handleRadioValueChange1,
                          ),
                          Text("First Half",style: TextStyle(fontSize: 16.0),),
                          SizedBox(width: 30.0,),
                          new Radio(
                            value: "2",
                            groupValue: _radioValue1,
                            onChanged: _handleRadioValueChange1,
                          ),
                          Text("Second Half",style: TextStyle(fontSize: 16.0),)
                        ],
                      ):Container(),

                      TextFormField(
                        controller: _reasonController,
                        decoration: InputDecoration(
                            labelText: 'Reason',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.event_note,
                                color: Colors.grey,
                              ), // icon is 48px widget.
                            )
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter reason';
                          }
                        },
                        onFieldSubmitted: (String value) {
                          if (_formKey.currentState.validate()) {
                            //requesttimeoff(_dateController.text ,_starttimeController.text,_endtimeController.text,_reasonController.text, context);
                          }
                        },
                        maxLines: 3,
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            shape: Border.all(color: Colors.black54),
                            child: Text('CANCEL'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          RaisedButton(
                            child: Text('SAVE',style: TextStyle(color: Colors.white),),
                            color: Colors.orangeAccent,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                requestleave(_dateController.text, _dateController1.text ,leavetimevalue, leavetimevalue1, _radioValue, _radioValue1, _reasonController.text);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
              )
            ]
            )
        ),
      ),
    );
  }

  requestleave(var leavefrom, var leaveto, var leavetypefrom, var leavetypeto, var halfdayfromtype, var halfdaytotype, var reason) async{
    final prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("empid");
    String orgid = prefs.getString("orgid");

    Leave leave =new Leave(uid: uid, leavefrom: leavefrom, leaveto: leaveto, orgid: orgid, reason: reason, leavetypeid: leavetypeid, leavetypefrom: leavetypefrom, leavetypeto: leavetypeto, halfdayfromtype: halfdayfromtype, halfdaytotype: halfdaytotype);
    NewServices request =new NewServices();
    var islogin = await request.requestLeave(leave);
    print("--->"+islogin);
    if(islogin=="true"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LeaveSummary()),
      );
      //showInSnackBar("Leave has been applied successfully.");
    }else if(islogin=="false"){
      showInSnackBar("Leave is already applied for this date.");
    }else{
      showInSnackBar("Poor Network Connection");
    }
  }
}