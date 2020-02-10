// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:multi_shift/generatepdf.dart';
import 'package:multi_shift/services/services.dart';
import 'package:simple_share/simple_share.dart';
import 'outside_label.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'attendance_detail.dart';
import 'globals.dart';
// This app is a stateful, it tracks the user's current choice.
class TodayAttendance extends StatefulWidget {
  @override
  _TodayAttendance createState() => _TodayAttendance();
}

class _TodayAttendance extends State<TodayAttendance> with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _orgName="";
  String trialstatus = "";
  bool filests = false;
  String todaydate = "";
  List<Map<String,String>> chartData;
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName= prefs.getString('org_name') ?? '';
    });
  }
  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
    getOrgName();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(_orgName, style: new TextStyle(fontSize: 20.0)),
        backgroundColor: appBarColor(),
      ),
      endDrawer: new AppDrawer(),
      body: new ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          SizedBox(height:8.0),
          new Container(
            child: Center(child:Text("Today's Attendance",style: TextStyle(fontSize: 22.0,color: appBarColor(),),),),
          ),
          Divider(height:1.5,color: Colors.black54,),
          new Container(
            padding: EdgeInsets.all(0.1),
            margin: EdgeInsets.all(0.1),
            child: new ListTile(
              title: new SizedBox(height: MediaQuery.of(context).size.height*0.30,

                child: new FutureBuilder<List<Map<String,String>>>(
                    future: getChartDataToday(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length > 0) {
                          return new PieOutsideLabelChart.withRandomData(snapshot.data);
                        }
                      }
                      return new Center( child: CircularProgressIndicator());
                    }
                ),

                //  child: new PieOutsideLabelChart.withRandomData(),

                width: MediaQuery.of(context).size.width*1.0,),
            ),
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Early Leavers(EL)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
              Text('Late Comers(LC)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
              Text('Absent(A)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
              Text('Present(P)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
            ],
          ),
          Divider(),
          new Container(
            decoration: new BoxDecoration(color: Colors.black54),
            child: new TabBar(
              indicator: BoxDecoration(color: Colors.orangeAccent,),
              controller: _controller,
              tabs: [
                new Tab(
                  text: 'Present',
                ),
                new Tab(
                  text: 'Absent',
                ),
                new Tab(
                  text: 'Late \nComers',
                ),
                new Tab(
                  text: 'Early \nLeavers',
                ),
              ],
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.46,
                child:Text('  Name',style: TextStyle(color: appBarColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('Time In',style: TextStyle(color: appBarColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('Time Out',style: TextStyle(color: appBarColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
            ],
          ),
          new Divider(height: 1.0,color: Colors.black45,),
          new Container(
            height: MediaQuery.of(context).size.height*0.30,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                new Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.30,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getTodaysAttn('present'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new GestureDetector(
                                      child: Column( children: <Widget>[
                                        (index == 0)
                                            ? Row(children: <Widget>[
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          Container(
                                            padding:
                                            EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              "Total Present: " +
                                                  snapshot.data.length
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding:
                                            EdgeInsets.only(left: 15.0),
                                            child: InkWell(
                                              child: Text(
                                                'CSV',
                                                style: TextStyle(
                                                    decoration:
                                                    TextDecoration
                                                        .underline,
                                                    color:
                                                    Colors.blueAccent),
                                              ),
                                              onTap: () {
                                                if (trialstatus != '2') {
                                                  setState(() {
                                                    filests = true;
                                                  });

                                                  getCsv(
                                                      snapshot.data,
                                                      'Today_present_$todaydate',
                                                      'present')
                                                      .then((res) {
                                                    setState(() {
                                                      filests = false;
                                                    });
                                                    dialogwidget(
                                                        'CSV has been saved in internal storage in ubishift_files/Today_present_$todaydate',
                                                        res);
                                                  });
                                                } else {
                                                  showInSnackBar(
                                                      "For CSV please Buy Now");
                                                }
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding:
                                            EdgeInsets.only(left: 5.0),
                                            child: InkWell(
                                              child: Text(
                                                'PDF',
                                                style: TextStyle(
                                                    decoration:
                                                    TextDecoration
                                                        .underline,
                                                    color:
                                                    Colors.blueAccent),
                                              ),
                                              onTap: () {
                                                if (trialstatus != '2') {
                                                  setState(() {
                                                    filests = true;
                                                  });
                                                  CreateDeptpdf(
                                                      snapshot.data,
                                                      'Present Employees($todaydate)',
                                                      snapshot
                                                          .data.length
                                                          .toString(),
                                                      'Today_present_$todaydate',
                                                      'present')
                                                      .then((res) {
                                                    setState(() {
                                                      filests = false;
                                                    });
                                                    dialogwidget(
                                                        'PDF has been saved in internal storage in ubishift_files/Today_present_$todaydate.pdf',
                                                        res);
                                                  });
                                                } else {
                                                  showInSnackBar(
                                                      "For PDF please Buy Now");
                                                }
                                              },
                                            ),
                                          ),
                                        ]): new Center(),
                                        (index == 0)
                                            ? Divider(): new Center(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(height: 50.0,),
                                            Column(
                                              children: <Widget>[

                                                Container(
                                                  width: MediaQuery.of(context).size.width*0.4,
                                                  child:Text(snapshot.data[index].Name
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
                                                      MaterialPageRoute(builder: (context) => AttendanceDetail(snapshot.data[index].EmployeeId,snapshot.data[index].Date,snapshot.data[index].Name)),
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
                                      ]),
                                      onTap: (){
                                        /*  Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => AttendanceDetail(snapshot.data[index].EmployeeId,snapshot.data[index].Date,snapshot.data[index].Name)),
                                        );*/
                                        //showInSnackBar(snapshot.data[index].Date+" "+snapshot.data[index].EmployeeId);
                                      },
                                    );
                                  }
                              );
                            }else{
                              return new Center(
                                child:Text("No one is present today "),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Center(child:Text("Unable to connect server"));
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),
                ),
                //////////////TABB 2 Start
                new Container(

                  height: MediaQuery.of(context).size.height*0.3,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.3,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getTodaysAttn('absent'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column( children: <Widget>[
                                      (index == 0)?Row(children: <Widget>[
                                        SizedBox(
                                          height: 25.0,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 5.0),
                                          child: Text(
                                            "Total Absent: " +
                                                snapshot.data.length
                                                    .toString(),
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 5.0),
                                          child: InkWell(
                                            child: Text(
                                              'CSV',
                                              style: TextStyle(
                                                  decoration:
                                                  TextDecoration
                                                      .underline,
                                                  color: Colors
                                                      .blueAccent),
                                            ),
                                            onTap: () {
                                              if (trialstatus != '2') {
                                                setState(() {
                                                  filests = true;
                                                });

                                                getCsv(
                                                    snapshot.data,
                                                    'Today_absent_$todaydate',
                                                    'absent')
                                                    .then((res) {
                                                  setState(() {
                                                    filests = false;
                                                  });
                                                  dialogwidget(
                                                      'CSV has been saved in internal storage in ubishift_files/Today_absent_$todaydate',
                                                      res);
                                                });
                                              } else {
                                                showInSnackBar(
                                                    "For CSV please Buy Now");
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 5.0),
                                          child: InkWell(
                                            child: Text(
                                              'PDF',
                                              style: TextStyle(
                                                  decoration:
                                                  TextDecoration
                                                      .underline,
                                                  color: Colors
                                                      .blueAccent),
                                            ),
                                            onTap: () {
                                              if (trialstatus != '2') {
                                                setState(() {
                                                  filests = true;
                                                });
                                                CreateDeptpdf(
                                                    snapshot.data,
                                                    'Absent Employees($todaydate)',
                                                    snapshot
                                                        .data.length
                                                        .toString(),
                                                    'Today_absent_$todaydate',
                                                    'absent')
                                                    .then((res) {
                                                  setState(() {
                                                    filests = false;
                                                  });
                                                  dialogwidget(
                                                      'PDF has been saved in internal storage in ubishift_files/Today_absent_$todaydate.pdf',
                                                      res);
                                                });
                                              } else {
                                                showInSnackBar(
                                                    "For CSV please Buy Now");
                                              }
                                            },
                                          ),
                                        ),
                                      ]): new Center(),
                                      (index == 0)
                                          ? Divider(
                                        color: Colors.black26,
                                      )
                                          : new Center(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround,
                                        children: <Widget>[
                                          SizedBox(height: 40.0,),
                                          Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.46,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                Text(snapshot.data[index].Name
                                                    .toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0),),
                                              ],
                                            ),
                                          ),

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
                                                      .toString()),
                                                ],
                                              )

                                          ),
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
                                                      .toString()),
                                                ],
                                              )

                                          ),
                                          Divider(color: Colors.black26,),
                                        ],

                                      )],
                                    );
                                  }
                              );
                            }else{
                              return new Center(
                                child:Text("No one is absent today"),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),

                ),

                /////////////TAB 2 Ends



                /////////////TAB 3 STARTS

                new Container(

                  height: MediaQuery.of(context).size.height*0.3,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.3,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getTodaysAttn('latecomings'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                          (index == 0)? Row(children: <Widget>[
                                            SizedBox(
                                              height: 25.0,
                                            ),
                                            Container(
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                "Total Latecomings: " +
                                                    snapshot.data.length
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              child: InkWell(
                                                child: Text(
                                                  'CSV',
                                                  style: TextStyle(
                                                      decoration:
                                                      TextDecoration
                                                          .underline,
                                                      color:
                                                      Colors.blueAccent),
                                                ),
                                                onTap: () {
                                                  if (trialstatus != '2') {
                                                    setState(() {
                                                      filests = true;
                                                    });

                                                    getCsv(
                                                        snapshot.data,
                                                        'Today_latecomings_$todaydate',
                                                        'late')
                                                        .then((res) {
                                                      setState(() {
                                                        filests = false;
                                                      });
                                                      dialogwidget(
                                                          'CSV has been saved in internal storage in ubishift_files/Today_latecomings_$todaydate',
                                                          res);
                                                    });
                                                  } else {
                                                    showInSnackBar(
                                                        "For CSV please Buy Now");
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              child: InkWell(
                                                child: Text(
                                                  'PDF',
                                                  style: TextStyle(
                                                      decoration:
                                                      TextDecoration
                                                          .underline,
                                                      color:
                                                      Colors.blueAccent),
                                                ),
                                                onTap: () {
                                                  if (trialstatus != '2') {
                                                    setState(() {
                                                      filests = true;
                                                    });
                                                    CreateDeptpdf(
                                                        snapshot.data,
                                                        'Latecomings Employees($todaydate)',
                                                        snapshot.data.length
                                                            .toString(),
                                                        'Today_latecomings_$todaydate',
                                                        'late')
                                                        .then((res) {
                                                      setState(() {
                                                        filests = false;
                                                      });
                                                      dialogwidget(
                                                          'PDF has been saved in internal storage in ubishift_files/Today_latecomings_$todaydate.pdf',
                                                          res);
                                                    });
                                                  } else {
                                                    showInSnackBar(
                                                        "For CSV please Buy Now");
                                                  }
                                                },
                                              ),
                                            ),
                                          ]): new Center(),
                                    (index == 0)
                                    ? Divider(
                                    color: Colors.black26,
                                    )
                                        : new Center(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.46,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

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
                                          Divider(color: Colors.black26,),
                                        ]);}
                              );
                            }else{
                              return new Center(
                                child:Text("No one is late today"),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),

                ),
                /////////TAB 3 ENDS


                /////////TAB 4 STARTS
                new Container(


                  height: MediaQuery.of(context).size.height*0.3,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.3,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getTodaysAttn('earlyleavings'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                        (index == 0)
                                        ? Row(children: <Widget>[
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                      Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          "Total Early leavings: " +
                                              snapshot.data.length
                                                  .toString(),
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: InkWell(
                                          child: Text(
                                            'CSV',
                                            style: TextStyle(
                                                decoration:
                                                TextDecoration
                                                    .underline,
                                                color:
                                                Colors.blueAccent),
                                          ),
                                          onTap: () {
                                            if (trialstatus != '2') {
                                              setState(() {
                                                filests = true;
                                              });

                                              getCsv(
                                                  snapshot.data,
                                                  'Today_earlyleavings_$todaydate',
                                                  'early')
                                                  .then((res) {
                                                setState(() {
                                                  filests = false;
                                                });
                                                dialogwidget(
                                                    'CSV has been saved in internal storage in ubishift_files/Today_earlyleavings_$todaydate',
                                                    res);
                                              });
                                            } else {
                                              showInSnackBar(
                                                  "For CSV please Buy Now");
                                            }
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding:
                                        EdgeInsets.only(left: 5.0),
                                        child: InkWell(
                                          child: Text(
                                            'PDF',
                                            style: TextStyle(
                                                decoration:
                                                TextDecoration
                                                    .underline,
                                                color:
                                                Colors.blueAccent),
                                          ),
                                          onTap: () {
                                            if (trialstatus != '2') {

                                              setState(() {
                                                filests = true;
                                              });
                                              CreateDeptpdf(
                                                  snapshot.data,
                                                  'Earlyleavings Employees($todaydate)',
                                                  snapshot.data.length
                                                      .toString(),
                                                  'Today_earlyleavings_$todaydate',
                                                  'early')
                                                  .then((res) {
                                                setState(() {
                                                  filests = false;
                                                });
                                                dialogwidget(
                                                    'PDF has been saved in internal storage in ubishift_files/Today_earlyleavings_$todaydate.pdf',
                                                    res);
                                              });
                                            } else {
                                              showInSnackBar(
                                                  "For CSV please Buy Now");
                                            }
                                          },
                                        ),
                                      ),
                                    ])
                                        : new Center(),
                                    (index == 0)
                                    ? Divider(
                                    color: Colors.black26,
                                    )
                                        : new Center(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.46,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

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
                                          Divider(color: Colors.black26,),
                                        ]);}
                              );
                            }else{
                              return new Center(
                                child:Text("No early leavers today"),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),
                ),
                ///////////////////TAB 4 Ends
              ],
            ),
          ),
        ],
      ),
    );
  }
  dialogwidget(msg, filename) {
    showDialog(
        context: context,
        // ignore: deprecated_member_use
        child: new AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('Later'),
              shape: Border.all(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            RaisedButton(
              child: Text(
                'Share File',
                style: TextStyle(color: Colors.white),
              ),
              color: appBarColor(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                final uri = Uri.file(filename);
                SimpleShare.share(
                    uri: uri.toString(),
                    title: "Ubishift Report",
                    msg: "Ubishift Report");
              },
            ),
          ],
        ));
  }
}
