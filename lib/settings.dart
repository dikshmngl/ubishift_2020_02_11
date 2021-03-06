import 'package:flutter/material.dart';
import 'package:multi_shift/cameraSettings.dart';
import 'package:multi_shift/push_notification_for_employee_settings.dart';
import 'Bottomnavigationbar.dart';
import 'drawer.dart';
import 'department.dart';
import 'designation.dart';
import 'employee_list.dart';
import 'shift_list.dart';
import 'change_password.dart';
import 'permission.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'globals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment.dart';
import 'reports.dart';
import 'shift_allotment.dart';

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}
class _Settings extends State<Settings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 2;
  String _orgName="";
  String admin_sts='0';
  String buystatus = "";
  String trialstatus = "";
  String orgmail = "";

  @override
  void initState() {
    super.initState();
    getOrgName();
  }

  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      admin_sts=prefs.getString('sstatus').toString();
      _orgName= prefs.getString('org_name') ?? '';
      buystatus = prefs.getString('buysts') ?? '';
      trialstatus = prefs.getString('trialstatus') ?? '';
      orgmail = prefs.getString('orgmail') ?? '';
    });
  }

  launchMap(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }

  showDialogWidget(String loginstr){
    if(buystatus=="0") {
      return showDialog(context: context, child:
      new AlertDialog(
        title: new Text("This feature is only available in the premium plan.",
          style: TextStyle(fontSize: 15.0),),
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
              child: Text('Pay Now', style: TextStyle(color: Colors.white),),
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
      )
      );
    }else{
      return showDialog(context: context, builder:(context) {

        return new AlertDialog(
          title: new Text(
            loginstr,
            style: TextStyle(fontSize: 15.0),),
          content: ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('Later',style: TextStyle(fontSize: 13.0)),
                shape: Border.all(),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              RaisedButton(
                child: Text(
                  'Login Now', style: TextStyle(color: Colors.white,fontSize: 13.0),),
                color: Colors.orangeAccent,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  launchMap("https://admin.ubishift.com/");
                },
              ),
            ],
          ),
        );
      }
      );
    }
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
  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  getmainhomewidget(){

    return new WillPopScope(
      onWillPop: ()=> sendToHome(),
      child: new Scaffold(
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
              leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }),
              backgroundColor: appBarColor(),
            ),
            bottomNavigationBar: Bottomnavigationbar(),

            endDrawer: new AppDrawer(),
            body:
            Container(
              padding: EdgeInsets.only(left: 2.0,right: 2.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 8.0),
                Text('Settings',
                    style: new TextStyle(fontSize: 22.0, color: appBarColor(),),),
                SizedBox(height: 5.0),
                new Expanded(
                child: getSettingsWidget(),
                )
              ],
            ),

            ),
          ),
    );

  }
  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 80.0, width: 80.0),
            ]),
      ),
    );
  }
  List<Widget> raisedButtonWidget()
  {
    List<Widget> list = new List<Widget>();
    ////// shift button
    if(admin_sts == '1'){
      list.add(new RaisedButton(
        child: Container(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(const IconData(0xe800, fontFamily: 'CustomIcon'),size: 30.0,),
              SizedBox(width: 15.0,),
              Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text('Shifts',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          child: Text('Manage Shifts ',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right,size: 30.0,),
            ],
          ),
        ),
        color: Colors.white,
        elevation: 0.0,
        splashColor: Colors.orangeAccent,
        textColor: Colors.black87,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShiftList()),
          );
          // Perform some action
        },
      ) );

      //list.add( SizedBox(height: 6.0));
    }

    if(admin_sts == '1'){
      list.add(new RaisedButton(
        child: Container(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(const IconData(0xe815, fontFamily: "CustomIcon"),size: 30.0,),
              SizedBox(width: 15.0,),
              Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text('Assign Shift',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          child: Text('Assign Shift for a date',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right,size: 30.0,),
            ],
          ),
        ),
        color: Colors.white,
        elevation: 0.0,
        splashColor: Colors.orangeAccent,
        textColor: Colors.black87,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShiftAllotment()),
          );
          // Perform some action
        },
      ) );

      //list.add( SizedBox(height: 6.0));
    }
