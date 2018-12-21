// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:multi_shift/services/fetch_location.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:multi_shift/services/services.dart';
import 'home.dart';
import 'drawer.dart';
import 'package:multi_shift/services/newservices.dart';
import 'globals.dart';
import 'settings.dart';
import 'punchlocation_summary.dart';
import 'profile.dart';
import 'reports.dart';

// This app is a stateful, it tracks the user's current choice.
class PunchLocation extends StatefulWidget {
  @override
  _PunchLocation createState() => _PunchLocation();
}

class _PunchLocation extends State<PunchLocation> {
  StreamLocation sl = new StreamLocation();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _defaultimage = new NetworkImage(
      "http://ubiattendance.ubihrm.com/assets/img/avatar.png");
  var profileimage;
  bool _checkLoaded = true;
  int _currentIndex = 1;
  bool _visible = true;
  String location_addr = "";
  String admin_sts = "0";
  String location_addr1 = "";
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
  bool _isButtonDisabled= false;
  TextEditingController client_name,comments;
  @override
  void initState() {
    client_name = new TextEditingController();
    comments = new TextEditingController();
    super.initState();
    initPlatformState();
    sl.startStreaming(1);
  }
  @override

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    response = prefs.getInt('response') ?? 0;
    admin_sts = prefs.getString('sstatus') ?? '0';
    if (response == 1) {
      setState(() {
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

        if(list!=null && list.length>0) {
          latit = list[list.length - 1]['latitude'].toString();
          longi = list[list.length - 1]["longitude"].toString();
          location_addr1 = globalstreamlocationaddr;
        }else{
          latit = "0.0";
          longi = "0.0";
          location_addr1 = "";
        }

        shiftId = prefs.getString('shiftId') ?? "";
        print("this is set state " + lid);
        act1 = act;
      });
    }
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

