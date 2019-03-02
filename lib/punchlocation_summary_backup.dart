import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'home.dart';
import 'globals.dart' as globals;
import 'package:multi_shift/services/services.dart';
import 'punchlocation.dart';
import 'reports.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'settings.dart';
import 'globals.dart';

//import 'package:intl/intl.dart';


void main() => runApp(new PunchLocationSummary());

class PunchLocationSummary extends StatefulWidget {
  @override
  _PunchLocationSummary createState() => _PunchLocationSummary();
}

class _PunchLocationSummary extends State<PunchLocationSummary> {
  String fname="";
  String lname="";
  String desination="";
  String profile="";
  String org_name="";
  String admin_sts='0';
  int _currentIndex = 1;
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
      admin_sts = prefs.getString('sstatus') ?? '0';
      org_name = prefs.getString('org_name') ?? '';
    });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
              icon: Icon(Icons.settings,),
              title: Text('Settings')
          )
        ],
      ),
      endDrawer: new AppDrawer(),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PunchLocation()),
          );
        },
        tooltip: 'Request TimeOff',
        child: new Icon(Icons.add),
      ),

      body: getWidgets(context),
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
  int id=0;
  User({this.AttendanceDate,this.thours,this.id,this.TimeOut,this.TimeIn,this.bhour,this.EntryImage,this.checkInLoc,this.ExitImage,this.CheckOutLoc,this.latit_in,this.longi_in,this.latit_out,this.longi_out});
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
            child:Text("My Today's Visits",
                style: new TextStyle(fontSize: 22.0, color: appBarColor(),)),
          ),
        ),
        Divider(color: Colors.black54,height: 1.5,),
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
            SizedBox(width: 5.0,),
            Container(
              width: MediaQuery.of(context).size.width*0.30,
              child:Text('In',style: TextStyle(color: Colors.orangeAccent,fontWeight:FontWeight.bold,fontSize: 16.0),),
            ),
            SizedBox(height: 50.0,),
            SizedBox(width: 3.0,),
            Container(
              width: MediaQuery.of(context).size.width*0.30,
              child:Text('Out',style: TextStyle(color: Colors.orangeAccent,fontWeight:FontWeight.bold,fontSize: 16.0),),
            ),
          ],
        ),
        Divider(),

        Container(
            height: MediaQuery.of(context).size.height*0.60,
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
                            SizedBox(width: 5.0,),
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
        ),
      ]
  );
}