// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:multi_shift/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_shift/services/gethome.dart';
import 'package:multi_shift/services/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'home.dart';
import 'settings.dart';
import 'reports.dart';
import 'profile.dart';



class changePassword extends StatefulWidget {
  @override
  _changePassword createState() => _changePassword();
}
class _changePassword extends State<changePassword> {
  bool isloading = false;
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();
  FocusNode __oldPass = new FocusNode();
  FocusNode __newPass = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText_old = true;
  bool _obscureText_new = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int response=0;
  int _currentIndex = 2;
  String org_name="";
  String admin_sts="0";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    response = prefs.getInt('response') ?? 0;
    admin_sts = prefs.getString('sstatus') ?? '0';
    if(response==1) {
      Home ho = new Home();
      setState(() {
        org_name = prefs.getString('org_name') ?? '';
      });
    }
  }


  void _toggle_old() {
    setState(() {
      _obscureText_old = !_obscureText_old;
    });
  }
  void _toggle_new() {
    setState(() {
      _obscureText_new = !_obscureText_new;
    });
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(org_name, style: new TextStyle(fontSize: 20.0)),
          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
          Navigator.pop(context);
          /*  Navigator.push(
            context,
           MaterialPageRoute(builder: (context) => TimeoffSummary()),
          );*/
        },),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if(newIndex==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          }
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
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
              MaterialPageRoute(builder: (context) => ProfilePage()),
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
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings,color: Colors.black54,),
              title: Text('Settings',style: TextStyle(color: Colors.black54),)
          )
        ],
      ),
      endDrawer: new AppDrawer(),
      body:  checkalreadylogin(),
    );

  }
  checkalreadylogin(){
    if(response==1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          underdevelopment(),
          mainbodyWidget(),
        ],
      );
    }else{
      /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );*/
    }
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
  underdevelopment(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.android,color: Colors.teal,),Text("Under development",style: new TextStyle(fontSize: 30.0,color: Colors.teal),)
            ]),
      ),
    );
  }

  mainbodyWidget(){
    return Center(
      child: Form(
        key: _formKey,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Center(
                    child:Text("Change your login Password",style: new TextStyle(fontSize: 22.0,color: Colors.orangeAccent)),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width*.75,
                            child: TextFormField(
                              controller: _oldPass,
                              onFieldSubmitted: (String value) {
                                FocusScope.of(context).requestFocus(__newPass);
                              },
                              keyboardType: TextInputType.text,
                              obscureText: _obscureText_old,
                              decoration: InputDecoration(
                                  labelText: 'Old Password',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  )
                              ),
                              validator: (value) {
                                if (value.isEmpty || value==null) {
//                                  FocusScope.of(context).requestFocus(__oldPass);
                                  return 'Please enter old password';
                                }
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*.1,
                            child: FlatButton(
                              padding: EdgeInsets.only(right:10.0),
                              child: Icon(
                                _obscureText_old ?Icons.visibility_off:Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _toggle_old,
                            ),
                          ),
                        ],
                      )
                  ), //Enter date
                  SizedBox(height: 12.0),
                  Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width*.75,
                            child: TextFormField(
                              controller: _newPass,
                              focusNode: __newPass,
                              keyboardType: TextInputType.text,
                              obscureText: _obscureText_new,

                              decoration: InputDecoration(
                                  labelText: 'New Password',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ), // icon is 48px widget.
                                  )
                              ),
                              validator: (value) {
                                if (value.isEmpty || value==null || value.length<6 ) {
                                  __oldPass.notifyListeners();
 //                                 FocusScope.of(context).requestFocus(__newPass);
                                  return 'Password must be at least 8 characters';
                                }
                              },
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width*.1,
                            child: FlatButton(
                              padding: EdgeInsets.only(right:10.0),
                              child: Icon(
                                _obscureText_new ?Icons.visibility_off:Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _toggle_new,
                            ),
                          ),
                        ],
                      )
                  ),

                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        shape: Border.all(color: Colors.black54),
                        child: Text('CANCEL'),
                        onPressed: () {
                                Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        child: Text('SUBMIT',style: TextStyle(color: Colors.white),),
                        color: Colors.orangeAccent,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (_oldPass.text == _newPass.text) {
                              showInSnackBar("New password can't same as old");
                              FocusScope.of(context).requestFocus(__newPass);
                            } else {
                              changeMyPassword(_oldPass.text, _newPass.text).then((res){
                                if(res==1) {
                                  _newPass.text='';
                                  _oldPass.text='';

                                  showInSnackBar(
                                      "Password changed successfully");
                                }
                                else if(res==2)
                                  showInSnackBar("Old Password did not match");
                                else if(res==3)
                                  showInSnackBar("New password can't be the same as old password");
                                else
                                  showInSnackBar("Unable to set password "+res.toString());
                              }).catchError((onError){
                                showInSnackBar("Unable to connect server");
                                print(onError);
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}