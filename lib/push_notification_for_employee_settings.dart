import 'dart:math' as math;

import 'package:multi_shift/globals.dart' as prefix0;
import 'package:multi_shift/services/newservices.dart';
import 'package:multi_shift/services/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';
import 'globals.dart';
import 'home.dart';
//import 'offline_home.dart';

class PushNotificationForEmployee extends StatefulWidget {
  @override
  _PushNotificationForEmployee createState() => _PushNotificationForEmployee();
}

class _PushNotificationForEmployee extends State<PushNotificationForEmployee> {
  final List<grpattemp> _saved = new List<grpattemp>();
  final _searchController = TextEditingController();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  NewServices ns = NewServices();
  List<grpattemp> emplist = null;
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 2;
  Color cartcolor =  Colors.white;
  Color appcolor_check =  Colors.cyan[50];
  String org_name = "";
  String admin_sts = '0';
  String empname = "";
  String searchval = "";
  int response;
  String fname = "",
      lname = "",
      empid = "",
      email = "",
      status = "",
      orgid = "",
      orgdir = "",
      sstatus = "",
      desination = "",
      desinationId = "",
      profile;

  var First;
  var Last;
  var name;
  String sts = '0';
  String aid = "";
  String shiftId = "";
  int checkall = 0;
  List<Map> attstsList = null;
  bool pageload = true;
  bool res = true;
  bool _obscureText = true;
  bool _isButtonDisabled = false;
  bool showSearch= false;
  final _from = TextEditingController();
  final _to = TextEditingController();
  final timeFormat = DateFormat("H:mm");
  // TimeOfDay time;
  String newValue;
  bool _enabletimeout;
  bool _enabletimein;
  bool _updatetimeout;
  String colorti;
  String colorto;
  bool loaderr=false;
  bool fakeLocationDetected=false;
  var orgId='0';
  var switchStatuses;

  List<bool> outSwitchStatuses;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();

  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    //checkNetForOfflineMode(context);
    //appResumedPausedLogic(context);
/*    StreamLocation ns=new StreamLocation();
    ns.stopStreaming();*/
    final prefs = await SharedPreferences.getInstance();
    orgId=prefs.getString("orgid")??'';
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    admin_sts = prefs.getString('sstatus') ?? '';
    orgid = prefs.getString('orgid') ?? '';
    desinationId = prefs.getString('desinationId') ?? '';
//    getDeptEmp('All').then((EmpList) {
//      setState(() {
//        emplist = EmpList;
//      });
//    });

