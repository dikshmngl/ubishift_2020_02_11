import 'package:flutter/material.dart';
import 'package:multi_shift/services/fetch_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Bottomnavigationbar.dart';
import 'askregister.dart';
import 'package:multi_shift/services/gethome.dart';
import 'package:multi_shift/services/saveimage.dart';
import 'package:multi_shift/model/timeinout.dart';
import 'attendance_summary.dart';
import 'punchlocation.dart';
import 'drawer.dart';
import 'timeoff_summary.dart';
import 'package:multi_shift/services/services.dart';
import 'leave.dart';
import 'package:multi_shift/services/newservices.dart';
import 'leave_summary.dart';
import 'home.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart';
import 'settings.dart';
import 'reports.dart';
import 'services/services.dart';

//import 'openCameraInActivity.dart';
//import 'package:camera/camera.dart';
//import 'package:connectivity/connectivity.dart';

// This app is a stateful, it tracks the user's current choice.
class MarkMyAttendance extends StatefulWidget {
  @override
  _MarkMyAttendance createState() => _MarkMyAttendance();
}

class _MarkMyAttendance extends State<MarkMyAttendance> {
  StreamLocation sl = new StreamLocation();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /*var _defaultimage =
      new NetworkImage("http://ubishift.ubihrm.com/assets/img/avatar.png");*/
  var profileimage;
  bool _checkLoaded = true;
  int _currentIndex = 1;
  String userpwd = "new";
  String newpwd = "new";
  int Is_Delete = 0;
  bool _visible = true;
  String location_addr = "";
  String location_addr1 = "";
  String streamlocationaddr = "";
  String admin_sts = '0';
  String mail_varified = '1';
  String lat = "";
  String long = "";
  String act = "";
  String act1 = "";
  int alertdialogcount = 0;
  Timer timer;
  Timer timer1;
  int response;
  final Widget removedChild = Center();
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
      desinationId = "",
      profile,
      latit = "",
      longi = "";
  String aid = "";
  String shiftId = "";
  List<Widget> widgets;