/*
    if(admin_sts == '1'){
      list.add(new RaisedButton(
        child: Container(
          padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.autorenew,size: 40.0,),
              SizedBox(width: 15.0,),
              Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text('Shift Planner',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),)
                    ),
                    Container(
                        child: Text('View Shift Rotations ',style: TextStyle(fontSize: 15.0,),)
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right,size: 50.0,),
            ],
          ),
        ),
        color: Color.fromRGBO(240, 247, 209, 1),
        elevation: 4.0,
        splashColor: Colors.purpleAccent,
        textColor: Colors.black87,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShiftPlanner()),
          );
          // Perform some action
        },
      ) );

      list.add( SizedBox(height: 6.0));
    }*/

    ///// department button

    if(admin_sts == '1'){
      list.add(new RaisedButton(
        child: Container(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(const IconData(0xe803, fontFamily: 'CustomIcon'),size: 30.0,),
              SizedBox(width: 15.0,),
              Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text('Departments',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          child: Text('Manage Departments ',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right,size: 30.0,),
            ],
          ),
        ),
        color: Colors.white,
        elevation: 0.0,
        splashColor: Colors.greenAccent,
        textColor: Colors.black87,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Department()),
          );
        },
      ));

      //list.add( SizedBox(height: 6.0));

    }



    if(admin_sts == '1'){
      list.add(new RaisedButton(
        child: Container(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(const IconData(0xe804, fontFamily: "CustomIcon"),size: 30.0,),
              SizedBox(width: 15.0,),
              Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text('Designations',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          child: Text('Manage Designations ',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right,size: 30.0,),
            ],
          ),
        ),
        color: Colors.white,
        elevation: 0.0,
        splashColor: Colors.lightBlueAccent,
        textColor: Colors.black87,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Designation()),
          );
          // Perform some action
        },
      ));
     // list.add( SizedBox(height: 6.0));
    }

    if(admin_sts == '1'){
      list.add(new RaisedButton(
        child: Container(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(const IconData(0xe806, fontFamily: 'CustomIcon'), size: 30.0,),
              SizedBox(width: 15.0,),
              Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text('Employees',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          child: Text('Manage Employees ',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right,size: 30.0,),
            ],
          ),
        ),
        color: Colors.white,
        elevation: 0.0,
        splashColor: Colors.amberAccent,
        textColor: Colors.black87,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmployeeList()),
          );
          // Perform some action
        },
      ));
      //list.add( SizedBox(height: 6.0));
    }

    if(admin_sts == '1'){
      list.add(new RaisedButton(
        child: Container(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(const IconData(0xe809, fontFamily: "CustomIcon"),size: 30.0,),
              SizedBox(width: 15.0,),
              Expanded(
                //widthFactor: MediaQuery.of(context).size.width*0.10,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text('Holidays',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          child: Text('Configure Holidays',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right,size: 30.0,),
            ],
          ),
        ),
        color: Colors.white,
        elevation: 0.0,
        splashColor: Colors.amberAccent,
        textColor: Colors.black87,
        onPressed: () {
          showDialogWidget("To configure the Holidays, login to the web admin panel.");
          // Perform some action
        },
      ));
      //list.add( SizedBox(height: 6.0));
    }

    if(admin_sts == '1'){
      list.add(new RaisedButton(
        child: Container(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(const IconData(0xe808, fontFamily: 'CustomIcon'),size: 30.0,),
              SizedBox(width: 15.0,),
              Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text('Geo Fence',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          child: Text('Configure Geo Fence ',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right,size: 30.0,),
            ],
          ),
        ),
        color: Colors.white,
        elevation: 0.0,
        splashColor: Colors.amberAccent,
        textColor: Colors.black87,
        onPressed: () {
          showDialogWidget("To configure Geo Fence, login to the web admin panel");
          // Perform some action
        },
      ));
      //list.add( SizedBox(height: 6.0));
    }

    if(permission_module_permission == 1){
      list.add(new RaisedButton(
        child: Container(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.group,size: 40.0,),
              SizedBox(width: 15.0,),
              Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text('Permissions',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                          child: Text('Manage Permissions ',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right,size: 30.0,),
            ],
          ),
        ),
        color: Colors.white,
        elevation: 0.0,
    //    splashColor: Colors.lightGreenAccent,
        textColor: Colors.black87,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PermissionPage()),
          );
          //showInSnackBar("Under Development");
        },
      ));
     // list.add( SizedBox(height: 6.0));
    }

    list.add( new RaisedButton(
      child: Container(
        padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(const IconData(0xe802, fontFamily: "CustomIcon"),size: 30.0,),
            SizedBox(width: 15.0,),
            Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Text('Change Password',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                        child: Text('Change your password',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_right,size: 30.0,),
          ],
        ),
      ),
      color: Colors.white,

      elevation: 0.0,
    //  splashColor: Colors.tealAccent,
      textColor: Colors.black87,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => changePassword()),
        );
      },
    ));

    //list.add(SizedBox(height: 6.0));
    list.add(new RaisedButton(
      child: Container(
        padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(const IconData(0xe80c, fontFamily: "CustomIcon"),size: 30.0,),
            SizedBox(width: 15.0,),
            Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Text('Profile',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                        child: Text('Manage your profile ',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_right,size: 30.0,),
          ],
        ),
      ),
      color: Colors.white,
      elevation: 0.0,
      splashColor: Colors.pink,
      textColor: Colors.black87,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
    ));
    //list.add(SizedBox(height: 6.0));
    list.add(new RaisedButton(
      child: Container(
        padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.camera,size: 30.0,),
            SizedBox(width: 15.0,),
            Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Text('Camera',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                        child: Text('Manage camera used in App ',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_right,size: 30.0,),
          ],
        ),
      ),
      color: Colors.white,
      elevation: 0.0,
      splashColor: Colors.pink,
      textColor: Colors.black87,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CameraSettings()),
        );
      },
    ));
    //list.add(SizedBox(height: 6.0));
    //if(admin_sts == '1')
    list.add(new RaisedButton(
      child: Container(
        padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(const IconData(0xe80b, fontFamily: "CustomIcon"),size: 30.0,),
            SizedBox(width: 15.0,),
            Expanded(
//                            widthFactor: MediaQuery.of(context).size.width*0.10,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Text('Punch Notifications',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                        child: Text('Manage Notifications ',style: TextStyle(fontSize: 12.0,letterSpacing: 1.0),)
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_right,size: 30.0,),
          ],
        ),
      ),
      color: Colors.white,
      elevation: 0.0,
      splashColor: Colors.pink,
      textColor: Colors.black87,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PushNotificationForEmployee()),
        );
      },
    ));


    return list;
  }

  getSettingsWidget(){
      return Container(
        child:
            ListView(
              padding: EdgeInsets.only(left: 5.0,right: 5.0),
                children: raisedButtonWidget()
            ),
      );
  }
}