    attstsList = createAttStsList();
    response = prefs.getInt('response') ?? 0;
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
      });
      aid = prefs.getString('aid') ?? "";
      shiftId = prefs.getString('shiftId') ?? "";
    }
    platform.setMethodCallHandler(_handleMethod);
  }

  getemployeelist($val)
  {
//    getDeptEmp_Search($val).then((EmpList) {
//      setState(() {
//        emplist = EmpList;
//      });
//    });
  }


  static const platform = const MethodChannel('location.spoofing.check');
  String address="";
  String areaStatus="";
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch(call.method) {
      case "navigateToPage":
        navigateToPageAfterNotificationClicked(call.arguments["page"].toString(),context);
        break;
      case "locationAndInternet":
      // print(call.arguments["internet"].toString()+"akhakahkahkhakha");
      // Map<String,String> responseMap=call.arguments;
        //prefix0.locationThreadUpdatedLocation=true;
        if(call.arguments["TimeSpoofed"].toString()=="Yes"){
          timeSpoofed=true;

        }
        if(call.arguments["internet"].toString()=="Internet Not Available")
        {
          print("internet nooooot aaaaaaaaaaaaaaaaaaaaaaaavailable");
          //Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => OfflineHomePage()));
        }

        assign_lat=double.parse(call.arguments["latitude"].toString());
        assign_long=double.parse(call.arguments["longitude"].toString());
       // address=await getAddressFromLati(assign_lat.toString(), assign_long.toString());
        print(call.arguments["mocked"].toString());
//        getAreaStatus().then((res) {
//          // print('called again');
//          if (mounted) {
//            setState(() {
//              areaStatus = res.toString();
//            });
//          }
//        }).catchError((onError) {
//          print('Exception occured in clling function.......');
//          print(onError);
//        });

        setState(() {

          if(call.arguments["mocked"].toString()=="Yes"){
            fakeLocationDetected=true;
          }
          else{
            fakeLocationDetected=false;
          }

        });
        break;
        return new Future.value("");
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
        ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<bool> sendToHome() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false,
    );
    return false;
  }


  getmainhomewidget() {
    return new WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: Scaffold(
        backgroundColor: Colors.white,
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
          backgroundColor: appcolor_check,
        ),
        /*
        bottomNavigationBar: Container(

          height: 70.0,
          decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: [new BoxShadow(
                color: Colors.black12,
                blurRadius: 3.0,
              ),]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
//                margin: const EdgeInsets.only(left: 50.0),
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide( color: Colors.grey.withOpacity(0.5), width: 1,),
                      ),
                      child: Text('CANCEL'),
                      onPressed: () {
                        /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()),
                        );*/
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    ),

                    RaisedButton(
                      elevation: 2.0,
                      highlightElevation: 5.0,
                      highlightColor: Colors.transparent,
                      disabledElevation: 0.0,
                      focusColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: _isButtonDisabled ? Text('Processing..',
                        style: TextStyle(color: Colors.white),
                      )
                          : Text(
                        'SAVE',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: buttoncolor,
                      onPressed: (){
                        if (_formKey.currentState.validate()){
                          if (_isButtonDisabled) return null;
                          if(_saved.length==0) {
                            showInSnackBar(
                                'Please Select atleast one record...');
                            return null;
                          }
                          else{
                            var formatter = new DateFormat('yyyy-MM-dd');
                            String todaydate=formatter.format(DateTime.now());
                            //print( todaydate);
                            DateTime from;
                            DateTime to;
                            for(var i = 0; i < _saved.length; i++){
                              print( _saved[i].Name);
                              print( _saved[i].data_date);
                              print( _saved[i].timeout);
                              if(_saved[i].data_date==todaydate){
                                DateTime now = DateTime.now();
                                to = new DateTime(now.year, now.month, now.day, now.hour, now.minute,00,00);
                                //print(to);
                                if(_saved[i].timein!='0:0' && _saved[i].timein!='00:00:00'){
                                  var arr = _saved[i].timein.split(':');
                                  from = new DateTime(now.year, now.month, now.day, int.parse(arr[0]), int.parse(arr[1]),00,00);
                                  if (to.isBefore(from)) {
                                    showInSnackBar(_saved[i].Name +
                                        "'s timein is greater than current time...");
                                    return null;
                                  }
                                }
                                if(_saved[i].timeout!='0:0' && _saved[i].timeout!='00:00:00') {
                                  var arr = _saved[i].timeout.split(':');
                                  from = new DateTime(now.year, now.month, now.day, int.parse(arr[0]), int.parse(arr[1]),00,00);
                                  if (to.isBefore(from)) {
                                    showInSnackBar(_saved[i].Name +
                                        "'s timeout is greater than current time...");
                                    return null;
                                  }
                                }
                              }
                              print( _saved[i].Attid);
                              if(_saved[i].shifttype=='1'){
                                print(_saved[i].timeout);
                                if(_saved[i].timeout!='0:0' && _saved[i].timeout!='00:00:00') {
                                  var arr = _saved[i].timein.split(':');
                                  from = new DateTime(2001, 01, 01, int.parse(arr[0]), int.parse(arr[1]), 00, 00);
                                  var arr1 = _saved[i].timeout.split(':');
                                  to = new DateTime(2001, 01, 01, int.parse(arr1[0]), int.parse(arr1[1]), 00, 00);
                                  if (to.isBefore(from)) {
                                    showInSnackBar(_saved[i].Name +
                                        "'s timein is greater than timeout...");
                                    return null;
                                  }
                                }
                              }
                            }
                          }
                          print("---------------before add bulk att");
                          print(_saved);
                         //  return false;
                          setState(() {
                            _isButtonDisabled = true;
                          });


                          print("---------------before add bulk att");
                          addBulkAtt(_saved)
                              .then((res) {
                            //showInSnackBar(res.toString());
                            //   showInSnackBar('Employee registered Successfully');
                            if (res == "success") {
                              showDialog(context: context, child:
                              new AlertDialog(
                                content: new Text("Attendance added successfully!"),
                              )
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            }
                            else
                              showDialog(context: context, child:
                              new AlertDialog(
                                content: new Text("Unable to add attendance!"),
                              )
                              );
                            setState(() {
                              _isButtonDisabled = false;
                            });
                            // TimeOfDay.fromDateTime(10000);
                          }).catchError((exp) {
                            showInSnackBar('Unable to call service');
                            print(exp.toString());
                            setState(() {
                              _isButtonDisabled = false;
                            });
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),*/
        endDrawer: new AppDrawer(),
        body: Container(
          padding: EdgeInsets.only(left: 2.0, right: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 8.0),
              /*Center(
                child: Text(
                  'Group Attendance',
                  style: new TextStyle(
                    fontSize: 22.0,
                    color: Colors.black54,
                  ),
                ),

              ),*/
              SizedBox(height: 5.0),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide( color: Colors.grey.withOpacity(1.0), width: 1,),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          child: Padding(
                            padding: const EdgeInsets.only(left:5.0,top: 5.0,bottom: 5.0,),
                            child: DropdownButton<String>(
                              icon: Icon(Icons.arrow_drop_down),
                              isDense: true,
                              hint: Text('Today'),
                              onChanged: (String changedValue) {
                                newValue=changedValue;
                                setState(() {
                                  loaderr=true;
                                });
                                getDeptEmp(changedValue).then((EmpList) {
                                  setState(() {

                                    emplist = EmpList;
                                    _saved.clear();
                                    checkall = 0;
                                    loaderr=false;
                                  });

                                });
                              },value: newValue,
                              items: <String>['Today ', 'Yesterday'].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),

                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  /*Padding(
                    padding: const EdgeInsets.only(right:10.0),
                    child:
                    (showSearch == false) ?
                    IconButton(
                      onPressed: (){
                        setState(() {
                          _searchController.text = '';
                           showSearch=true;
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ) :
                    IconButton(
                      onPressed: (){
                        setState(() {
                          getemployeelist("");
                          _searchController.text = '';
                          showSearch=false;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    ),
                  ),*/
                ],
              ),*/
              /*(showSearch == true) ?
              Padding(
                padding: const EdgeInsets.only(left:10.0,right: 10.0),
                child: Card(
                  elevation: 2.0,
                  clipBehavior: Clip.antiAlias,
                  child: TextField(
                    autofocus: true,
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,

                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      focusColor: Colors.white,
                      /*suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          : (){},
                        )*/
                    ),
                    /*onChanged: _searchController,*/
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        empname = value;
                        loaderr=false;
                        showSearch?getemployeelist(value):"" ;
                      });
                    },
                  ),
                ),
              ) : new Container(
              ),*/
              SizedBox(height:10.0),
              Container(
                padding: EdgeInsets.only(top:0.0,bottom: 2.0),
                child:Center(
                  child:Text("Punch Notifications",
                      style: new TextStyle(fontSize: 22.0, color: appcolor_check,)),
                ),
              ),
              Divider(color: Colors.black54,height: 1.5,),
              SizedBox(height: 8.0),
              //Divider(color: Colors.black54,height: 1.5,),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30.0,),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02),
                  Container(
                    width: MediaQuery.of(context).size.width*0.25,
                    child:Text('',style: TextStyle(color: appcolor_check,fontWeight:FontWeight.bold,fontSize: 16.0),),
                  ),

                  SizedBox(height: 30.0,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.32,
                    child:Text('Time In',style: TextStyle(color: appcolor_check,fontWeight:FontWeight.bold,fontSize: 16.0),),
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.2,
                    child:Text('Time Out',style: TextStyle(color: appcolor_check,fontWeight:FontWeight.bold,fontSize: 16.0),),
                  ),
                ],
              ),
              Divider(),
              new Expanded(
                child:loaderr==false?getBulkEmpWidget():loader(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  getBulkEmpWidget() {
    if (emplist != null) {
      switchStatuses=new List<bool>(emplist.length);
      outSwitchStatuses= List<bool>(emplist.length);
      return new Container(
        child: Form(
          key:_formKey,
          child: new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: emplist.length,
              //  padding: EdgeInsets.only(left: 5.0,right: 5.0),
              itemBuilder: (BuildContext context, int index) {
                final int alreadySaved = emplist[index].csts;

                //switchStatuses[index]=emplist[index].InPushNotificationStatus.toString()=='1'?true:false;
                //outSwitchStatuses[index]=emplist[index].OutPushNotificationStatus.toString()=='1'?true:false;

                var empId=emplist[index].Id;


                String topic=empId+'TI'+orgId;
                String topic1=empId+'TO'+orgId;

                if(switchStatuses[index]){
                  //var prefs=await SharedPreferences.getInstance();

                  _firebaseMessaging.subscribeToTopic(topic);


                  // var topic=emplist[index].Name

                  print("topic subscribed emp"+topic);
                }
                else{
                  _firebaseMessaging.unsubscribeFromTopic(topic);
                }
                if(outSwitchStatuses[index]){
                  //var prefs=await SharedPreferences.getInstance();

                  _firebaseMessaging.subscribeToTopic(topic1);


                  // var topic=emplist[index].Name

                  print("topic subscribed emp"+topic1);
                }
                else{
                  _firebaseMessaging.unsubscribeFromTopic(topic1);
                }


                //List til=emplist[index].timein.split(":");
                //if(!til[0]){til[0]=0;};
                // TimeOfDay ti = TimeOfDay(hour: int.fromEnvironment(til[0]), minute: int.fromEnvironment(til[1]));

                /* print(emplist[index].timein);
               print(int.parse(til[0]));
               print(til[1]);*/
                DateTime ti = new DateTime(2001, 01, 01, int.parse(emplist[index].timein.split(":")[0]), int.parse(emplist[index].timein.split(":")[1]), 00, 00);
                DateTime tout = new DateTime(2001, 01, 01, int.parse(emplist[index].timeout.split(":")[0]),
                    int.parse(emplist[index].timeout.split(":")[1]), 00, 00);
                //TimeOfDay(hour: int.parse(emplist[index].timein.split(":")[0]), minute: int.parse(emplist[index].timein.split(":")[1]));
                //print(ti);
                //TimeOfDay tout = TimeOfDay(hour: int.parse(emplist[index].timeout.split(":")[0]), minute: int.parse(emplist[index].timeout.split(":")[1]));
//                if(emplist[index].Attid=='0'){
//                  _enabletimein=true;
//                  ti=null;
//                }
//                else{
//                  _enabletimein=false;
//                }
//                if(emplist[index].timeout=='00:00:00' || emplist[index].device=='Auto Time Out'){
//                  _enabletimeout=true;
//                }
//                else{
//                  _enabletimeout=false;
//                }
                // print(tout);
                //print('_enabletimeout'+emplist[index].Name+_enabletimeout.toString()+emplist[index].Attid.toString());
               // print('_enabletimein'+emplist[index].Name+_enabletimein.toString()+emplist[index].Attid.toString());
                print(emplist[index].Name.split(' '));
                getAcronym(var val) {
                  if((emplist[index].Name.trim()).contains(" ")){
                    name=emplist[index].Name.split(" ");
                    print('print(name);');
                    print(name);
                    First=name[0][0];
                    Last=name[1][0];
                    return First+Last;
                  }else{
                    First=emplist[index].Name[0];
                    print('print(First)else');
                    print(First);
                    return First;
                  }
                }


                /*var first = Name[0][0];
                var last = Name[1][0];*/

                //  print(_saved.elementAt(index).Name);
                return new Column(children: <Widget>[
                 new Padding(
                    padding: const EdgeInsets.only(left:8.0, right:8.0),

                    child: InkWell(
                      onLongPress: (){},
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide( color: const Color(0xFFEEEEEE), width: 0.5,),

                        ),
                        elevation: 0.0,
                        color: alreadySaved==1?appcolor_check:Colors.white,

                        clipBehavior: Clip.antiAlias,
                        borderOnForeground: false,
                        child: new Container(
                          padding: const EdgeInsets.all(10.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              /*new IconButton(
                                icon: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Icon(
                                    alreadySaved == 1
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color:
                                    alreadySaved == 1 ? buttoncolor   : null,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (emplist[index].csts == 1) {
                                      _saved.remove(emplist[index]);
                                      emplist[index].csts = 0;
                                      print(emplist[index].Name+'Remove');
                                      print(_saved);
                                    } else {
                                      _saved.add(emplist[index]);
                                      emplist[index].csts = 1;
                                      print(emplist[index].Name);
                                    }
                                  });
                                  //return null;
                                  // editDept(context,snapshot.data[index].Name.toString(),snapshot.data[index].Status.toString(),snapshot.data[index].Id.toString());
                                },
                              ),*/
                              InkWell(
                                child:/*Container(
                                    width: MediaQuery.of(context).size.height * .07,
                                    height: MediaQuery.of(context).size.height * .07,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image:alreadySaved==1?AssetImage('assets/checkmark.png'):NetworkImage(emplist[index].img)
                                         )
                                        )
                                    )
                                ),*/
                                Container(
                                  width: MediaQuery.of(context).size.width * .14,
                                  height: MediaQuery.of(context).size.height * .07,
                                  child: alreadySaved==1?Icon(IconData(0x2713, fontFamily: "CustomIcon"),size: 35.0,
                                    color: appcolor_check,):CircleAvatar(
                                    child: Text(getAcronym(emplist[index].Name),style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400)),
                                    backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
                                  ),
                                ),
                                onTap: (){
                                setState(() {

                                  if (emplist[index].csts == 1) {
                                    _saved.remove(emplist[index]);
                                    emplist[index].csts = 0;
                                  } else {
                                    _saved.add(emplist[index]);
                                    emplist[index].csts = 1;
                                    print(emplist[index].Name);
                                  }
                                });

                                  /*Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ImageView(myimage: emplist[index].img,org_name: org_name)),
                                  );*/
                                },
                              ),
                              SizedBox(width:10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    emplist[index].Name.toString(),
                                    style: TextStyle(fontWeight: FontWeight.w600,
                                      fontSize: 13.0,),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.22,
                                      //  height: MediaQuery.of(context).size.height*.06,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFBFBFB),
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            boxShadow: [new BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2.0,
                                            ),]
                                        ),
                                        child:Switch(

                                            value: switchStatuses[index],
                                            onChanged: (value) async{
                                           // updateEmployeePushNotificationStatus(value,emplist[index].Id,"TimeIn");
/*
                                            var prefs=await SharedPreferences.getInstance();
                                            var empId=emplist[index].Id;
                                            var orgId=prefs.getString("orgid")??'';

                                            String topic=empId+'TI'+orgId;
                                            if(value)
                                            _firebaseMessaging.subscribeToTopic(topic);
                                            else
                                              _firebaseMessaging.unsubscribeFromTopic(topic);
                                           // var topic=emplist[index].Name

                                            print("topic subscribed emp"+topic);
*/
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => PushNotificationForEmployee()),
                                            );


/*
                                              setState(() {
                                                switchStatuses[index]=value;
                                              });*/
                                            })/* DateTimeField(
                                          format: timeFormat,
                                          initialValue: ti,
                                          enabled:_enabletimein,
                                          readOnly: true,
                                          //controller: _from,
                                          decoration: InputDecoration(

                                            border: InputBorder.none,
                                            hintText: 'Time In',
                                            hintStyle: TextStyle(
                                                fontSize: 12.0
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(horizontal:5,vertical: 12.0),

                                            // labelText: 'Time In',
                                            /* prefixIcon: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Text('Time In'), // icon is 48px widget.
                                      ),*/
                                          ),
                                          onShowPicker: (context, currentValue) async {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                            );
                                            return DateTimeField.convert(time);
                                          },
                                          onChanged: (t) => setState(() {
                                            print('time');
                                            print(t);
                                            if(t!=null) {
                                              emplist[index].timein = t.hour.toString() + ':' + t.minute.toString();
                                            }else{
                                              // emplist[index].timein = t.toString();
                                            }
                                            if (emplist[index].csts != 1) {
                                              _saved.add(emplist[index]);
                                              emplist[index].csts = 1;
                                            }
                                            else{

                                            }
                                          }
                                          ),
                                          /* onSaved: (t) => setState(() {
                                        emplist[index].timein = t.hour.toString()+':'+t.minute.toString();
                                        if (emplist[index].csts != 1) {
                                      _saved.add(emplist[index]);
                                      emplist[index].csts = 1;
                                        }
                                      }
                                      ),*/
                                          validator: (time) {
                                            if (time == null && emplist[index].csts==1) {
                                              return 'Please enter TimeIn';
                                            }
                                          },
                                        ),*/
                                      ),
                                      SizedBox(width:50.0),
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.23,
                                       // height: MediaQuery.of(context).size.height*.06,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFBFBFB),
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            boxShadow: [new BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2.0,
                                            ),]
                                        ),
                                        child:Switch(
                                            value: outSwitchStatuses[index],
                                            onChanged: (value) async{
                                             // updateEmployeePushNotificationStatus(value,emplist[index].Id,"TimeOut");
/*
                                              var prefs=await SharedPreferences.getInstance();
                                              var empId=emplist[index].Id;
                                              var orgId=prefs.getString("orgid")??'';

                                              String topic=empId+'TO'+orgId;
                                              if(value)
                                                _firebaseMessaging.subscribeToTopic(topic);
                                              else
                                                _firebaseMessaging.unsubscribeFromTopic(topic);
                                              // var topic=emplist[index].Name

*/
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => PushNotificationForEmployee()),
                                              );


/*
                                              setState(() {
                                                switchStatuses[index]=value;
                                              });*/
                                            })/* DateTimeField(
                                          format: timeFormat,
                                          //initialValue: tout,
                                          //enabled:_enabletimeout,
                                          readOnly: true,
                                          onShowPicker: (context, currentValue) async {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                            );
                                            return DateTimeField.convert(time);
                                          },
                                          //editable: false,
                                          //controller: _to,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Time Out',
                                            hintStyle: TextStyle(
                                                fontSize: 12.0
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(horizontal:5,vertical: 12.0),
                                            /* border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide( color: Colors.grey.withOpacity(0.0), width: 1,),
                                ),*/

                                            // labelText: 'Time Out',
                                            /*prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text('Time Out'), // icon is 48px widget.
                                      ),*/
                                          ),
                                          onChanged: (t) => setState(() {
                                            print('timeout');
                                            print(t);
                                            if(t!=null) {
                                              emplist[index].timeout =
                                                  t.hour.toString() + ':' + t.minute.toString();
                                            }else{

                                            }
                                            if (emplist[index].csts != 1) {
                                              _saved.add(emplist[index]);
                                              emplist[index].csts = 1;
                                            }
                                            /*if((emplist[index].Attid != 0 &&  t==null) && (emplist[index].Attid != 0 && t.hour.toString() + ':' + t.minute.toString() =='00:00'))
                                              {
                                                _saved.remove(emplist[index]);
                                                emplist[index].csts = 0;
                                              }*/
                                          }),
                                          validator: (time) {
                                            //    print("dddddddd");
                                            // print(emplist[index].Attid);
                                            if ( time == null && emplist[index].csts==1 && emplist[index].Attid!='0'){
                                              return "Enter Time out";
                                            }
                                            else if (time == null && emplist[index].csts==1) {
                                              emplist[index].timeout ='00:00:00';
                                            }
                                          },
                                        ),*/
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          /*      onPressed: () {
                            // editDept(context,snapshot.data[index].Name.toString(),snapshot.data[index].Status.toString(),snapshot.data[index].Id.toString());
                          },*/
                        ),
                      ),
                    ),
                  ),
                 // SizedBox(height:5.0),
                ]
                );
              }
          ),
        ),
      );
    } else {
      return loader();
      /* return new Container(
        child: new Text('No data Found...'),
      );*/
    }
  }

  underdevelopment() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.android,
                color: appcolor_check,
              ),
              Text(
                "Under development",
                style: new TextStyle(fontSize: 30.0, color:appcolor_check),
              )
            ]),
      ),
    );
  }

