// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:multi_shift/services/services.dart';
import 'package:simple_share/simple_share.dart';
import 'generatepdf.dart';
import 'outside_label.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'drawer.dart';
import 'attendance_detail.dart';
import 'globals.dart';
// This app is a stateful, it tracks the user's current choice.
class EmployeeWise_att extends StatefulWidget {
  @override
  _EmployeeWise_att createState() => _EmployeeWise_att();
}
//TextEditingController today;
class _EmployeeWise_att extends State<EmployeeWise_att> with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _orgName="";
  String emp='0';
  String empname= '';
  bool filests = false;
  String countP='0',countA='0',countL='0',countE='0';
//  var formatter = new DateFormat('dd-MMM-yyyy');
  bool res = true;
  Future<List<Attn>> _listFuture1, _listFuture2,_listFuture3,_listFuture4;
  List presentlist= new List(), absentlist= new List(), latecommerlist= new List(), earlyleaverlist= new List();
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
 //   today = new TextEditingController();
   // today.text = formatter.format(DateTime.now());
    setAlldata();
  }

  setAlldata(){
    _listFuture1 = getEmpHistoryOf30('present',emp);
    _listFuture2 = getEmpHistoryOf30('absent',emp);
    _listFuture3 = getEmpHistoryOf30('latecomings',emp);
    _listFuture4 = getEmpHistoryOf30('earlyleavings',emp);

    _listFuture1.then((data) async{
      setState(() {
        presentlist = data;
        countP = data.length.toString();
      });
    });

    _listFuture2.then((data) async{
      setState(() {
        absentlist = data;
        countA = data.length.toString();
      });
    });

    _listFuture3.then((data) async{
      setState(() {
        latecommerlist = data;
        countL = data.length.toString();
      });
    });

    _listFuture4.then((data) async{
      setState(() {
        earlyleaverlist = data;
        countE= data.length.toString();
      });
    });
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
          SizedBox(height:3.0),
          new Container(
            child: Center(child:Text("Employee Wise Attendance",style: TextStyle(fontSize: 22.0,color: appBarColor(),),),),
          ),
          Divider(height: 1.5,color: Colors.black87,),
          Row(
            children: <Widget>[
              Expanded(child: getEmployee_DD()),
                   Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child:(emp != '0')?Container(
                    color: Colors.white,
                    height: 65,
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: new Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          (presentlist.length > 0 || absentlist.length > 0 || latecommerlist.length > 0 || earlyleaverlist.length > 0)?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height:  65,
                              ),
                              Container(
                                //padding: EdgeInsets.only(left: 5.0),
                                child: InkWell(
                                  child: Text('CSV',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blueAccent,
                                      fontSize: 16,
                                      //fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onTap: () {
                                    //openFile(filepath);
                                    if (mounted) {
                                      setState(() {
                                        filests = true;
                                      });
                                    }
                                    getCsvAlldata(presentlist, absentlist, latecommerlist, earlyleaverlist,
                                          'Employee_Wise_Report', 'emp')
                                          .then((res) {
                                        print('snapshot.data');

                                        if (mounted) {
                                          setState(() {
                                            filests=false;
                                          });
                                        }
                                        // showInSnackBar('CSV has been saved in file storage in ubiattendance_files/Department_Report_'+today.text+'.csv');
                                        dialogwidget(
                                            "CSV has been saved in internal storage in ubishift_files/Employee_Wise_Report" +
                                                ".csv", res);
                                      }
                                      );
                                  },
                                ),
                              ),
                              SizedBox(
                                width:6,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 5.0),
                                child: InkWell(
                                  child: Text('PDF',
                                    style: TextStyle(
                                      decoration:
                                      TextDecoration
                                          .underline,
                                      color: Colors
                                          .blueAccent,
                                      fontSize: 16,),
                                  ),
                                  onTap: () {
                                    /*final uri = Uri.file('/storage/emulated/0/ubiattendance_files/Employee_Wise_Report_14-Jun-2019.pdf');
                                    SimpleShare.share(
                                        uri: uri.toString(),
                                        title: "Share my file",
                                        msg: "My message");*/
                                    if (mounted) {
                                      setState(() {
                                        filests = true;
                                      });
                                    }
                                    CreateEmployeeWisepdf(
                                        presentlist, absentlist, latecommerlist, earlyleaverlist, 'Employee Report ' + empname,
                                        'Employee_Wise_Report', 'employeewise')
                                        .then((res) {
                                      if(mounted) {
                                        setState(() {
                                          filests =
                                          false;
                                          // OpenFile.open("/sdcard/example.txt");
                                        });
                                      }
                                      dialogwidget(
                                          'PDF has been saved in internal storage in ubishift_files/Employee_Wise_Report'+
                                              '.pdf',
                                          res);
                                      // showInSnackBar('PDF has been saved in file storage in ubiattendance_files/'+'Department_Report_'+today.text+'.pdf');
                                    });
                                  },
                                ),
                              ),
                            ],
                          ):Center(
//                              child: Padding(
//                                padding: const EdgeInsets.only(top:12.0),
//                                child: Text("No CSV/Pdf generated", textAlign: TextAlign.center,),
//                              )
                          )
                        ]
                    )
                ):Center()
              )

            ],
          ),
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
                  text: 'Late \nComing',
                ),
                new Tab(
                  text: 'Early \nLeaving',
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
                width: MediaQuery.of(context).size.width*0.50,
                child:Text('        Date',style: TextStyle(color: appBarColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),

              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.20,
                child:Text('Time In',style: TextStyle(color: appBarColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.24,
                child:Text('Time Out',style: TextStyle(color: appBarColor(),fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
            ],
          ),
          new Divider(height: 1.0,),
          res==true?new Container(
            height: MediaQuery.of(context).size.height*1,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                new Container(
                  height: MediaQuery.of(context).size.height*0.30,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.55,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getEmpHistoryOf30('present',emp),
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
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.4,
                                                child:Text(Formatdate(snapshot.data[index].Date)
                                                    .toString(), style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0),),
                                              ),
                                              SizedBox(height: 10.0,),
                                              InkWell(
                                                child: Container(
                                                  height: 22.0,
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
                                      onTap: (){
//                                        showInSnackBar(snapshot.data[index].EmployeeId+" "+snapshot.data[index].Date+' '+snapshot.data[index].Name);

                                        /*Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => AttendanceDetail(snapshot.data[index].EmployeeId,snapshot.data[index].Date,snapshot.data[index].Name)),
                                        );*/
                                        //showInSnackBar(snapshot.data[index].Date+" "+snapshot.data[index].EmployeeId);
                                      },
                                    );
                                  }
                              );
                            }else{
                              return new Container(
                                  height: MediaQuery.of(context).size.height*0.30,
                                  child:Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*1,
                                      color: Colors.teal.withOpacity(0.1),
                                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                      child:Text("No present in last 30 days ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                    ),
                                  )
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            //return new Text("Unable to connect server");
                              return new Text("${snapshot.error}");
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

                  height: MediaQuery.of(context).size.height*0.30,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.55,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getEmpHistoryOf30('absent',emp),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: <Widget>[
                                        SizedBox(height: 40.0,),
                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.40,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Text(Formatdate(snapshot.data[index].Date)
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
                                      ],

                                    );
                                  }
                              );
                            }else{
                              return new Container(
                                  height: MediaQuery.of(context).size.height*0.30,
                                  child:Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*1,
                                      color: Colors.teal.withOpacity(0.1),
                                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                      child:Text("No absent in last 30 days ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                    ),
                                  )
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                            // return new Text("${snapshot.error}");
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

                  height: MediaQuery.of(context).size.height*0.30,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.55,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getEmpHistoryOf30('latecomings',emp),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
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
                                                    SizedBox(height: 25.0,),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width*0.4,
                                                      child:Text(Formatdate(snapshot.data[index].Date)
                                                          .toString(), style: TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16.0),),
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
                              return new Container(
                                  height: MediaQuery.of(context).size.height*0.30,
                                  child:Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*1,
                                      color: Colors.teal.withOpacity(0.1),
                                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                      child:Text("No late comings in last 30 days ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                    ),
                                  )
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


                  height: MediaQuery.of(context).size.height*0.30,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.55,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getEmpHistoryOf30('earlyleavings',emp),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
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
                                                    SizedBox(height: 25.0,),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width*0.4,
                                                      child:Text(Formatdate(snapshot.data[index].Date)
                                                          .toString(), style: TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16.0),),
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
                              return new Container(
                                  height: MediaQuery.of(context).size.height*0.25,
                                  child:Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*1,
                                      color: Colors.teal.withOpacity(0.1),
                                      padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                      child:Text("No early leavings in last 30 days",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                    ),
                                  )
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
          ):Container(
            height: MediaQuery.of(context).size.height*0.25,
            child:Center(
              child: Text('No Data Available'),
            ),
          ),
        ],
      ),
    );
  }

  Widget getEmployee_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
        future: getEmployeesList(0),// with -select- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              return new Container(
                //    width: MediaQuery.of(context).size.width*.45,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Select an Employee',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ), // icon is 48px widget.
                    ),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: new DropdownButton<String>(
                      isDense: true,
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.black
                      ),
                      value: emp,
                      onChanged: (String newValue) {
                        for(int i=0;i<snapshot.data.length;i++)
                        {
                          if(snapshot.data[i]['Id'].toString()==newValue)
                          {
                            setState(() {
                              empname = snapshot.data[i]['Name'].toString();
                            });
                            break;
                          }
                          print(i);
                        }
                          setState(() {
                            emp = newValue;
                            if(res = true) {
                              //getCount();
                              setAlldata();
                            }else{
                              print('state set----');
                              countP='0';
                              countA='0';
                              countE='0';
                              countL='0';
                            }
                          });
                      },
                      items: snapshot.data.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["Id"].toString(),
                          child: new SizedBox(
                              width: MediaQuery.of(context).size.width*.77,
                              child: map["Code"]!=''?new Text(map["Name"]+' ('+map["Code"]+')'):
                                new Text(map["Name"],)),
                        );
                      }).toList(),

                    ),
                  ),
                ),
              );
            }
            catch(e){
              return Text("EX: Unable to fetch employees");

            }
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return new Text("ER: Unable to fetch employees");
          }
          // return loader();
          return new Center(child: SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2.2,),
            height: 20.0,
            width: 20.0,
          ),);
        });
  }
  dialogwidget(msg, filename) {
    showDialog(
        context: context,
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
