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
import 'shift_list.dart';
import 'reports.dart';
import 'profile.dart';



class addShift extends StatefulWidget {
  @override
  _addShift createState() => _addShift();
}
class _addShift extends State<addShift> {
  bool isloading = false;
  final _shiftName = TextEditingController();
  final _from = TextEditingController();
  final _to = TextEditingController();
  final _from_b = TextEditingController();
  final _to_b = TextEditingController();
  final timeFormat = DateFormat("H:mm");
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int response=0;
  int _currentIndex = 2;
  String org_name="";
  String admin_sts="0";
  List<Map> shiftlist=[{"id":"1","name":"Single Date"},{"id":"2","name":"Multi Date"}];
  String shifttype = "1";

  bool _isButtonDisabled=false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    //  shiftList= getShifts();
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
        /*
        response = prefs.getInt('response') ?? 0;
        fname = prefs.getString('fname') ?? '';
        lname = prefs.getString('lname') ?? '';
        empid = prefs.getString('empid') ?? '';
        email = prefs.getString('email') ?? '';
        status = prefs.getString('status') ?? '';
        orgid = prefs.getString('orgid') ?? '';
        orgdir = prefs.getString('orgdir') ?? '';
        sstatus = prefs.getString('sstatus') ?? '';

        desination = prefs.getString('desination') ?? '';
        profile = prefs.getString('profile') ?? '';
        */
      });
    }
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
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
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
                    child:Text("Add Shift",style: new TextStyle(fontSize: 22.0,color: Colors.teal)),
                  ),
                  SizedBox(height: 30.0),
                  Text('Shift Details',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                //  Text("Shift Starts and Ends within",style: new TextStyle(fontSize: 16.0,color: Colors.black54,fontWeight:FontWeight.bold),textAlign: TextAlign.left),
                  Container(
                    //    width: MediaQuery.of(context).size.width*.45,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Shift starts and ends within',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(.50),
                          child: Icon(
                            Icons.today,
                            color: Colors.grey,
                          ), // icon is 48px widget.
                        ),
                      ),
                      //   isEmpty: _color == '',
                      child:  new DropdownButton<String>(
                        isDense: true,
                        style: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.black
                        ),
                        value: shifttype,
                        onChanged: (String newValue) {
                          setState(() {
                            shifttype =newValue;
                           // var arr=newValue.split('#');
                            //_countryCode.text=arr[1];
                           // _countryId.text=arr[0];
                          });
                        },
                        items: shiftlist.map((Map map) {
                          return new DropdownMenuItem<String>(
                            value: map["id"].toString(),
                            child:  new SizedBox(
                                width: 200.0,
                                child: new Text(
                                  map["name"],
                                )
                            ),
                          );
                        }).toList(),

                      ),
                    ),
                  ),
                  TextFormField(
                    //format: dateFormat,
                    controller: _shiftName,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.av_timer,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ), // icon is 48px widget.

                      labelText: 'Shift Name',
                    ),
                    validator: (date) {
                      if (_shiftName.text==null||_shiftName.text==''){
                        return 'Please enter shift name';
                      }
                    },
                  ), //Enter date
                  SizedBox(height: 12.0),
                  Text('Shift Timings',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child:TimePickerFormField(
                            format: timeFormat,
                            controller: _from,
                            decoration: InputDecoration(
                              labelText: 'From',
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.alarm,
                                  color: Colors.grey,
                                ), // icon is 48px widget.
                              ),
                            ),
                            validator: (time) {
                              if (time==null) {
                                return 'Please enter shift start time';
                              }
                            },
                          ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child:TimePickerFormField(
                          format: timeFormat,
                          controller: _to,
                          decoration: InputDecoration(
                            labelText: 'To',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.alarm,
                                color: Colors.grey,
                              ), // icon is 48px widget.
                            ),
                          ),
                          validator: (time) {
                            if (time==null) {
                              return 'Please enter shift end time';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text('Break Hours',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:TimePickerFormField(
                          format: timeFormat,
                          controller: _from_b,
                          decoration: InputDecoration(
                            labelText: 'From',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.alarm,
                                color: Colors.grey,
                              ), // icon is 48px widget.
                            ),
                          ),
                          validator: (time) {
                            if (time==null) {
                              return 'Please enter break start time';
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child:TimePickerFormField(
                          format: timeFormat,
                          controller: _to_b,
                          decoration: InputDecoration(
                            labelText: 'To',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.alarm,
                                color: Colors.grey,
                              ), // icon is 48px widget.
                            ),
                          ),
                          validator: (time) {
                            if (time==null) {
                              return 'Please enter break end time';
                            }
                          },
                        ),
                      ),
                    ],
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
                        child: _isButtonDisabled?Text('Processing..',style: TextStyle(color: Colors.white),):Text('ADD',style: TextStyle(color: Colors.white),),
                        color: Colors.orangeAccent,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if(_isButtonDisabled)
                              return null;
                       /*     print('Name:'+_shiftName.text);
                            print('Starts:'+_from.text);
                            print('Ends:'+_to.text);*/
                            var arr=_from.text.split(':');
                            var arr1=_to.text.split(':');
                            DateTime from=new DateTime(2001,01,01,int.parse(arr[0]),int.parse(arr[1]),00,00);
                            DateTime to=new DateTime(2001,01,01,int.parse(arr1[0]),int.parse(arr1[1]),00,00);
                            var arr_b=_from_b.text.split(':');
                            var arr1_b=_to_b.text.split(':');
                            DateTime from_b=new DateTime(2001,01,01,int.parse(arr_b[0]),int.parse(arr_b[1]),00,00);
                            DateTime to_b=new DateTime(2001,01,01,int.parse(arr1_b[0]),int.parse(arr1_b[1]),00,00);
                            var diff = to.difference(from).toString();
                            var diff_b = to_b.difference(from_b).toString();
                           // print("start status: "+from.isBefore(from_b).toString());
                          //  print("end status: "+to.isAfter(to_b).toString());
                          //  print("eqn"+DateTime.parse(diff).difference(DateTime.parse(diff_b)).toString());

                            if(to.isAtSameMomentAs(from)){
                              showInSnackBar("Shift's start and end time can't be same");
                              return null;
                            }else if(diff_b.startsWith('-') && shifttype.toString() == '1'){
                              showInSnackBar('Invalid break time');
                              return null;
                            }else if((!from_b.isBefore(from))&& (!from.isAtSameMomentAs(from_b))&& shifttype.toString() == '1'){
                              showInSnackBar('Break time should be between shift hours2'+shifttype.toString() + from_b.isBefore(from).toString() + from.isAtSameMomentAs(from_b).toString()+" break "+from_b.toString()+" from "+from.toString());
                              return null;
                            }else if((!to_b.isAfter(to)) && (!to.isAtSameMomentAs(to_b))){
                              showInSnackBar('Break time should be between shift hours1' +shifttype.toString() + from.isBefore(from_b).toString() + from.isAtSameMomentAs(from_b).toString());
                              return null;
                            }else {
                              if (shifttype.toString() == '1') {
                                if (diff.startsWith('-')) {
                                  showInSnackBar('Invalid start time');
                                  return null;
                                } else {
                                  print('Valid shift for single date');
                                  print("Diff: " + diff);
                                }
                              } else {
                                if (!diff.startsWith('-')) {
                                  showInSnackBar('Invalid data');
                                  return null;
                                } else {
                                  print('Valid shift for multi date');
                                  print("Diff: " + diff);

                                }
                              }
                            }
                            setState(() {
                              _isButtonDisabled=true;
                            });
                            createShift(_shiftName.text,shifttype,_from.text,_to.text,_from_b.text,_to_b.text).then((res){
                              if(res.toString()=='1') {
                                showInSnackBar('Shift added successfully');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ShiftList()),
                                );
                              }
                              else if(res.toString()=='-1')
                                showInSnackBar('Shift already exists');
                              else
                                showInSnackBar('Unable to add shift');
                              setState(() {
                                _isButtonDisabled=false;
                              });
                            }).catchError((exp){
                              showInSnackBar('Unable to call server service');
                              setState(() {
                                _isButtonDisabled=false;
                              });
                            });



                         //   print(new DateTime(2001,01,01,int.parse(arr[0]),int.parse(arr[1]),00,00));
                        /*    if(from > to)
                              print(_from.text+' is greater');
                            else
                              print(_to.text+' is greater');*/
                           // requesttimeoff(_dateController.text ,_starttimeController.text,_endtimeController.text,_reasonController.text, context);
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