////////////////common dropdowns
  Widget getStatus_DD(data) {
    // String dc = "0";
    return new Container(
      //width: MediaQuery.of(context).size.width*0.01,
      child: InputDecorator(
        decoration: InputDecoration(

          //labelText: 'Status',
          /*prefixIcon: Padding(
            padding: EdgeInsets.all(1.0),
            child: Icon(
              Icons.attach_file,
              color: Colors.grey,
            ), // icon is 48px widget.
          ),*/

        ),
        child: new DropdownButton<String>(
          isDense: true,
          style: new TextStyle(fontSize: 15.0, color: Colors.black),
          value: data.attsts,
          onChanged: (String newValue) {
            setState(() {
              data.attsts = newValue;
            });
          },
          items: attstsList.map((Map map) {
            return new DropdownMenuItem<String>(
              value: map["Id"].toString(),
              child: new SizedBox(
                //width: 200.0,
                  child: new Text(
                    map["Name"],
                  )),
            );
          }).toList(),
        ),
      ),
    );
  }

  loader() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset('assets/spinner.gif', height: 30.0, width: 30.0),
            ]),
      ),
    );
  }

  createAttStsList() {
    List<Map> list = new List();
    //list.add({"Id": "0", "Name": "-Select-"});
    Map tos = {"Name": 'P', "Id": '1'};
    list.add(tos);
    tos = {"Name": 'A', "Id": '2'};
    list.add(tos);
    return list;
  }

  checkbulkall() {
    setState(() {
      if (checkall == 0) {
        checkall = 1;
        _saved.clear();
        _saved.addAll(emplist);
        for (var i = 0; i < emplist.length; i++) {
          emplist[i].csts = 1;
        }
      } else {
        _saved.clear();
        checkall = 0;
        for (var i = 0; i < emplist.length; i++) {
          emplist[i].csts = 0;
        }
      }
    });
  }
}