  @override
  void initState() {
    super.initState();

    initPlatformState();
    setLocationAddress();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  startTimer() {
    const fiveSec = const Duration(seconds: 5);
    int count = 0;
    timer = new Timer.periodic(fiveSec, (Timer t) {
      //print("timmer is running");
      count++;
      //print("timer counter" + count.toString());
      setLocationAddress();
      if (stopstreamingstatus) {
        t.cancel();
        //print("timer canceled");
      }
    });
  }

  startTimer1() {
    const fiveSec = const Duration(seconds: 1);
    int count = 0;
    timer1 = new Timer.periodic(fiveSec, (Timer t) {
      print("timmer is running");
    });
  }

  setLocationAddress() async {

    setState(() {
      streamlocationaddr = globalstreamlocationaddr;
      if (list != null && list.length > 0) {
        lat = list[list.length - 1].latitude.toString();
        long = list[list.length - 1].longitude.toString();
        if (streamlocationaddr == '') {
          streamlocationaddr = lat + ", " + long;
        }
      }
      //print("home addr" + streamlocationaddr);
      //print(lat + ", " + long);
      //print(stopstreamingstatus.toString());
    });
  }

  launchMap(String lat, String long) async {
    String url = "https://maps.google.com/?q=" + lat + "," + long;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //print('Could not launch $url');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    // await availableCameras();
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    desinationId = prefs.getString('desinationId') ?? '';
    response = prefs.getInt('response') ?? 0;

    if (response == 1) {
      Loc lock = new Loc();
      location_addr = await lock.initPlatformState();
      Home ho = new Home();
      act = await ho.checkTimeIn(empid, orgdir);
      ho.managePermission(empid, orgdir, desinationId);
      // //print(act);
      ////print("this is-----> "+act);
      //print("this is main "+location_addr);
      setState(() {
        Is_Delete = prefs.getInt('Is_Delete') ?? 0;
        newpwd = prefs.getString('newpwd') ?? "";
        userpwd = prefs.getString('usrpwd') ?? "";
        print("New pwd" + newpwd + "  User ped" + userpwd);
        location_addr1 = location_addr;
        admin_sts = prefs.getString('sstatus').toString() ?? '0';
        mail_varified = prefs.getString('mail_varified').toString() ?? '0';
        alertdialogcount = globalalertcount;
        response = prefs.getInt('response') ?? 0;
        fname = prefs.getString('fname') ?? '';
        lname = prefs.getString('lname') ?? '';
        empid = prefs.getString('empid') ?? '';
        email = prefs.getString('email') ?? '';
        status = prefs.getString('status') ?? '';
        orgid = prefs.getString('orgid') ?? '';
        orgdir = prefs.getString('orgdir') ?? '';
        org_name = prefs.getString('org_name') ?? '';
        desination = prefs.getString('desination') ?? '';
        profile = prefs.getString('profile') ?? '';
        profileimage = new NetworkImage(profile);
        // //print("1-"+profile);
        profileimage.resolve(new ImageConfiguration()).addListener(ImageStreamListener((_, __) {
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        }));
        // //print("2-"+_checkLoaded.toString());
        latit = prefs.getString('latit') ?? '';
        longi = prefs.getString('longi') ?? '';
        aid = prefs.getString('aid') ?? "";
        shiftId = prefs.getString('shiftId') ?? "";
        //print("this is set state "+location_addr1);
        act1 = act;
        //print(act1);
        streamlocationaddr = globalstreamlocationaddr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Text(Is_Delete.toString());
    (mail_varified == '0' && alertdialogcount == 0 && admin_sts == '1')
        ? Future.delayed(Duration.zero, () => _showAlert(context))
        : "";

    return (response == 0 || Is_Delete != 0)
        ? new AskRegisterationPage()
        : getmainhomewidget(); // userpwd!=newpwd ||

    /* return MaterialApp(
      home: (response==0) ? new AskRegisterationPage() : getmainhomewidget(),
    );*/
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(
      value,
      textAlign: TextAlign.center,
    ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getmainhomewidget() {
    return new WillPopScope(
        onWillPop: () async => true,
        child: new Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(org_name, style: new TextStyle(fontSize: 20.0)),
              ],
            ),
            automaticallyImplyLeading: false,
            backgroundColor: appBarColor(),
            leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },),
            // backgroundColor: Color.fromARGB(255,63,163,128),
          ),

          //bottomSheet: getQuickLinksWidget(),
          persistentFooterButtons: <Widget>[
           quickLinkList1(),


          ],

          bottomNavigationBar:  Bottomnavigationbar(),

          endDrawer: new AppDrawer(),
          body: (act1 == '') ? Center(child: loader()) : checkalreadylogin(),
        ));
  }

