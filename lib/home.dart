import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'reports.dart';
import 'services/services.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'mark_my_attendance.dart';
import 'settings.dart';
import 'globals.dart';
import 'punchlocation_summary.dart';
import 'timeoff_summary.dart';
import 'shift_allotment.dart';



import 'package:multi_shift/services/fetch_location.dart';
import 'package:multi_shift/services/gethome.dart';
import 'package:multi_shift/services/services.dart';
import 'package:multi_shift/services/newservices.dart';
import 'askregister.dart';


// This app is a stateful, it tracks the user's current choice.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 2;
  String _orgName="";
  String admin_sts = '0';
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";
  String today = '';
  bool tap = true;
  String status = '-',
      date = '-',
      shiftName = '-',
      shiftTime = '-',
      timeIn = '-',
      timeOut = '-',
      lateBy = '-',
      earlyBy = '-',
      timeOffStart = '-',
      timeOffEnd = '-';
  int response;


  //****************
  var profileimage;
  bool _checkLoaded = true;
  String userpwd = "new";
  String newpwd = "new";
  int Is_Delete = 0;
  bool _visible = true;
  String location_addr = "";
  String location_addr1 = "";
  String streamlocationaddr = "";
  String mail_varified = '1';
  String lat = "";
  String long = "";
  String act = "";
  String act1 = "";
  int alertdialogcount = 0;
 // Timer timer;
 // Timer timer1;
