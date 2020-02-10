import 'dart:math';

import 'package:easy_dialog/easy_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:multi_shift/globals.dart' as globals;
import 'mark_my_attendance.dart';
import 'settings.dart';
import 'globals.dart';
import 'punchlocation_summary.dart';
import 'timeoff_summary.dart';
import 'shift_allotment.dart';
import 'Bottomnavigationbar.dart';



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
  String dateShowed="";
  String createdDate="";
  var ReferrerNotificationList = new List(5);
  var ReferrerenceMessagesList = new List(7);
  var token='';
  //****************
  void handleNewDate(date) {
    print("handleNewDate ${date}");
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override

  void initState() {

    super.initState();
    initPlatformState();
    getOrgName();
  }

  void firebaseCloudMessaging_Listeners()async {

    var prefs=await SharedPreferences.getInstance();
    var country=prefs.getString("CountryName")??'';
    var orgTopic=prefs.getString("OrgTopic")??'';
    var isAdmin=admin_sts = prefs.getString('sstatus').toString() ?? '0';
    //_firebaseMessaging.subscribeToTopic('101');
    //_firebaseMessaging.subscribeToTopic('admin');
    print("hello sub");
    print(country);
    print(orgTopic);
    if(isAdmin=='1'){
      _firebaseMessaging.subscribeToTopic('admin');
      print("Admin topic subscribed");
    }
    else{
      print("employee topic subscribed");
      if(orgTopic.isNotEmpty)
        _firebaseMessaging.subscribeToTopic('employee');
    }




    if(globals.globalOrgTopic.isNotEmpty){
      _firebaseMessaging.unsubscribeFromTopic(orgTopic.replaceAll(' ', ''));
      _firebaseMessaging.subscribeToTopic(globals.globalOrgTopic.replaceAll(' ', ''));

      print('globals.globalOrgTopic'+globals.globalOrgTopic.toString());

      prefs.setString("OrgTopic",globals.globalOrgTopic);

    }
    else{
      if(orgTopic.isNotEmpty)
        _firebaseMessaging.subscribeToTopic(orgTopic.replaceAll(' ', ''));
      print('globals.globalOrgTopic11111'+orgTopic);


    }

    if(globals.globalCountryTopic.isNotEmpty){
      _firebaseMessaging.unsubscribeFromTopic(country.replaceAll(' ', ''));
      _firebaseMessaging.subscribeToTopic(globals.globalCountryTopic.replaceAll(' ', ''));
      prefs.setString("CountryName", globals.globalCountryTopic);
      print('globalCountryTopic'+globalCountryTopic);
    }
    else{
      if(country.isNotEmpty)
        _firebaseMessaging.subscribeToTopic(country.replaceAll(' ', ''));
    }



    if(globals.currentOrgStatus.isNotEmpty){
      var previousOrgStatus=prefs.get("CurrentOrgStatus")??'';
      if(previousOrgStatus.isNotEmpty)
        _firebaseMessaging.unsubscribeFromTopic(previousOrgStatus.replaceAll(' ', ''));
      _firebaseMessaging.subscribeToTopic(globals.currentOrgStatus.replaceAll(' ', ''));

      prefs.setString("CurrentOrgStatus", globals.currentOrgStatus);
      globals.currentOrgStatus='';
    }
    _firebaseMessaging.getToken().then((token){
      _firebaseMessaging.subscribeToTopic("AllOrg");
      // _firebaseMessaging.subscribeToTopic("UBI101");
      _firebaseMessaging.subscribeToTopic("AllCountry");


      // print('country subscribed'+country);


      this.token=token;

       sendPushNotification(token.toString(),"This is notification from mobile","Mobile Notification");


       print("token--------------->"+token.toString()+"-------------"+country);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message'+message['data'].isEmpty.toString());
//{notification: {title: ABC has marked his Time In, body: null}, data: {}}
        cameraChannel.invokeMethod("showNotification",{"title":message['notification']['title']==null?'':message['notification']['title'].toString(),"description":message['notification']['body']==null?'':message['notification']['body'].toString(),"pageToOpenOnClick":message['data'].isEmpty?'':message['data']['pageToNavigate']});

      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        var navigate=message['data'].isEmpty?'':message['data']['pageToNavigate'];
        navigateToPageAfterNotificationClicked(navigate, context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        var navigate=message['data'].isEmpty?'':message['data']['pageToNavigate'];
        navigateToPageAfterNotificationClicked(navigate, context);
      },
    );
  }

  showReferralPopup(BuildContext context,String cDateS)async{
    int dateToSend=0;
    var prefs=await SharedPreferences.getInstance();
    var buyStatus=int.parse(prefs.get("buysts")??"123455");
    var createdDate = DateTime.parse("2019-12-26");

    var startDate = DateTime.parse(prefs.get("ReferralValidFrom")??"2019-12-26");
    var endDate = DateTime.parse(prefs.get("ReferralValidTo")??"2019-12-26");

    //var startDate = DateTime.parse("2020-01-21");
    //var endDate = DateTime.parse("2020-12-30");

    //var currDate=DateTime.now();
    var currDate=DateTime.parse("2020-01-28");
    dateShowed=prefs.getString('date')??"2010-10-10";

    print("datetime.parse"+dateShowed);
    // print("hello"+dateShowed);
    var referrerAmt=prefs.getString("ReferrerDiscount")??"1%";
    var referrenceAmt=prefs.getString("ReferrenceDiscount")??"1%";
    ReferrerNotificationList[0]={
      "title":"Win Win Deal",
      "description":"Refer our App and get ${referrerAmt} off on your next payment"
    };
    ReferrerNotificationList[1]={
      "title":"Refer and Earn",
      "description":"Invite your friends to try ubiShift. Get ${referrerAmt} Off when they pay"
    };
    ReferrerNotificationList[2]={
      "title":"Discounts that count",
      "description":"For every organization you refer which pays up for our Premium plan, we will give you both ${referrerAmt}/ ${referrenceAmt} off"
    };
    ReferrerNotificationList[3]={
      "title":"${referrerAmt} Off every Payment",
      "description":"Tell Your friends about ubiShift & get ${referrerAmt} Discount when he pays."
    };
    ReferrerNotificationList[4]={
      "title":"Discounts to smile about",
      "description":"Give managers the gift of ease in managing shifts & recording attendance, and get ${referrerAmt} off on your next purchase"
    };

    var referrerName="";
    var validity=prefs.getString("ReferralValidity");


    var rng = new Random();
    var referrerRandom=rng.nextInt(4);
    double height=220;
    if(referrerRandom==2||referrerRandom==4)
      height=260;
    if(referrerRandom==0)
      height=170;

    print("----> currdate"+currDate.toString());

    if(createdDate==''){
      dateToSend=12;
    }
    // if(buyStatus!=0){  // for trial popup that should show on the seventh day of purchase

    //print("difference dates"+currDate.difference(cDate).inDays.toString());
    //print("created date"+createdDate);

    // } // for other organizations i.e pop up for every created date day of the month
    // else{
    dateToSend=createdDate.day;
    print('startDate');
    print(startDate);
    print('endDate'+endDate.toString());
//      print(currDate);
//      print(prefs.getString('date'));
    //print("----> currdate"+((DateTime.parse(dateShowed).day==startDate.day)&&(DateTime.parse(dateShowed).month==startDate.month)&&(DateTime.parse(dateShowed).year==startDate.year)).toString());
    if(currDate.isAfter(startDate)&& currDate.isBefore(endDate)||(currDate.day==startDate.day&&currDate.month==startDate.month&&currDate.year==startDate.year )||(currDate.day==endDate.day&&currDate.month==endDate.month&&currDate.year==endDate.year )) {
      print("inside referral check");
      //        prefs.setString('date',currDate.toString());
      // var newDate = new DateTime(startDate.year, startDate.month, startDate.day+3);
      //if (currDate.isAfter(newDate) && currDate.isBefore(endDate)) {
//        prefs.setString('date', newDate.toString());
//        print("hello");
//        print(prefs.getString('date'));

      print(currDate);

      //if(((DateTime.parse(dateShowed).day==currDate.day)&&(DateTime.parse(dateShowed).month==currDate.month)&&(DateTime.parse(dateShowed).year==currDate.year))){
      //var newDate = new DateTime(currDate.year, currDate.month, currDate.day+3);
        print('dateShowed'+dateShowed);
        print(DateTime.parse(dateShowed).day);
        print(((currDate.difference(startDate).inDays).abs()%3==0));
      //print('testing'+((DateTime.parse(dateShowed).day!=currDate.day)&&(currDate.isAfter(startDate)&& currDate.isBefore(endDate))).toString());
      if(((DateTime.parse(dateShowed).day!=currDate.day)&&((currDate.difference(startDate).inDays).abs()%3==0))){
        //var newDate = currDate.add(new Duration(days: 3));
        dateShowed=currDate.toString();
        prefs.setString('date',dateShowed);
        print("hello"+currDate.toString());

        EasyDialog(
            title: Text(
              ReferrerNotificationList[referrerRandom]['title'].toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,),
              textAlign: TextAlign.center,),
            description: Text(
              ReferrerNotificationList[referrerRandom]['description']
                  .toString(), textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16,),),
            height: height,
            contentList: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40,),
                  RaisedButton(
                    child: Text("GO!", style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      generateAndShareReferralLink();
                    },
                    color: Colors.green,

                  ), SizedBox(width: 10, height: 10,),

                ],
              )
            ]
        )
            .show(context);
      }
    }

    // }

  }

  initPlatformState() async {
    // await availableCameras();
    appResumedPausedLogic(context);
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
        print("New pwd" + newpwd + "  User pwd" + userpwd);
        location_addr1 = location_addr;
        admin_sts = prefs.getString('sstatus').toString() ?? '0';
        mail_varified = prefs.getString('mail_varified').toString() ?? '0';
        alertdialogcount = globalalertcount;
        response = prefs.getInt('response') ?? 0;
        fname = prefs.getString('fname') ?? '';
        lname = prefs.getString('lname') ?? '';
        empid = prefs.getString('empid') ?? '';
        email = prefs.getString('email') ?? '';
        //status = prefs.getString('status') ?? '';
        //print("status");
        //print(status);
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
    if(referralNotificationShown==false&&admin_sts=='1'){
      showReferralPopup(context,createdDate);
      referralNotificationShown=true;
    }

    firebaseCloudMessaging_Listeners();
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
      bottomNavigationBar: Bottomnavigationbar(),
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
            SizedBox(
              height: 40.00,
            ),
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
                      fontWeight: FontWeight.bold,
                      color: appBarColor()),
                ),
              ),
              Container(
                width:   MediaQuery.of(context).size.width * 0.45,
                child: Text(
                  'Shift Details',
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: appBarColor()),
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
      color: Colors.white,
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
                  color: Colors.black,
                ),
                Text('Assign Shift',
                    textAlign: TextAlign.center,
                    style:
                    new TextStyle(fontSize: 15.0, color: Colors.black)),
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
                  color: Colors.black,
                ),
                Text('Self' ,
                    textAlign: TextAlign.center,
                    style:
                    new TextStyle(fontSize: 15.0, color: Colors.black,)),
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
                    color: Colors.black,
                  ),
                  Text('Visits',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: 15.0, color: Colors.black)),
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
                  color: Colors.black,
                ),
                Text('Time Off',
                    textAlign: TextAlign.center,
                    style:
                    new TextStyle(fontSize: 15.0, color: Colors.black)),
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
