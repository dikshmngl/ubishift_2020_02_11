import 'package:flutter/material.dart';
import 'package:multi_shift/generatepdf.dart';
import 'package:simple_share/simple_share.dart';
import 'Bottomnavigationbar.dart';
import 'drawer.dart';
import 'package:multi_shift/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'settings.dart';
import 'home.dart';
import 'reports.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'globals.dart';


class LateComers extends StatefulWidget {
  @override
  _LateComers createState() => _LateComers();
}
TextEditingController today;

//FocusNode f_dept ;
class _LateComers extends State<LateComers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List<EmpList>> _listFuture;
  int _currentIndex = 1;
  String _orgName="";
  String admin_sts='0';
  bool res = true;
  bool filests = false;
  var formatter = new DateFormat('dd-MMM-yyyy');
  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    // f_dept = FocusNode();
    getOrgName();
    _listFuture = getLateEmpDataList(today.text);
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName = prefs.getString('org_name') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '0';
    });
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(
      value,
      textAlign: TextAlign.center,
    ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
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
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: appBarColor(),
      ),

      bottomNavigationBar:  Bottomnavigationbar(),
      endDrawer: new AppDrawer(),
      body: Container(
        //   padding: EdgeInsets.only(left: 2.0, right: 2.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Late Comers',
                style: new TextStyle(
                  fontSize: 22.0,
                  color: appBarColor(),
                ),
              ),
            ),
            Divider(
              height: 1.5,
              color: Colors.black54,
            ),
            SizedBox(height: 8.0),
            Row( children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: DateTimeField(
                    //dateOnly: true,
                    format: formatter,
                    controller: today,
                    readOnly: true,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime.now());
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.date_range,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ), // icon is 48px widget.
                      labelText: 'Select Date',
                    ),
                    onChanged: (date) {
                      setState(() {
                        if (date != null && date.toString()!='')
                          res = true; //showInSnackBar(date.toString());
                        else
                          res = false;
                      });
                    },
                    validator: (date) {
                      if (date == null) {
                        return 'Please select date';
                      }
                    },
                  ),
                ),
              ),
      Divider(
      height: 10.0,
    ),
    Padding(
    padding: const EdgeInsets.only(left: 4.0),
    child:(res == false)?
    Center()
        :Container(
    color: Colors.white,
    height: 60,
    width: MediaQuery.of(context).size.width * 0.40,
    child: new FutureBuilder<List<EmpList>>(
    future: _listFuture,
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    if (snapshot.data.length > 0) {
    return new ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: snapshot.data.length,
    itemBuilder:(BuildContext context, int index) {
    return new Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
    (index == 0)
    ? Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    SizedBox(
    height:  60,
    ),
    Container(
    //padding: EdgeInsets.only(left: 5.0),
    child: InkWell(
    child: Text(
    'CSV',
    style: TextStyle(
    decoration:
    TextDecoration
        .underline,
    color: Colors
        .blueAccent,
    fontSize: 16,
    //fontWeight: FontWeight.bold
    ),
    ),
    onTap: () {
    //openFile(filepath);
    if (mounted) {
    setState(() {
    filests = true;
    });
    }
    getCsv1(
    snapshot.data,
    'Late_Comers_Report_' +
    today
        .text,
    'lateComers')
        .then((res) {
    if(mounted){
    setState(() {
    filests = false;
    });
    }
    // showInSnackBar('CSV has been saved in file storage in ubiattendance_files/Department_Report_'+today.text+'.csv');
    dialogwidget(
    "CSV has been saved in internal storage in ubishift_files/Late_Comers_Report_" +
    today.text +
    ".csv",
    res);
    /*showDialog(context: context, child:
                                                        new AlertDialog(
                                                          content: new Text("CSV has been saved in file storage in ubiattendance_files/Late_Comers_Report_"+today.text+".csv"),
                                                        )
                                                        );*/
    });
    },
    ),
    ),
    SizedBox(
    width:8,
    ),
    Container(
    padding: EdgeInsets.only(
    left: 5.0),
    child: InkWell(
    child: Text(
    'PDF',
    style: TextStyle(
    decoration:
    TextDecoration
        .underline,
    color: Colors
        .blueAccent,
    fontSize: 16,),
    ),
    onTap: () {
    //final uri = Uri.file('/storage/emulated/0/ubiattendance_files/Late_Comers_Report_14-Jun-2019.pdf');
    /*SimpleShare.share(
                                                          uri: uri.toString(),
                                                          title: "Share my file",
                                                          msg: "My message");*/
    if (mounted) {
    setState(() {
    filests = true;
    });
    }
    Createpdf(
    snapshot.data,
    'Late Comers Report for ' + today.text,
    snapshot.data.length.toString(),
    'Late_Comers_Report_' + today.text,
    'lateComers')
        .then((res) {
    setState(() {
    filests =false;
    // OpenFile.open("/sdcard/example.txt");
    });
    dialogwidget(
    'PDF has been saved in internal storage in ubishift_files/' +
    'Late_Comers_Report_' +
    today.text +
    '.pdf',
    res);
    // showInSnackBar('PDF has been saved in file storage in ubiattendance_files/'+'Department_Report_'+today.text+'.pdf');
    });
    },
    ),
    ),
    ],
    ):new Center(),
    ]
    );
    }
    );
    }
    }
    return new Center(
    //child: Text("No CSV/Pdf generated", textAlign: TextAlign.center,),
    );
    }
    )
    ),
    )]),
            SizedBox(height: 12.0),
            Container(
              //  padding: EdgeInsets.only(bottom:10.0,top: 10.0),
              width: MediaQuery.of(context).size.width * .9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.37,
                    child: Text(
                      'Name',
                      style: TextStyle(color: appBarColor(),fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: Text(
                      'Shift',
                      style: TextStyle(color: appBarColor(),fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: Text('Time In',
                        style: TextStyle(color: appBarColor(),fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    child: Text('Late By',
                        style: TextStyle(color: appBarColor(),fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0),
            Divider(
              height: 5.2,
            ),
            new Expanded(
              child: res == true ? getEmpDataList(today.text) : Center(),
            ),
          ],
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
              Image.asset('assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
      ),
    );
  }

  getEmpDataList(date) {
    return new FutureBuilder<List<EmpList>>(
        future: getLateEmpDataList(date),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
            return new ListView.builder(
                itemCount: snapshot.data.length,
                //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                itemBuilder: (BuildContext context, int index) {
                  return new Column(children: <Widget>[
                    new FlatButton(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Container(
                              width: MediaQuery.of(context).size.width * 0.37,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                      snapshot.data[index].name.toString()),

                                ],
                              )),
                          new Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: new Text(
                              snapshot.data[index].shift.toString(),
                            ),
                          ),
                          new Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: new Text(
                              snapshot.data[index].timeAct.toString(),
                            ),
                          ),
                          new Container(
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: new Text(
                              snapshot.data[index].diff.toString(),
                              style: TextStyle(
                                  color:Colors.deepOrange),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        null;
                        //    editDept(context,snapshot.data[index].dept.toString(),snapshot.data[index].status.toString(),snapshot.data[index].id.toString());
                      },
                    ),
                    Divider(
                      color: Colors.blueGrey.withOpacity(0.25),
                      height: 0.2,
                    ),
                  ]);
                });
          } else {
              return new Center(
                child: Text("No late comers on this date "),
              );
            }
          } else if (snapshot.hasError) {
             return new Text("Unable to connect server");
          }
         // return loader();
          return new Center(child: CircularProgressIndicator());
        });
  }

  dialogwidget(msg, filename) {
    showDialog(
        context: context,
        // ignore: deprecated_member_use
        child: new AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('Later'),
              shape: Border.all(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            RaisedButton(
              child: Text(
                'Share File',
                style: TextStyle(color: Colors.white),
              ),
              color: appBarColor(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                final uri = Uri.file(filename);
                SimpleShare.share(
                    uri: uri.toString(),
                    title: "Ubishift Report",
                    msg: "Ubishift Report");
              },
            ),
          ],
        ));
  }
} /////////mail class close