//  int response;
  final Widget removedChild = Center();
  String fname = "",
      lname = "",
      empid = "",
      email = "",
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
  //****************
  void handleNewDate(date) {
    print("handleNewDate ${date}");
  }

  @override

  void initState() {

    super.initState();
    initPlatformState();
    getOrgName();
  }
  initPlatformState() async {
    // await availableCameras();
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    desinationId = prefs.getString('desinationId') ?? '';
    response = prefs.getInt('response') ?? 0;
print('***************************************************');
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
  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      admin_sts = prefs.getString('sstatus').toString();
      _orgName = prefs.getString('org_name') ?? '';
      buystatus = prefs.getString('buysts') ?? '';
      trialstatus = prefs.getString('trialstatus') ?? '';
      orgmail = prefs.getString('orgmail') ?? '';
    });
  }

  launchMap(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  showDialogWidget(String loginstr) {
    if (buystatus == "0") {
      return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text(
              "This feature is only available in the premium plan.",
              style: TextStyle(fontSize: 15.0),
            ),
            content: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('Later'),
                  shape: Border.all(),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                RaisedButton(
                  child: Text(
                    'Pay Now',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.orangeAccent,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                  },
                ),
              ],
            ),
          ));
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text(
                loginstr,
                style: TextStyle(fontSize: 15.0),
              ),
              content: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text('Later', style: TextStyle(fontSize: 13.0)),
                    shape: Border.all(),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'Login Now',
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                    ),
                    color: Colors.orangeAccent,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      launchMap("https://ubishift.ubihrm.com/");
                    },
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
  //  return getmainhomewidget();
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
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(_orgName, style: new TextStyle(fontSize: 20.0)),
            /*  Image.asset(
                    'assets/logo.png', height: 40.0, width: 40.0),*/
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: appBarColor(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if (newIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
            return;
          } else if (newIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          } else if (newIndex == 0) {
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
          setState(() {
            _currentIndex = newIndex;
          });
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
            icon: new Icon(
              Icons.home,
              color: Colors.orangeAccent,
            ),
            title: new Text(
              'Home',
              style: TextStyle(color: Colors.orangeAccent),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Colors.black54,
              ),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.black54),
              ))
        ],
      ),
      endDrawer: new AppDrawer(),
      body: new Container(
        margin: new EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            /*    new Calendar(
              onSelectedRangeChange: (range) =>
                  print("Range is ${range.item1}, ${range.item2}"),
              isExpandable: true,
            ),
*/
            new Calendar(
              onSelectedRangeChange: (range) =>
                  print("Range is ${range.item1}, ${range.item2}"),
              onDateSelected: (date) => setState(() {
                    today = date.toString();
                    tap = true;
                  },
                  ),
            ),

            SizedBox(
              height: 5.00,
            ),
            admin_sts=='1'?getAdminWidget():getWidgets(),
            quickLinkList(),
          ],
        ),
      ),

    );
  }

  Widget getAdminWidget() {

    if (tap) {
      if(today=='')  // default it will work for today
        today = new DateTime.now().toString();

        setState(() {
          date = today;
        /*  status = res.status;
          date = res.date;
          shiftName = res.shiftName;
          shiftTime = res.shiftTime;
          timeIn = res.timeIn;
          timeOut = res.timeOut;
          lateBy = res.lateBy;
          earlyBy = res.earlyBy;
          timeOffStart = res.timeOffStart;
          timeOffEnd = res.timeOffEnd;
          print(date);*/
          tap = false;
        });
            }
    //  return Padding(padding: EdgeInsets.all(50.0), child: loader());



    return Container(
      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 1.0),
      height: MediaQuery.of(context).size.height*0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              child: Text(
                'Shift Assigned',
                style: TextStyle(fontSize: 24.0, color: appBarColor()),
              ),
            ),
          ),
          Divider(
            color: Colors.black26,
          ),
          Row(
            children: <Widget>[
              Container(
                width:   MediaQuery.of(context).size.width * 0.45,
                child: Text(
                  'Employees',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.orangeAccent),
                ),
              ),
              Container(
                width:   MediaQuery.of(context).size.width * 0.45,
                child: Text(
                  'Shift Details',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.orangeAccent),
                ),
              ),
            ],
          ),
          Divider( color: Colors.black26,),
          ////////////-------------getting list of employees group by their shift names-start
    new Expanded(child: getTodaySummary(date),
    ),

          ////////////-------------getting list of employees group by their shift names-close
          SizedBox(height: 10.0,),
        ],
      ),
    );
  }
  Widget getTodaySummary(date){
    print('*************************');
    print(date);
    print('*************************');
//    return Text('data rexd');
    return new FutureBuilder<List<Map>>(
      future: getAllShiftPlans(date),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
        //  print('------');print(snapshot.data[0]['Name']);print('------');
          return new ListView.builder(
              itemCount: snapshot.data.length,
              //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
              itemBuilder: (BuildContext context, int index) {
                return  new Column(
                    children:[
                Row(
                children: <Widget>[
                Container(
                    width:   MediaQuery.of(context).size.width * 0.45,
                child: Text(
                  snapshot.data[index]['Name'],
                style: TextStyle(
                fontSize: 15.0,),
                ),
                ),

                Container(
                width:   MediaQuery.of(context).size.width * 0.45,
                child: Text(
                  snapshot.data[index]['Shift']+'\n('+ snapshot.data[index]['Timings']+')',
                style: TextStyle(
                fontSize: 15.0,),
                ),
                ),
                ],
                ),
                      Divider(),
                    ]);
              }
          );
        }
        return loader();
      }
  );

  }
  Widget getWidgets() {
    if (tap) {
      if(today=='')  // default it will work for today
        today = new DateTime.now().toString();

      getTodayInfo(today).then((res) {
//return false;
        setState(() {
          status = res.status;
          date = res.date;
          shiftName = res.shiftName;
          shiftTime = res.shiftTime;
          timeIn = res.timeIn;
          timeOut = res.timeOut;
          lateBy = res.lateBy;
          earlyBy = res.earlyBy;
          timeOffStart = res.timeOffStart;
          timeOffEnd = res.timeOffEnd;
          print(date);
          tap = false;
        });
      }).catchError((err) {
        print('error called: ' + err.toString());
        return Padding(padding: EdgeInsets.all(50.0), child: Center(child: Text('Unable to connect with server'),),);
      });
      return Padding(padding: EdgeInsets.all(50.0), child: loader());
    }

    print(date);
    return Container(
      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 1.0),
      height: MediaQuery.of(context).size.height*0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              child: Text(
                'My Shift',
                style: TextStyle(fontSize: 24.0, color: appBarColor()),
              ),
            ),
          ),
          Divider(
            color: Colors.black26,
          ),
          Row(
            children: <Widget>[
              Container(
                width:   MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'Shift',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.orangeAccent),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    shiftName,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54),
                  ),
                  Text(
                    ' (' + shiftTime + ') ',
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Container(
                width:   MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'Status',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.orangeAccent),
                ),
              ),
              Text(
                status=='1'?'Present':status,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54),
              ),
            ],
          ),
          Divider(),
          // SizedBox(height: 12.0,),
          Row(
            children: <Widget>[
              Container(
                width:   MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'Time In',
                  style: TextStyle(
                       
                      fontSize: 15.0,
                      color: Colors.orangeAccent),
                ),
              ),
              Text(
                timeIn,
                style: TextStyle(
                     
                    fontSize: 15.0,
                    color: Colors.black54),
              ),
              lateBy!='-' && lateBy!='00:00'?Text(' (Late by '+lateBy+' Hrs)',style:TextStyle(color:Colors.red),

              ):Center(),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Container(
                width:   MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'Time Out',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.orangeAccent),
                ),
              ),
              Text(
                timeOut,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54),
              ),
              earlyBy!='-' && earlyBy!='00:00' ?Text(' (Left early by '+earlyBy+' Hrs)',style:TextStyle(color:Colors.red),
              ):Center(),
            ],
          ),
       /*   Divider(),
          Row(
            children: <Widget>[
              Container(
                width:   MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'Late by',
                  style: TextStyle(

                      fontSize: 15.0,
                      color: Colors.orangeAccent),
                ),
              ),
              Text(
                earlyBy,
                style: TextStyle(

                    fontSize: 15.0,
                    color: Colors.black54),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Container(
                width:   MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'Early by',
                  style: TextStyle(
                       
                      fontSize: 15.0,
                      color: Colors.orangeAccent),
                ),
              ),
              Text(
                earlyBy,
                style: TextStyle(
                     
                    fontSize: 15.0,
                    color: Colors.black54),
              ),
            ],
          ),*/
          Divider(),
          Row(
            children: <Widget>[
              Container(
                width:   MediaQuery.of(context).size.width * 0.25,
                child: Text(
                  'Time Off',
                  style: TextStyle(
                       
                      fontSize: 15.0,
                      color: Colors.orangeAccent),
                ),
              ),
              timeOffStart!='-'?Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    timeOffStart+' To '+timeOffEnd,
                    style: TextStyle(
                         
                        fontSize: 15.0,
                        color: Colors.black54),
                  ),


                ],
              ):Text('-'),
            ],
          ),
          SizedBox(height: 10.0,),
        ],
      ),
    );
  }

  loader() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset('assets/spinner.gif', height: 40.0, width: 40.0),
            ]),
      ),
    );
  }

  getSettingsWidget() {
    return Container(child: Text('TEST'));
  }
  Widget quickLinkList() {
    return Container(
      color: appBarColor(),
      width: MediaQuery.of(context).size.width * 0.95,
       padding: EdgeInsets.only(top:0.0,bottom:10.0, ),
      child: getAddons(),
    );
  }

  Widget getAddons() {

    List <Widget> widList = List<Widget>();

    if (admin_sts == '1') {
      widList.add(Container(
        padding: EdgeInsets.only(top: 10.0),
        width: MediaQuery.of(context).size.width*0.22,
        constraints: BoxConstraints(
          maxHeight: 60.0,
          minHeight: 20.0,
        ),
        child: new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShiftAllotment()),
              );
            },
            child: Column(
              children: [
                Icon(
                  Icons.group,
                  size: 30.0,
                  color: Colors.white,
                ),
                Text('Assign Shift',
                    textAlign: TextAlign.center,
                    style:
                    new TextStyle(fontSize: 15.0, color: Colors.white)),
              ],
            )),
      ));
    }
      widList.add(Container(
        padding: EdgeInsets.only(top: 10.0),
        width: MediaQuery.of(context).size.width*0.22,
        constraints: BoxConstraints(
          maxHeight: 60.0,
          minHeight: 20.0,
        ),
        child: new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarkMyAttendance()),
              );
            },
            child: Column(
              children: [
                Icon(
                  Icons.person,
                  size: 30.0,
                  color: Colors.white,
                ),
                Text('Self' ,
                    textAlign: TextAlign.center,
                    style:
                    new TextStyle(fontSize: 15.0, color: Colors.white)),
              ],
            )),
      ));



    if(visitpunch.toString()=='1') {
      widList.add( Container(
        width: MediaQuery.of(context).size.width*0.22,
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
      ));
    }

    if(timeOff.toString()=='1') {
      widList.add(Container(
        width: MediaQuery.of(context).size.width*0.22,
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
      ));
    }
    return (Row(children: widList,mainAxisAlignment: MainAxisAlignment.spaceEvenly,));
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

  resendVarification() async {
    NewServices ns = new NewServices();
    bool res = await ns.resendVerificationMail(orgid);
    if (res) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              content: Row(children: <Widget>[
                Text(
                    "Verification link has been sent to \nyour organization's registered \nEmail."),
              ])));
    }
  }


}
