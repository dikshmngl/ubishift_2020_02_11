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
import 'package:multi_shift/model/model.dart' as TimeOffModal;
import 'package:multi_shift/services/newservices.dart';
import 'timeoff_summary.dart';
import 'package:flutter/services.dart';
import 'package:multi_shift/services/services.dart';
import 'home.dart';
import 'settings.dart';
import 'reports.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'globals.dart';

// This app is a stateful, it tracks the user's current choice.
class PermissionPage extends StatefulWidget {
  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  NewServices ns = NewServices();
  List<Desg> desglist = null;

  double timeDilation = 20.0;
  bool isloading = false;
  final _dateController = TextEditingController();
  final _starttimeController = TextEditingController();
  final _endtimeController = TextEditingController();
  final _reasonController = TextEditingController();
  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textthirdFocusNode = new FocusNode();
  FocusNode textfourthFocusNode = new FocusNode();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
  final timeFormat = DateFormat("h:mm a");
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _defaultimage = new NetworkImage(
      "http://ubiattendance.ubihrm.com/assets/img/avatar.png");
  var profileimage;
  bool _checkLoaded = true;
  int _currentIndex = 2;
  bool _visible = true;
  String location_addr="";
  String location_addr1="";
  String act="";
  String act1="";
  String admin_sts='0';
  int response;
  String fname="", lname="", empid="", email="", status="", orgid="", orgdir="", sstatus="", org_name="", desination="",desinationId="", profile,    latit="",longi="";
  String aid="";
  String shiftId="";
  @override
  void initState() {
    //super.initState();
    initPlatformState();
  }
  @override
  void dipose(){
    super.dispose();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    admin_sts = prefs.getString('sstatus') ?? '';
    orgid = prefs.getString('orgid') ?? '';
    desinationId = prefs.getString('desinationId') ?? '';
    ns.getAllDesgPermission(orgid,desinationId).then((DesgList){
      setState(() {
        desglist = DesgList;
      });
    });
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

  List<CheckboxListTile> getCheckboxList(List data, int index){
    List<CheckboxListTile> list =new List<CheckboxListTile>();
   // print("permission list-->>>>>>"+data.toString());
    for (int i = 0; i < data.length; i++) {
     String label = data[i]["label"];
     int vsts = data[i]["vsts"];
    // print(label + i.toString());
    /*  // String status=data[i]["archive"]=='1'?'Active':'Inactive';
      String id =data[i]["id"];
      List permissionlist = data[i]["permissions"];
      Desg dpt = new Desg(desg: desg,id:id,modulepermissions: permissionlist);*/
     list.add(new CheckboxListTile(
       title: Text(label),
       value: desglist[index].modulepermissions[i]["vsts"] == 1,
       onChanged: (bool value) {
         setState(() { desglist[index].modulepermissions[i]["vsts"] = value ? 1 : 0; });
       },
     ));
    }
    return list;
  }

  List<ExpansionTile> getExpansionTileList(){
    List<ExpansionTile> list =new List<ExpansionTile>();
    //print("permission list-->>>>>>"+desglist.toString());
    print("permission length "+desglist.length.toString());
    for (int i = 0; i < desglist.length; i++) {
      String desg = desglist[i].desg.toString();
      //print(desg + i.toString());
      /*  // String status=data[i]["archive"]=='1'?'Active':'Inactive';
      String id =data[i]["id"];
      List permissionlist = data[i]["permissions"];
      Desg dpt = new Desg(desg: desg,id:id,modulepermissions: permissionlist);*/
      list.add(new ExpansionTile(
        title: new Text(desg),
        children: getCheckboxList(desglist[i].modulepermissions,i),
      ));
    }
    return list;
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
        backgroundColor: appBarColor(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
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
              MaterialPageRoute(builder: (context) => MyApp()),
            );
            return;
          }
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
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
              Icons.calendar_today,
            ),
            title: new Text('Log'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings,color: Colors.black54,),
              title: Text('Settings',style: TextStyle(color: Colors.black54),)
          )
        ],
      ),
      endDrawer: new AppDrawer(),
      body: (act1=='') ? Center(child : loader()) : checkalreadylogin(),
        floatingActionButton: new FloatingActionButton(
          onPressed: (){
            updatePermissions();
          },
          tooltip: 'Save Permissions',
          child: new Icon(Icons.cloud_upload),
        )
    );

  }

  updatePermissions() async{
    setState(() {
      act1='';
    });
    String result=await ns.savePermission(desglist, orgid, empid);
    setState(() {
      act1=result;
    });
    print("------> response save permission "+act1);
    if(act1=="success"){
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Congrats!"),
        content: new Text("Permission saved successfully"),
      )
      );
      //showInSnackBar("Permission is saved successfully");
    }else if(act1=="failed"){
      showInSnackBar("Problem while saving permissions");
    }else{
      showInSnackBar("Network connection problem");
    }
  }


  checkalreadylogin(){
    if(response==1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          underdevelopment(),
          desglist==null?loader():mainbodyWidget(),
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
              Icon(Icons.android,color: appBarColor(),),Text("Under development",style: new TextStyle(fontSize: 30.0,color: appBarColor()),)
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
              Text('Permissions',
                  style: new TextStyle(fontSize: 22.0, color: appBarColor())),
              new Divider(color: Colors.black54,height: 1.5,),
              new Expanded(child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  new Container(
                    height: MediaQuery.of(context).size.height*.75,
                    width: MediaQuery.of(context).size.width*.99,
                    //padding: EdgeInsets.only(bottom: 15.0),
                    color: Colors.white,
                    //////////////////////////////////////////////////////////////////////---------------------------------
                    child: new ListView(
                              scrollDirection: Axis.vertical,

                        children: <Widget>[
                                new Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: getExpansionTileList(),
                                  ),
                                  alignment: Alignment(0.0, 0.0),
                                )
                               ]
                          )

                    //////////////////////////////////////////////////////////////////////---------------------------------
                  ),
                ],
              ),
              ),
            ]
            )
        ),
      ),
    );
  }

  requesttimeoff(var timeoffdate,var starttime,var endtime,var reason, BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    String empid = prefs.getString("empid");
    String orgid = prefs.getString("orgid");
    //var timeoff = TimeOffModal.TimeOff(Time timeoffdate, starttime, endtime, reason, empid, orgid);
    var timeoff = TimeOffModal.TimeOff(TimeofDate: timeoffdate,TimeFrom: starttime, TimeTo: endtime, Reason: reason, EmpId: empid, OrgId: orgid);
    RequestTimeOffService request =new RequestTimeOffService();
    var islogin = await request.requestTimeOff(timeoff);
    print("--->"+islogin);
    if(islogin=="success"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimeoffSummary()),
      );
    }else if(islogin=="failure"){
      showInSnackBar("Unable to request time off, permission denied.");
    }else{
      showInSnackBar("Poor Network Connection");
    }
  }
}