  checkalreadylogin() {
    ////print("---->"+response.toString());
    if (response == 1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          (streamlocationaddr != '') ? mainbodyWidget() : refreshPageWidgit(),
          underdevelopment()
        ],
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AskRegisterationPage()),
        (Route<dynamic> route) => false,
      );
    }

    /* if(userpwd!=newpwd){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AskRegisterationPage()),
            (Route<dynamic> route) => false,
      );
    }*/
  }

  refreshPageWidgit() {
    if (location_addr1 != "PermissionStatus.deniedNeverAsk") {
      return new Container(
        child: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(
                      Icons.all_inclusive,
                      color: appBarColor(),
                    ),
                    Text(
                      "Fetching location, please wait...",
                      style: new TextStyle(fontSize: 20.0, color: appBarColor()),
                    )
                  ]),
              SizedBox(height: 15.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Note: ",
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      "Please ensure GPS is ON and refresh the page.",
                      style: new TextStyle(fontSize: 12.0, color: Colors.black),
                      textAlign: TextAlign.left,
                    )
                  ]),
              SizedBox(height: 5.0),
              FlatButton(
                child: new Text(
                  "Refresh location",
                  style: new TextStyle(
                      color: appBarColor(), decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  sl.startStreaming(5);
                  startTimer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MarkMyAttendance()),
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
            'Location permission is restricted from app settings, click "Open Settings" to allow permission.',
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 14.0, color: Colors.red)),
        RaisedButton(
          child: Text('Open Settings'),
          onPressed: () {
            PermissionHandler().openAppSettings();
          },
        ),
      ]);
    }
  }

  loader() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset('assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
      ),
    );
  }

  underdevelopment() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.android,
                color: appBarColor(),
              ),
              Text(
                "Under development",
                style: new TextStyle(fontSize: 30.0, color: appBarColor()),
              )
            ]),
      ),
    );
  }

  poorNetworkWidget() {
    return Container(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.error,
                      color: appBarColor(),
                    ),
                    Text(
                      "Poor network connection.",
                      style: new TextStyle(fontSize: 20.0, color: appBarColor()),
                    ),
                  ]),
              SizedBox(height: 5.0),
              FlatButton(
                child: new Text(
                  "Refresh location",
                  style: new TextStyle(
                      color: appBarColor(), decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  sl.startStreaming(5);
                  startTimer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MarkMyAttendance()),
                  );
                },
              ),
            ]),
      ),
    );
  }

  mainbodyWidget() {
    ////to do check act1 for poor network connection

    if (act1 == "Poor network connection") {
      return Text(act1);
      return poorNetworkWidget();
    } else {
      return SafeArea(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              // foregroundDecoration: BoxDecoration(color:Colors.red ),
              height: MediaQuery.of(context).size.height * 0.80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * .06),
                  new GestureDetector(
                    onTap: () {
                      // profile navigation
                      /* Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));*/
                    },
                    child: new Stack(children: <Widget>[
                      Container(
                          //   foregroundDecoration: BoxDecoration(color:Colors.yellow ),
                          width: MediaQuery.of(context).size.height * .18,
                          height: MediaQuery.of(context).size.height * .18,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: _checkLoaded
                                    ? AssetImage('assets/avatar.png')
                                    : profileimage,
                                //image: AssetImage('assets/avatar.png')
                              ))),
                      /*     new Positioned(
                    left: MediaQuery.of(context).size.width*.14,
                    top: MediaQuery.of(context).size.height*.11,
                    child: new RawMaterialButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                      },
                      child: new Icon(
                        Icons.edit,
                        size: 18.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 0.5,
                      fillColor: appBarColor(),
                      padding: const EdgeInsets.all(1.0),
                    ),
                  ),*/
                    ]),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  //Image.asset('assets/logo.png',height: 150.0,width: 150.0),
                  // SizedBox(height: 5.0),
                  Text(fname.toUpperCase() + " " + lname.toUpperCase(),
                      style: new TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3.0,
                      )),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),
                  // SizedBox(height: MediaQuery.of(context).size.height*.01),
                  (act1 == '') ? loader() : getMarkAttendanceWidgit(),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  getMarkAttendanceWidgit() {
    if (act1 == "Imposed") {
      return getAlreadyMarkedWidgit();
    } else {
      return Container(
        // height: MediaQuery.of(context).size.height*0.5,
        //foregroundDecoration: BoxDecoration(color:Colors.green ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /* Text('Mark Attendance',
                style: new TextStyle(fontSize: 30.0, color: appBarColor())),
            SizedBox(height: 10.0),*/
              getwidget(location_addr1),
              //    SizedBox(height: MediaQuery.of(context).size.height*.1),
              /*      Container(
       //       foregroundDecoration: BoxDecoration(color:Colors.green ),
              margin: EdgeInsets.only(bottom:MediaQuery.of(context).size.height*0),
//              padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.02,bottom:MediaQuery.of(context).size.height*0.02),
              height: MediaQuery.of(context).size.height*.10,
              color: Colors.teal.withOpacity(0.8),
              child: Column(
                  children:[
                    SizedBox(height: 10.0,),
                    getQuickLinksWidget()
                  ]),
            ),
*/
            ]),
      );
    }
  }

  Widget quickLinkList1() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.95,
      // padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.03,bottom:MediaQuery.of(context).size.height*0.03, ),
      child: Row(
        //  crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10.0),
            constraints: BoxConstraints(
              maxHeight: 60.0,
              minHeight: 20.0,
            ),
            child: new GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Column(
                  children: [
                    Icon(
                      const IconData(0xe81c, fontFamily: "CustomIcon"),
                      size: 30.0,
                      color: Colors.black45,
                    ),
                    Text('Attendance Log',
                        textAlign: TextAlign.center,

                        style:
                            new TextStyle(fontSize: 15.0,color: Colors.black45,)),
                  ],
                )),
          ),
        /*  Container(
            padding: EdgeInsets.only(top: 10.0),
            constraints: BoxConstraints(
              maxHeight: 60.0,
              minHeight: 20.0,
            ),
            child: new GestureDetector(
                onTap: () {
                  /*showInSnackBar("Under development.");*/
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PunchLocationSummary()),
                  );
                },
                child: Row(children: [
                  SizedBox(width: MediaQuery.of(context).size.width * .08),
                  Column(
                    children: [
                      Icon(
                        Icons.add_location,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      Text('Visits',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.white)),
                    ],
                  )
                ])),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            constraints: BoxConstraints(
              maxHeight: 60.0,
              minHeight: 20.0,
            ),
            child: new GestureDetector(
                onTap: () {
                  //  //print('----->>>>>'+getOrgPerm(1).toString());
                  getOrgPerm(1).then((res) {
                    {
                      //   //print('----->>>>>'+res.toString());
                      if (res) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TimeoffSummary()),
                        );
                      } else
                        showInSnackBar('Please buy this feature');
                    }
                  });
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.access_alarm,
                      size: 30.0,
                      color: Colors.white,
                    ),
                    Text('Time Off',
                        textAlign: TextAlign.center,
                        style:
                            new TextStyle(fontSize: 15.0, color: Colors.white)),
                  ],
                )),
          ),*/
          /*  Container(
              padding: EdgeInsets.only(top:10.0),
              constraints: BoxConstraints(
                maxHeight: 60.0,
                minHeight: 15.0,
              ),
              child: new GestureDetector(
                  onTap: (){
                    getOrgPerm(1).then((res){
                      {
                        //   //print('----->>>>>'+res.toString());
                        if (res) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder:
                                (context) => LeaveSummary()),
                          );
                        }else showInSnackBar('Please buy this feature');
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Icon(Icons.exit_to_app,size: 30.0,color: Colors.white,),
                      Text('Leave',textAlign: TextAlign.center,style: new TextStyle(fontSize: 15.0,color: Colors.white)),
                    ],
                  )),
            ),*/
        ],
      ),
    );
  }

  List<GestureDetector> quickLinkList() {
    List<GestureDetector> list = new List<GestureDetector>();
    // //print("permission list-->>>>>>"+data.toString());
    list.add(new GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        },
        child: Column(
          children: [
            Icon(
              Icons.calendar_today,
              size: 30.0,
              color: Colors.white,
            ),
            Text('Attendance',
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 15.0, color: Colors.white)),
          ],
        )));

    if (punchlocation_permission == 1) {
      list.add(new GestureDetector(
          onTap: () {
            /*showInSnackBar("Under development.");*/
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PunchLocation()),
            );
          },
          child: Column(
            children: [
              Icon(
                Icons.add_location,
                size: 30.0,
                color: Colors.white,
              ),
              Text('Visits',
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 15.0, color: Colors.white)),
            ],
          )));
    }

    if (timeoff_permission == 1) {
      list.add(new GestureDetector(
          onTap: () {
            //  //print('----->>>>>'+getOrgPerm(1).toString());
            getOrgPerm(1).then((res) {
              {
                //   //print('----->>>>>'+res.toString());
                if (res) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimeoffSummary()),
                  );
                } else
                  showInSnackBar('Please buy this feature');
              }
            });
          },
          child: Column(
            children: [
              Icon(
                Icons.access_alarm,
                size: 30.0,
                color: Colors.white,
              ),
              Text('Time Off',
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 15.0, color: Colors.white)),
            ],
          )));
    }

    if (leave_permission == 1) {
      list.add(new GestureDetector(
          onTap: () {
            getOrgPerm(1).then((res) {
              {
                //   //print('----->>>>>'+res.toString());
                if (res) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaveSummary()),
                  );
                } else
                  showInSnackBar('Please buy this feature');
              }
            });
          },
          child: Column(
            children: [
              Icon(
                Icons.exit_to_app,
                size: 30.0,
                color: Colors.white,
              ),
              Text('Leave',
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 15.0, color: Colors.white)),
            ],
          )));
    }
    return list;
  }

  getQuickLinksWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: quickLinkList(),
    );
  }

  getAlreadyMarkedWidgit() {
    return Column(children: <Widget>[
      SizedBox(
        height: 27.0,
      ),
      Container(
        decoration: new ShapeDecoration(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(13.0)),
            color: appBarColor()),
        child: Text(
          '\nToday\'s attendance has been marked. Thank You!',
          textAlign: TextAlign.center,
          style: new TextStyle(color: Colors.white, fontSize: 15.0),
        ),
        width: 220.0,
        height: 70.0,
      ),
      /*SizedBox(height: MediaQuery.of(context).size.height*.25),
          Container(
            height: MediaQuery.of(context).size.height*.10,
            color: Colors.teal.withOpacity(0.8),
            child: Column(
                children:[
                  SizedBox(height: 10.0,),
                  getQuickLinksWidget()
                ]
            ),
          )*/
    ]);
  }

  getwidget(String addrloc) {
    if (addrloc != "PermissionStatus.deniedNeverAsk") {
      return Column(children: [
        ButtonTheme(
          minWidth: 120.0,
          height: 45.0,
          child: getTimeInOutButton(),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .04),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 1,
              ),
            ),
            elevation: 0.0,
            borderOnForeground: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                  //color: Colors.teal.withOpacity(0.1),
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * .16,
                  child:
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    FlatButton(
                      child: Row( children: <Widget>[
                        Icon(Icons.location_on),
                         Expanded(
                           child: new Text(streamlocationaddr,
                              textAlign: TextAlign.center,
                              style: new TextStyle(fontSize: 14.0,color: Colors.black54)),
                         ),
                      ]),
                      onPressed: () {
                        launchMap(lat, long);
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );*/
                      },
                    ),
                    new Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
//                    new Text(
//                      'Location not correct? ',
//                      style: TextStyle(color: appBarColor()),
//                    ),
                            Icon(
                              const IconData(0xe81a,
                                  fontFamily: "CustomIcon"),
                              size: 15.0,
                              color: appBarColor(),
                            ),
                           // Text("  "),
                            SizedBox(
                              width: 5.0,
                            ),
                            new InkWell(
                              child: new Text(
                                "Refresh location",
                                style: new TextStyle(
                                    color: appBarColor(),
                                    ),
                              ),
                              onTap: () {
                                startTimer();
                                sl.startStreaming(5);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MarkMyAttendance()),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ])),
            ),
          ),
        ),
      ]);
    } else {
      return Column(children: [
        Text(
            'Location permission is restricted from app settings, click "Open Settings" to allow permission.',
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 14.0, color: Colors.red)),
        RaisedButton(
          child: Text('Open Settings'),
          onPressed: () {
            PermissionHandler().openAppSettings();
          },
        ),
      ]);
    }
    return Container(width: 0.0, height: 0.0);
  }

  getTimeInOutButton() {
    if (act1 == 'TimeIn') {
      return RaisedButton(
        elevation: 0.0,
        highlightElevation: 0.0,
        highlightColor: Colors.transparent,
        disabledElevation: 0.0,
        focusColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
//          side: BorderSide( color: Colors.green.withOpacity(0.5), width: 2,),
        ),
        clipBehavior: Clip.antiAlias,
        child: Text('TIME IN',
            style: new TextStyle(fontSize: 18.0, color: Colors.white, letterSpacing: 2.0)),
        color: Colors.orangeAccent,
        onPressed: () async{
          // //print("Time out button pressed");
          var prefs=await SharedPreferences.getInstance();

          String InPushNotificationStatus=await prefs.getString("InPushNotificationStatus")??'0';
          var empId=prefs.getString('empid')??'';
          var orgId=prefs.getString("orgid")??'';
          var eName=prefs.getString('fname')??'User';
          String topic=empId+'TI'+orgId;
          if(InPushNotificationStatus=='1'){


            sendPushNotification(eName+' has marked his Time In','','\''+topic+'\' in topics');


          }

          //globals.globalCameraOpenedStatus = true;
          // //print("Time out button pressed");

          saveImage();
          //Navigator.pushNamed(context, '/home');
        },
      );
    } else if (act1 == 'TimeOut') {
      return RaisedButton(
        elevation: 0.0,
        highlightElevation: 0.0,
        highlightColor: Colors.transparent,
        disabledElevation: 0.0,
        focusColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
//          side: BorderSide( color: Colors.green.withOpacity(0.5), width: 2,),
        ),
        clipBehavior: Clip.antiAlias,
        child: Text('TIME OUT',
            style: new TextStyle(fontSize: 18.0, color: Colors.white,letterSpacing: 2.0)),
        color: Colors.orangeAccent,
        onPressed: () async{
          var prefs=await SharedPreferences.getInstance();

          String OutPushNotificationStatus=await prefs.getString("OutPushNotificationStatus")??'0';
          var empId=prefs.getString('empid')??'';
          var orgId=prefs.getString("orgid")??'';
          var eName=prefs.getString('fname')??'User';
          String topic=empId+'TO'+orgId;
          if(OutPushNotificationStatus=='1'){


            sendPushNotification(eName+' has marked his Time Out','','\''+topic+'\' in topics');


          }
          // //print("Time out button pressed");
          saveImage();
        },
      );
    }
  }

  Text getText(String addrloc) {
    if (addrloc != "PermissionStatus.deniedNeverAsk") {
      return Text('You are at: ' + addrloc,
          textAlign: TextAlign.center, style: new TextStyle(fontSize: 14.0));
    } else {
      return new Text(
          'Location access is denied. Enable the access through the settings.',
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 14.0, color: Colors.red));
      /*return new  Text('Location is restricted from app settings, click here to allow location permission and refresh', textAlign: TextAlign.center, style: new TextStyle(fontSize: 14.0,color: Colors.red));*/
    }
  }

  saveImage() async {
    sl.startStreaming(5);

    MarkTime mk = new MarkTime(
        empid, streamlocationaddr, aid, act1, shiftId, orgdir, lat, long);
    mk1 = mk;

    SaveImage saveImage = new SaveImage();
    bool issave = false;
    setState(() {
      act1 = "";
    });
    var prefs= await SharedPreferences.getInstance();

    showAppInbuiltCamera=prefs.getBool("showAppInbuiltCamera")??false;

    issave = showAppInbuiltCamera? await saveImage.saveTimeInOutImagePickerInAppCamera(mk,context): await saveImage.saveTimeInOutImagePicker(mk,context);
    ////print(issave);
    if (issave) {
      showDialog(
          context: context,
          child: new AlertDialog(
            content: new Text("Attendance marked successfully!"),
          ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
      setState(() {
        act1 = act;
      });
    } else {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Warning!"),
            content: new Text("Problem while marking attendance, try again. " +
                issave.toString()),
          ));
      setState(() {
        act1 = act;
      });
    }

    //   var connectivityResult = await (new Connectivity().checkConnectivity());
    /*   if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraExampleHome()),
      );
   }else{
      showDialog(context: context, child:
      new AlertDialog(

        content: new Text("Internet connection not found!."),
      )
      );
    }*/

    /*SaveImage saveImage = new SaveImage();
    bool issave = false;
    setState(() {
      act1 = "";
    });
    issave = await saveImage.saveTimeInOut(mk);
    ////print(issave);
    if (issave) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
      setState(() {
        act1 = act;
      });
    } else {
      setState(() {
        act1 = act;
      });
    }*/
  }

/*  saveImage() async {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraApp()),
      );
  }*/

  resendVarification() async {
    NewServices ns = new NewServices();
    bool res = await ns.resendVerificationMail(orgid);
    if (res) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  content: Row(children: <Widget>[
                Text(
                    "Verification link has been sent to \nyour organization's registered Email."),
              ])));
    }
  }

  void _showAlert(BuildContext context) {
    globalalertcount = 1;
    setState(() {
      alertdialogcount = 1;
    });
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Verify Email"),
            content: Container(
                height: MediaQuery.of(context).size.height * 0.22,
                child: Column(children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                          "Your organization's Email is not verified. Please verify now.")),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('Later'),
                              shape: Border.all(color: Colors.black54),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            new RaisedButton(
                              child: new Text(
                                "Verify",
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              color: Colors.orangeAccent,
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                resendVarification();
                              },
                            ),
                          ],
                        ),
                      ])
                ]))));
  }
}
