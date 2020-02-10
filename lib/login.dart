// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// this is testing
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_shift/services/services.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'dart:async';
import 'home.dart';
import 'package:multi_shift/model/user.dart';
import 'package:multi_shift/services/checklogin.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'forgot_password.dart';
import 'askregister.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String barcode = "";
  final _formKey = GlobalKey<FormState>();
  final _formKeyM = GlobalKey<FormState>();
  String loginuser="";
  String username="";

  bool loader = false;
  FocusNode textSecondFocusNode = new FocusNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool err=false;
  bool succ=false;
  bool _isButtonDisabled=false;
  bool loginu=false;
  final _username = TextEditingController();
  FocusNode __username = new FocusNode();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loginuser = prefs.getString('username') ?? "";
      _usernameController.text=loginuser;
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:new Builder(
        builder: (BuildContext context) {
          return new Center(
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Column(
                    children: <Widget>[
                      Image.asset(
                          'assets/logo.png', height: 150.0, width: 150.0,),
                      (loader) ? Center(child : new CircularProgressIndicator()) : SizedBox(height: 2.0),
                      /*Text('Log In', style: new TextStyle(fontSize: 20.0)),*/
                    ],
                  ),
                  /*SizedBox(height: 10.0),*/
                  GestureDetector(
                    onTap: () {
                      scan().then((onValue){
                        print("******************** QR value **************************");
                        print(onValue);
                        markAttByQR(onValue,context);
                      });
                    },
                    child:  Image.asset(
                      'assets/qr.png', height: 45.0, width: 45.0, alignment: Alignment.bottomRight,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(textSecondFocusNode);
                    },
                    controller: _usernameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the Username';
                      }
                    },
                  ),
                  // spacer
                  SizedBox(height: 12.0),
                  // [Password]
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    focusNode: textSecondFocusNode,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter password';
                      }
                    },
                    onFieldSubmitted: (String value) {
                      if (_formKey.currentState.validate()) {
                        login(_usernameController.text,_passwordController.text,context);
                      }
                    },
                  ),

                  SizedBox(height: 5.0),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            shape: Border.all(color: Colors.black54),
                            child: Text('CANCEL'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AskRegisterationPage()),
                              );
                            },
                          ),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width*0.25,
                            child:RaisedButton(
                              child: Text('LOGIN',style: TextStyle(color: Colors.white),),
                              color: Colors.orangeAccent,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  login(_usernameController.text,_passwordController.text,context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),

                 /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width*0.3,
                        child:RaisedButton(
                        child: Text('Scan QR code'),
                        color: Colors.orangeAccent,
                        onPressed: () {
                         scan().then((onValue){
                            print(onValue);
                            markAttByQR(onValue,context);
                         });
                        },
                      ),
                      ),
                    ],
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        child: new Text("Forgot Password?", style: new TextStyle(
                            color: appBarColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            decoration: TextDecoration.underline),),
                        onTap: () {

                          _showModalSheet(context);
//                          Navigator.push(
//                              context, new MaterialPageRoute(builder: (BuildContext context) => ForgotPassword()));
                        },
                      ),
                      SizedBox(width: 19.0,)
                    ],
                  )
                ],
              ),
            ),
          )
          ,
          );
        },
      ),
    );

  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  markAttByQR(var qr, BuildContext context) async{
    Login dologin = Login();
    setState(() {
      loader = true;
    });
    var islogin = await dologin.markAttByQR(qr,context);
    print(islogin);
    if(islogin=="success"){
      setState(() {
        loader = false;
      });
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance marked successfully.")));
    }else if(islogin=="failure"){
      setState(() {
        loader = false;
      });
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Invalid login credentials")));
    }else if(islogin=="imposed"){
      setState(() {
        loader = false;
      });
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance is already marked")));
    }else{
      setState(() {
        loader = false;
      });
      /*Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Attendance is already marked")));*/
    }
  }

  login(var username,var userpassword, BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    var user = User(username.trim(),userpassword);
   // var connectivityResult = await (new Connectivity().checkConnectivity());
   // if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      Login dologin = Login();
      setState(() {
        loader = true;
      });
      var islogin = await dologin.checkLogin(user);
      print(islogin);
      if(islogin=="success"){
        prefs.setString('username', username);
        /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );*/
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false,
        );
      }else if(islogin=="failure"){
        setState(() {
          loader = false;
        });
        Scaffold.of(context)
            .showSnackBar(
            SnackBar(content: Text("Invalid login credentials")));
      }else{
        setState(() {
          loader = false;
        });
        Scaffold.of(context)
            .showSnackBar(
            SnackBar(content: Text("Poor network connection.")));
      }
  /*  }else{
      showDialog(context: context, child:
      new AlertDialog(

        content: new Text("Internet connection not found!."),
      )
      );
    }*/

  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      return barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
        return "pemission denied";
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
        return "error";
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
      return "error";
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
      return "error";
    }
  }

  _showModalSheet(context) async{
    showRoundedModalBottomSheet(context: context, builder: (builder) {
      return Container(
        height: MediaQuery.of(context).size.height*0.33,
        child: Form(
          key: _formKeyM,
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
//              SizedBox(height: 50.0),
//              Column(
//                children: <Widget>[
//                  Image.asset(
//                    'assets/logo.png', height: 150.0, width: 150.0,),
//                  //(loader) ? Center(child : new CircularProgressIndicator()) : SizedBox(height: 2.0),
//                  /*Text('Log In', style: new TextStyle(fontSize: 20.0)),*/
//                ],
//              ),
                Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height*0.05),
                      Center(child:
                      Text("Reset Password",style: new TextStyle(fontSize: 22.0,color: Colors.black54)),
                      ),
                      SizedBox(height: 10.0),
                      succ==false?Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width*.8,
                                child: TextFormField(
                                  controller: _username,
                                  focusNode: __username,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: 'Email',
                                      //labelText: 'Email',
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Icon(
                                          Icons.mail,
                                          color: Colors.grey,
                                        ), // icon is 48px widget.
                                      )
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty || value==null) {
//                                  FocusScope.of(context).requestFocus(__oldPass);
                                      return 'Please enter valid Email';
                                    }
                                  },

                                ),
                              ),
                            ],
                          )
                      ):Center(), //Enter date
                      SizedBox(height: 12.0),

                      succ==false?ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            shape: Border.all(color: Colors.black54),
                            child: Text('CANCEL'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            child: _isButtonDisabled==false?Text('SUBMIT',style: TextStyle(color: Colors.white),):Text('WAIT...',style: TextStyle(color: Colors.white),),
                            color: appBarColor(),
                            onPressed: () {
                              if (_formKeyM.currentState.validate()) {
                                if (_username.text == ''||_username.text == null) {
                                  //showInSnackBar("Please Enter Email");
                                  FocusScope.of(context).requestFocus(__username);
                                } else {
                                  if(_isButtonDisabled)
                                    return null;
                                  setState(() {
                                    _isButtonDisabled=true;
                                  });
                                  resetMyPassword(_username.text).then((res) async{
                                    final prefs = await SharedPreferences.getInstance();
                                    prefs.setString('username', _username.text);

                                    if(res==1) {

                                      username = _username.text;
                                      _username.text='';
                                      print("hello user");
//                                      showInSnackBar(
//                                          "Request submitted successfully");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginPage()),
                                      );
                                      setState(() {
                                        loginu=true;
                                        succ=true;
                                        err=false;
                                        _isButtonDisabled=false;
                                      });
                                      // ignore: deprecated_member_use
                                      showDialog(context: context, child:
                                      new AlertDialog(
                                        title: new Text("Alert"),
                                        content: new Text("Please check your mail for the reset Password link."),
                                      ));
                                    }
                                    else {
                                   //   showInSnackBar("Email Not Found.");
                                      setState(() {
                                        loginu=false;
                                        succ=false;
                                        err=true;
                                        _isButtonDisabled=false;
                                      });
                                    }
                                  }).catchError((onError){
                                  //  showInSnackBar("Unable to call reset password service");
                                    setState(() {
                                      loginu=false;
                                      succ=false;
                                      err=false;
                                      _isButtonDisabled=false;
                                    });
                                    // showInSnackBar("Unable to call reset password service::"+onError.toString());
                                    print(onError);
                                  });
                                }
                              }
                            },
                          ),
                        ],
                      ):Center(),
                      //err==true?Text('Invalid Email.',style: TextStyle(color: Colors.red,fontSize: 16.0),):Center(),
                      succ==true?Text('Please check your mail for the Password reset link. After you have reset the password, please click below link to login.',style: TextStyle(fontSize: 16.0),):Center(),
                      loginu==true?InkWell(
                        child: Text('\nClick here to Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: appBarColor()),),
                        onTap:() async{
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('username', username);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        } ,
                      ):Center(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

}


