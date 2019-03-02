// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:multi_shift/services/fetch_location.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'dart:convert';
import 'package:multi_shift/services/services.dart';
import 'attendance_summary.dart';
import 'home.dart';
import 'drawer.dart';
import 'dart:async';
import 'package:multi_shift/services/fetch_location.dart';
import 'timeoff.dart';
import 'package:multi_shift/services/newservices.dart';
import 'package:multi_shift/model/model.dart';
import 'settings.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'reports.dart';
import 'globals.dart';

// This app is a stateful, it tracks the user's current choice.
class TimeoffSummary extends StatefulWidget {
  @override
  _TimeoffSummary createState() => _TimeoffSummary();
}

class _TimeoffSummary extends State<TimeoffSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var profileimage;
  bool _checkLoaded = true;
  int checkProcessing = 0;
  int _currentIndex = 1;
  bool _visible = true;
  bool _isButtonDisabled=false;
  String location_addr = "";
  String location_addr1 = "";
  String admin_sts='0';
  String act = "";
  String act1 = "";
  int response;
  String fname = "",
      lname = "",
      empid = "",
      email = "",
      status = "",
      orgid = "",
      orgdir = "",
      sstatus = "",
      org_name = "",
      desination = "",
      profile = "",
      latit = "",
      longi = "";
  String lid = "";
  String shiftId = "";
  TextEditingController client_name,comments;
  @override
  void initState() {
    client_name = new TextEditingController();
    comments = new TextEditingController();
    super.initState();
    initPlatformState();
  }
  @override

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    response = prefs.getInt('response') ?? 0;
    admin_sts = prefs.getString('sstatus') ?? 0;
    if (response == 1) {
      Loc lock = new Loc();
      location_addr = await lock.initPlatformState();
      //act =await checkPunch(empid, orgdir);

      //act= 'PunchOut';

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
        lid = prefs.getString('lid') ?? "0";
        act= lid!='0'?'PunchOut':'PunchIn';

        profileimage = new NetworkImage(profile);
        profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        });
        latit = prefs.getString('latit') ?? '';
        longi = prefs.getString('longi') ?? '';
        shiftId = prefs.getString('shiftId') ?? "";
        print("this is set state " + lid);
        act1 = act;
      });
    }
  }

  withdrawlTimeOff(String timeoffid) async{
    NewServices ns = new NewServices();

    var timeoff = TimeOff(TimeOffId: timeoffid, OrgId: orgid, EmpId: empid, ApprovalSts: '5');
    var islogin = await ns.withdrawTimeOff(timeoff);
    print(islogin);
    if(islogin=="success"){
      setState(() {
        _isButtonDisabled=false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimeoffSummary()),
      );
      /*showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Congrats!"),
        content: new Text("Your leave is withdrawl successfully!"),
      )
      );*/
    }else if(islogin=="failure"){
      setState(() {
        _isButtonDisabled=false;
      });
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Sorry!"),
        content: new Text("Timeoff withdrawl failed."),
      )
      );
    }else{
      setState(() {
        _isButtonDisabled=false;
      });
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Sorry!"),
        content: new Text("Poor network connection."),
      )
      );
    }
  }

  confirmWithdrawl(String timeoffid) async{
    showDialog(context: context, child:
    new AlertDialog(
      title: new Text("Are you sure?",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0),),
      content:  ButtonBar(
        children: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            shape: Border.all(color: Colors.black54),
            onPressed: () {
              setState(() {
                _isButtonDisabled=false;
              });
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          RaisedButton(
            child: Text('Withdraw',style: TextStyle(color: Colors.white),),
            color: Colors.orangeAccent,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              withdrawlTimeOff(timeoffid);
            },
          ),
        ],
      ),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return (response == 0) ? new LoginPage() : getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value, textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getmainhomewidget() {
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },),
        backgroundColor: appBarColor(),
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
          else if (newIndex == 0) {
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
          if(newIndex==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          }
          print("Current pressed new indexed "+newIndex.toString());
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
            icon: new Icon(Icons.home,color: Colors.black54,),
            title: new Text('Home',style:TextStyle(color: Colors.black54,)),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          )
        ],
      ),

      endDrawer: new AppDrawer(),
      body: (act1 == '') ? Center(child: loader()) : checkalreadylogin(),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimeOffPage()),
          );
        },
        tooltip: 'Request TimeOff',
        child: new Icon(Icons.add),
      ),
    );
  }

  checkalreadylogin() {
    if (response == 1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          mainbodyWidget(),
          underdevelopment()
        ],
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  loader() {/*
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 150.0, width: 150.0),
            ]),
      ),
    );*/
  }

  underdevelopment() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.android, color: appBarColor(),),
              Text("Under development",
                style: new TextStyle(fontSize: 30.0, color: appBarColor()),)
            ]),
      ),
    );
  }

  mainbodyWidget() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15.0),
              (act1 == '') ? loader() : getMarkAttendanceWidgit(act1),
              //getMarkAttendanceWidgit(),
            ],
          ),


        ],
      ),

    );
  }

  getMarkAttendanceWidgit(act1) {
    double h_width = MediaQuery.of(context).size.width*0.5; // screen's 50%
    double f_width = MediaQuery.of(context).size.width*1;

//print('==========================='+act1);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('My Time Off History',
              style: new TextStyle(fontSize: 22.0, color: appBarColor())),
          //SizedBox(height: 10.0),

          new Divider(color: Colors.black54,height: 1.5,),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50.0,),
              SizedBox(width: MediaQuery.of(context).size.width*0.02),
              Container(
                width: MediaQuery.of(context).size.width*0.30,
                child:Text('Date',style: TextStyle(color: Colors.orangeAccent,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),

              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('Start',style: TextStyle(color: Colors.orangeAccent,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.24,
                child:Text('End',style: TextStyle(color: Colors.orangeAccent,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('Status',style: TextStyle(color: Colors.orangeAccent,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
            ],
          ),
          new Divider(),
          new Container(
            height: MediaQuery.of(context).size.height*.60,
            width: MediaQuery.of(context).size.width*.99,
            //padding: EdgeInsets.only(bottom: 15.0),
            color: Colors.white,
            //////////////////////////////////////////////////////////////////////---------------------------------
            child: new FutureBuilder<List<TimeOff>>(
              future: getTimeOffSummary(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data.length>0){
                  return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {

                        return new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                  width: MediaQuery.of(context).size.width * 0.30,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        snapshot.data[index].TimeofDate.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                    /*  (snapshot.data[index].withdrawlsts && snapshot.data[index].ApprovalSts.toString()!='Withdrawn' && snapshot.data[index].ApprovalSts.toString()!="Rejected")?new Container(
                                              height:18.5,
                                              child:new  FlatButton(
                                                shape: Border.all(color: Colors.blue),
                                                padding: EdgeInsets.all(1.0),
                                                onPressed: () {
                                                  confirmWithdrawl(snapshot.data[index].TimeOffId.toString());
                                                },
                                                child: Text("Withdraw",style: TextStyle(color: Colors.blue),),
                                              )
                                      ):Center(),*/
                                    ],
                                  )),

                              new Container(
                                  width: MediaQuery.of(context).size.width * 0.22,
                                  child:  Text(
                                      snapshot.data[index].TimeFrom.toString(),style:TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width * 0.22,
                                child:  Text(
                                    snapshot.data[index].TimeTo.toString(),style:TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.22,
                                /*decoration: new ShapeDecoration(
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(2.0)),
                                  color: snapshot.data[index].ApprovalSts.toString()=='Approved'?Colors.green.withOpacity(0.75):snapshot.data[index].ApprovalSts.toString()=='Rejected' || snapshot.data[index].ApprovalSts.toString()=='Cancel' ?Colors.red.withOpacity(0.65):snapshot.data[index].ApprovalSts.toString().startsWith('Pending')?Colors.orangeAccent:Colors.black12,
                                ),

                                //color: Colors.black12, // withdrawn
                                //color: Colors.orangeAccent, // pending
                                //color: Colors.red.withOpacity(0.65), // rejected,cancel
                                // color: Colors.green.withOpacity(0.75), // approved
                                padding: EdgeInsets.only(top:1.5,bottom: 1.5,left:8.0,right:8.0),
                                margin: EdgeInsets.only(top: 4.0),
                                child: Text(snapshot.data[index].ApprovalSts.toString(), style: TextStyle(color: Colors.white, fontSize: 14.0,),textAlign: TextAlign.center, ),*/
                                child:Column(
                                  children: <Widget>[
                                    new Text(snapshot.data[index].ApprovalSts.toString(), style: TextStyle(color: snapshot.data[index].ApprovalSts.toString()=='Approved'?Colors.green.withOpacity(0.75):snapshot.data[index].ApprovalSts.toString()=='Rejected' || snapshot.data[index].ApprovalSts.toString()=='Cancel' ?Colors.red.withOpacity(0.65):snapshot.data[index].ApprovalSts.toString().startsWith('Pending')?Colors.orangeAccent:Colors.black54, fontSize: 14.0,),textAlign: TextAlign.center,),

  SizedBox(height: 7.0,),
                                    (snapshot.data[index].withdrawlsts && snapshot.data[index].ApprovalSts.toString()!='Withdrawn' && snapshot.data[index].ApprovalSts.toString()!="Rejected")?InkWell(
                                      child: Container(
                                        height:18.5,
                                        child:new  FlatButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0),side: BorderSide(color: Colors.blue),),
                                        padding: EdgeInsets.only(left:1.0,right:1.0),
                                        onPressed: () {
                                          if(_isButtonDisabled)
                                            return null;
                                          setState(() {
                                            _isButtonDisabled=true;
                                            checkProcessing = index;
                                          });
                                          confirmWithdrawl(snapshot.data[index].TimeOffId.toString());
                                        },
                                        child: (_isButtonDisabled && checkProcessing==index)?Text("Processing..",style: TextStyle(color: Colors.blue),):Text("Withdraw",style: TextStyle(color: Colors.blue),),
                                      ),
                                      ),
                                    ):Center(),

                                  ],
                                ),
                                 // child: Text(snapshot.data[index].ApprovalSts.toString(), style: TextStyle(color: snapshot.data[index].ApprovalSts.toString()=='Approved'?Colors.green.withOpacity(0.75):snapshot.data[index].ApprovalSts.toString()=='Rejected' || snapshot.data[index].ApprovalSts.toString()=='Cancel' ?Colors.red.withOpacity(0.65):snapshot.data[index].ApprovalSts.toString().startsWith('Pending')?Colors.orangeAccent:Colors.black54, fontSize: 14.0,),textAlign: TextAlign.center, )
                              ),
                            /*  (snapshot.data[index].withdrawlsts && snapshot.data[index].ApprovalSts.toString()!='Withdraw' && snapshot.data[index].ApprovalSts.toString()!="Rejected")?Container(
                                  height: 25.0,
                                  width: 25.0,
                                  child: FittedBox(
                                      child:new  FloatingActionButton(
                                        backgroundColor: Colors.redAccent,
                                        onPressed: () {
                                          confirmWithdrawl(snapshot.data[index].TimeOffId.toString());
                                        },
                                        tooltip: 'Withdraw Timeoff',
                                        child: new Icon(Icons.refresh, size: 40.0,),
                                      )
                                  )
                              ): Container(),*/
                              //Divider(),
                            ],
                          ),
                          //SizedBox(width: 30.0,),

                          snapshot.data[index].Reason.toString()!='-'?Container(
                            width: MediaQuery.of(context).size.width*.90,
                            padding: EdgeInsets.only(top:1.5,bottom: 1.5),
                            margin: EdgeInsets.only(top: 4.0),
                            child: Text('Reason: '+snapshot.data[index].Reason.toString(), style: TextStyle(color: Colors.black54),),
                          ):Center(),
                          snapshot.data[index].ApproverComment.toString()!='-'?Container(
                            width: MediaQuery.of(context).size.width*.90,
                            padding: EdgeInsets.only(top:1.5,bottom: 1.5),
                            margin: EdgeInsets.only(top: 4.0),
                            child: Text('Comment: '+snapshot.data[index].ApproverComment.toString(), style: TextStyle(color: Colors.black54), ),
                          ):Center(
                       // child:Text(snapshot.data[index].withdrawlsts.toString()),
                        ),

                          Divider(color: Colors.black45,),
                        ]);
                      }
                  );
                  }else
                    return new Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width*1,
                        color: Colors.teal.withOpacity(0.1),
                        padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                        child:Text("you have not taken any time off  ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                      ),
                    );
                } else if (snapshot.hasError) {
                  return new Text("Unable to connect server");
                }

                // By default, show a loading spinner
                return new Center( child: CircularProgressIndicator());
              },
            ),
            //////////////////////////////////////////////////////////////////////---------------------------------
          ),

        ]);
  }




  getPunchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('getPunchPrefs called: new lid- '+ prefs.getString('lid').toString());
    return prefs.getString('lid');
  }


/////////////////////futere method dor getting today's punched liist-start

/////////////////////futere method dor getting today's punched liist-close

}