            new Text(org_name, style: new TextStyle(fontSize: 24.0)),

          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PunchLocationSummary()),
          );
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
          } if (newIndex == 0) {
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
          if(newIndex==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
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
              Icon(Icons.android, color: Colors.teal,),
              Text("Under development",
                style: new TextStyle(fontSize: 30.0, color: Colors.teal),)
            ]),
      ),
    );
  }

  mainbodyWidget() {

    return SafeArea(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height*0.2),
              //Image.asset('assets/logo.png',height: 150.0,width: 150.0),
              // SizedBox(height: 5.0),
             // Text("Hi " + fname, style: new TextStyle(fontSize: 20.0)),
             // SizedBox(height: 5.0),
              (act1 == '') ? loader() : getMarkAttendanceWidgit(act1),
              //getMarkAttendanceWidgit(),
            ],
          ),


        ],
      ),

    );
  }

  getAlreadyMarkedWidgit() {
    return Column(
        children: <Widget>[
          SizedBox(height: 25.0,),
          Container(
            decoration: new ShapeDecoration(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.teal
            ),
            child: Text('\n Visit has been marked, Thank You!',
              textAlign: TextAlign.center,
              style: new TextStyle(color: Colors.white, fontSize: 15.0),),
            width: 220.0,
            height: 70.0,
          ),
          SizedBox(height: 70.0,),
        ]
    );
  }

  getMarkAttendanceWidgit(act1) {
    double h_width = MediaQuery.of(context).size.width*0.5; // screen's 50%
    double f_width = MediaQuery.of(context).size.width*1;
//print('==========================='+act1);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Punch your Visit',
              style: new TextStyle(fontSize: 24.0, color: Colors.teal)),
          SizedBox(height: 15.0),
          getwidget(location_addr1),
        /*  Container(
            color:Colors.teal.withOpacity(0.1),
            child: Column(
              children: <Widget>[
                //SizedBox(height: 5.0),
                InkWell(
                  child: new Text("Refresh location", style: new TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),),
                  onTap: () {
                    print("pushed");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
              ],
            ),
          ),*/


       //   new Divider(color: Colors.black54,),
          ///////////////////////////////----------------generating List of last punch locations-start
       /*   new Container(
           color: Colors.black54,
            width: MediaQuery.of(context).size.width*1.0,
            padding: EdgeInsets.only(top:7.0,bottom:7.0),
            child:Text("My Today's Visits",style: TextStyle(fontSize: 22.0,color: Colors.white),textAlign: TextAlign.center,),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50.0,),
              SizedBox(width: MediaQuery.of(context).size.width*0.02),
              Container(
                width: MediaQuery.of(context).size.width*0.35,
                child:Text('Client',style: TextStyle(color: Colors.orangeAccent,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),

              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.30,
                child:Text('In',style: TextStyle(color: Colors.orangeAccent,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.30,
                child:Text('Out',style: TextStyle(color: Colors.orangeAccent,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
            ],
          ),
          new Container(
            height: MediaQuery.of(context).size.height*.28,
            width: MediaQuery.of(context).size.width*.95,
            color: Colors.white,
            //////////////////////////////////////////////////////////////////////---------------------------------
            child: new FutureBuilder<List<Punch>>(
              future: getSummaryPunch(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Column(children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      snapshot.data[index].client.toString()!=''?new Text(
                                        snapshot.data[index].client.toString(),style: TextStyle(fontWeight: FontWeight.bold),):Center(child:Text('-'),),
                        snapshot.data[index].desc.toString()!=''?InkWell(
                                        child: Text(""+
                                        snapshot.data[index].desc.toString(),style: TextStyle(color: Colors.black54),),
                                      ):Center(),
                                    ],
                                  )),

                              new Container(
                                  width: MediaQuery.of(context).size.width * 0.30,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                       Text(
                                        snapshot.data[index].pi_time.toString(),style:TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 2.0,),
                                      InkWell(
                                        child:Text(""+
                                            snapshot.data[index].pi_loc.toString(),style: TextStyle(color: Colors.black54),),
                                        onTap: () {goToMap(snapshot.data[index].pi_latit,snapshot.data[index].pi_longi.toString());},
                                      ),


                                    ],
                                  )
                              ),
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        new Text(snapshot.data[index].po_time.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                        InkWell(
                          child:Text(""+
                              snapshot.data[index].po_loc.toString(),style: TextStyle(color: Colors.black54),),
                          onTap: () {goToMap(snapshot.data[index].po_latit.toString(),snapshot.data[index].po_longi.toString());},
                        ),
                        ]),


                              ),
                              //Divider(),
                            ],
                          ),

                          Divider(
                            color: Colors.blueGrey.withOpacity(0.25),
                          ),
                        ]);
                      }
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
*/
          ///////////////////////////////----------------generating List of last punch locations-end
        ]);
  }

  LayoutBuilder layoutBuilder() {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: new ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: new IntrinsicHeight(
              child: new Column(
                children: <Widget>[
                  new Container(
                    // A fixed-height child.
                    color: Colors.yellow,
                    height: 120.0,
                    child: Text('hello'),
                  ),
                  new Expanded(
                    // A flexible child that will grow to fit the viewport but
                    // still be at least as big as necessary to fit its contents.
                    child: new Container(
                      color: Colors.blue,
                      height: 120.0,
                      child: Text('hello'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  getwidget(String addrloc) {
    if (addrloc != "PermissionStatus.deniedNeverAsk") {
      return Column(
          children: [

            ButtonTheme(
              minWidth: 100.0,
              height: 40.0,
              child: getPunchInOutButton(),
            ),
            SizedBox(height: 15.0),
            Container(
              color: Colors.teal.withOpacity(0.1),
              padding: EdgeInsets.only(top:7.0,bottom:7.0),
              child:Column(
                      children: <Widget>[
                        Text('You are at: ' + addrloc, textAlign: TextAlign.center,style: new TextStyle(fontSize: 14.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Location not correct?',style: TextStyle(color: Colors.teal),),
                            SizedBox(width: 5.0,),
                            InkWell(
                              child: new Text("Refresh location", style: new TextStyle(
                                  color: Colors.teal, decoration: TextDecoration.underline),),
                              onTap: () {
                                print("pushed");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PunchLocation()),
                                );
                              },
                            ),
                          ],
                        ),


                      ],
    ),

            ),
          ]);
    } else {
      return Column(
          children: [
            Text(
                'Location permission is restricted from app settings, click "Open Settings" to allow permission.',
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 14.0, color: Colors.red)),
            RaisedButton(
              child: Text('Open Settings'),
              onPressed: () {
                //SimplePermissions.openSettings();
              },
            ),
            InkWell(
              child: new Text("Refresh location", style: new TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),),
              onTap: () {
                print("pushed");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PunchLocationSummary()),
                );
              },
            ),

          ]
      );
    }
    return Container(width: 0.0, height: 0.0);
  }

  getPunchInOutButton() {
    print('getPunchInOutButton called **************'+act1);
//return Text('Hello');
    //  act1=getPunchPrefs();
    if (act1 == 'PunchIn') {
      return RaisedButton(
        onPressed: _showDialog,
        child: Text('VISIT IN',
            style: new TextStyle(fontSize: 22.0, color: Colors.white)),
        color: Colors.orangeAccent,

      );
    } else if (act1 == 'PunchOut') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('VISIT OUT',
                style: new TextStyle(fontSize: 22.0, color: Colors.white)),
            color: Colors.orangeAccent,
            onPressed: () {
              sl.startStreaming(1);
              if(list!=null && list.length>0) {
                latit = list[list.length - 1]['latitude'].toString();
                longi = list[list.length - 1]["longitude"].toString();
                location_addr1 = globalstreamlocationaddr;
              }else{
                latit = "0.0";
                longi = "0.0";
                location_addr1 = "";
              }
              PunchInOut('','','', location_addr1, lid, act, orgdir, latit, longi).then((res){

                print("-------------> punch in out");
                //print('Converted Response :: '+res['status'].toString());
                act= res['lid']!='0'?'PunchOut':'PunchIn';
                showInSnackBar(act+' Marked successfully');
                /*Navigator.of(context, rootNavigator: true).pop('dialog');*/
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PunchLocationSummary()),
                );



              }).catchError((onError){
                showInSnackBar('Unable to punch visit');
              });
            },
          ),
          FlatButton(
            padding: EdgeInsets.all(0.0),
            child: new Text("Skip & mark new Punch In >>", style: new TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),textAlign: TextAlign.right),
            onPressed: () {
              print("pushed");
              PunchSkip(lid).then((res){
                if(res=='success') {
                  showInSnackBar('Punch Out Skipped');
//              Navigator.popUntil(context, (_) => !Navigator.canPop(context));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PunchLocation()),
                  );
                }
                else
                  showInSnackBar('Unable to skip Punch Out');
              });

            },
          ),
        ],
      );
    }
  }


  Text getText(String addrloc) {
    if (addrloc != "PermissionStatus.deniedNeverAsk") {
      return Text('You are at: ' + addrloc, textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 14.0));
    } else {
      return new Text(
          'Location is restricted from app settings, click here to allow location permission and refresh',
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 14.0, color: Colors.red));
    }
  }


  _showDialog() async {
    sl.startStreaming(2);
    setState(() {
      if(list!=null && list.length>0) {
        latit = list[list.length - 1]['latitude'].toString();
        longi = list[list.length - 1]["longitude"].toString();
        location_addr1 = globalstreamlocationaddr;
      }else{
        latit = "0.0";
        longi = "0.0";
        location_addr1 = "";
      }
    });
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          height: MediaQuery.of(context).size.height*0.20,
          child: Column(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  controller: client_name,
                  decoration: new InputDecoration(
                      labelText: 'Client ', hintText: 'Client Name (Optional)'),
                ),
              ),
              new Expanded(
                child: new TextField(
                  maxLines: 2,
                  autofocus: true,
                  controller: comments,
                  decoration: new InputDecoration(
                      labelText: 'Comments ', hintText: 'Comments (Optional)'),
                ),
              ),
              SizedBox(height: 4.0,),

            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              shape: Border.all(color: Colors.black54),
              child: const Text('CANCEL',style: TextStyle(color: Colors.black),),
              onPressed: () {
                comments.text='';
                client_name.text='';
                Navigator.of(context, rootNavigator: true).pop();
              }),
          new RaisedButton(
              child: const Text('PUNCH',style: TextStyle(color: Colors.white),),
              color: Colors.orangeAccent,
              onPressed: () {
                //  Loc lock = new Loc();
                //   location_addr1 = await lock.initPlatformState();
                if(_isButtonDisabled)
                  return null;

                Navigator.of(context, rootNavigator: true).pop('dialog');
                setState(() {
                  _isButtonDisabled=true;
                });
                PunchInOut(comments.text,client_name.text,empid, location_addr1, lid, act, orgdir, latit, longi).then((res){

                  print("-------------> punch in out");
                  //print('Converted Response :: '+res['status'].toString());
                  act= res['lid']!='0'?'PunchOut':'PunchIn';
               //   showInSnackBar(act+' Marked successfully');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PunchLocationSummary()),
                  );



                }).catchError((onError){
                  showInSnackBar('Unable to punch visit');
                });

              })
        ],
      ),
    );
  }



  getPunchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('getPunchPrefs called: new lid- '+ prefs.getString('lid').toString());
    return prefs.getString('lid');
  }


/////////////////////futere method dor getting today's punched liist-start

/////////////////////futere method dor getting today's punched liist-close

}

