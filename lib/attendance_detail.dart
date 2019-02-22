// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:multi_shift/services/services.dart';
import 'outside_label.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'globals.dart';
// This app is a stateful, it tracks the user's current choice.
class AttendanceDetail extends StatefulWidget {
  String empId,Date,Name;
  @override
  AttendanceDetail(eId,aDate,aName){
    empId=eId;
    Date=aDate;
    Name=aName;
  }
  @override
  _AttendanceDetail createState() => _AttendanceDetail(empId,Date,Name);
}

class _AttendanceDetail extends State<AttendanceDetail> with SingleTickerProviderStateMixin {
  String empId,Date,Name;
  @override
  _AttendanceDetail(eId,aDate,aName){
    empId=eId;
    Date=aDate;
    Name=aName;
  }
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _orgName;
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
          SizedBox(height:3.0),
          new Container(
            child: Center(child:Text(Name.toString(),style: TextStyle(fontSize: 22.0,color: Colors.black54,),),),
          ),
          new Container(
            child: Center(child:Text('( '+Formatdate(Date.toString())+' )',style: TextStyle(fontSize: 17.0,color: Colors.black54,),),),
          ),
          Divider(),

          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.46,
                child:Text('  Location',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('   Time In',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('Time Out',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
            ],
          ),
          new Divider(height: 1.0,color: Colors.black45,),
          new Container(
            height: MediaQuery.of(context).size.height*0.60,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                new Container(
                  height: MediaQuery.of(context).size.height*0.6,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.60,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getAttnDetail('present',empId,Date),
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
                                          Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.45,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
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
                                        showInSnackBar(snapshot.data[index].Date+" "+snapshot.data[index].EmployeeId);
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
                ///////////////////TAB 4 Ends
              ],
            ),
          ),
        ],
      ),
    );
  }
}
