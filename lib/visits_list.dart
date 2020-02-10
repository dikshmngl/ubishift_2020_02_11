import 'package:flutter/material.dart';
import 'package:simple_share/simple_share.dart';
import 'Bottomnavigationbar.dart';
import 'drawer.dart';
import 'package:multi_shift/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:multi_shift/addShift.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'generatepdf.dart';
import 'home.dart';
import 'settings.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'reports.dart';
import 'globals.dart';

class VisitList extends StatefulWidget {
  @override
  _VisitList createState() => _VisitList();
}

TextEditingController today;

//FocusNode f_dept ;
class _VisitList extends State<VisitList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName="";
  String admin_sts='0';
  bool res = true;
  String emp='0';
  bool filests = false;
  Future<List<Punch>> _listFuture;
  var formatter = new DateFormat('dd-MMM-yyyy');

  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    // f_dept = FocusNode();
    getOrgName();
    _listFuture = getVisitsDataList(today.text,emp);
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
      bottomNavigationBar: Bottomnavigationbar(),
      endDrawer: new AppDrawer(),
      body: Container(
        //   padding: EdgeInsets.only(left: 2.0, right: 2.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Visits',
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
            getEmployee_DD(),
            Divider(height: 1.5,
            color: Colors.black54,),
            SizedBox(height:1.5),

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
                        if (date != null && date.toString() != '')
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
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child:(res == false)?
                Center()
                    :Container(
                    color: Colors.white,
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: new FutureBuilder<List<Punch>>(
                        future: getVisitsDataList(today.text,emp),
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
                                                        'Visits_Report_' +
                                                            today
                                                                .text,
                                                        'visitlist')
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
                                                        'Visits Report for ' + today.text,
                                                        snapshot.data.length.toString(),
                                                        'Visits_Report_' + today.text,
                                                        'visitlist')
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

            SizedBox(height: 7.0),
            Container(
              //  padding: EdgeInsets.only(bottom:10.0,top: 10.0),
       //       width: MediaQuery.of(context).size.width * .9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 8.0,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: Text(
                      'Name',
                      style: TextStyle(color: appBarColor(),fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.38,
                    child: Text(
                      'Client',
                      style: TextStyle(color: appBarColor(), fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    child: Text('In',
                        style: TextStyle(color: appBarColor(), fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    child: Text('Out ',
                        style: TextStyle(color: appBarColor(), fontWeight: FontWeight.bold),
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
    return new FutureBuilder<List<Punch>>(
        future: getVisitsDataList(date, emp),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
            //          width: MediaQuery.of(context).size.width * .9,
                        child:Column(children: <Widget>[
                      new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: 8.0,),
                            new Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                        snapshot.data[index].Emp.toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                  ],
                                )),
                            new Container(
                              width: MediaQuery.of(context).size.width * 0.38,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    snapshot.data[index].client.toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,
                                  ),
                                  InkWell(
                                    child:Text("In: "+
                                      snapshot.data[index].pi_loc.toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    onTap: () {goToMap(snapshot.data[index].pi_latit,snapshot.data[index].pi_longi.toString());},
                                  ),
                                  InkWell(
                                    child:Text("Out: "+
                                      snapshot.data[index].po_loc.toString(),style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                                    onTap: () {goToMap(snapshot.data[index].po_latit.toString(),snapshot.data[index].po_longi.toString());},
                                  ),
                                ],
                              ),
                            ),
                            new Container(
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(snapshot.data[index].pi_time.toString(),style: TextStyle(fontWeight:FontWeight.bold),),
                                  Container(
                                    width: 62.0,
                                    height: 62.0,
                                    child: InkWell(
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(snapshot.data[index].pi_img.toString()),
                                          )
                                        )
                                      ),
                                      onTap: (){

                                      },
                                    ),
                                  ),

                                  SizedBox(height: 2.0,),

                                ],
                              )
                            ),
                            new Container(
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(snapshot.data[index].po_time.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                  Container(
                                    width: 62.0,
                                    height: 62.0,
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(snapshot.data[index].po_img.toString())
                                          )
                                        ),
                                      ),
                                    ),
                                  )

                                ],
                    ),


                            ),
                          ],
                        ),

                      Divider(
                        color: Colors.blueGrey.withOpacity(0.25),
                        height: 0.2,
                      ),
                    ]),
                    );
                  });
            } else {
              return new Center(
                child: Text("No Visits ", style: TextStyle(color: Colors.orangeAccent,fontSize: 18.0),),
              );
            }
          } else if (snapshot.hasError) {
		   return new Text("Unable to connect server");
          }
          // return loader();
          return new Center(child: CircularProgressIndicator());
        });
  }

  Widget getEmployee_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
        future: getEmployeesList(1),// with -select- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              return new Container(
                //    width: MediaQuery.of(context).size.width*.45,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Select an Employee',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ), // icon is 48px widget.
                    ),
                  ),

                  child: new DropdownButton<String>(
                    isDense: true,
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black
                    ),
                    value: emp,
                    onChanged: (String newValue) {
                      setState(() {
                        emp = newValue;
                        //print("------------------");
                        //print(emp);
                        res = true;
                      });
                    },
                    items: snapshot.data.map((Map map) {
                      return new DropdownMenuItem<String>(
                        value: map["Id"].toString(),
                        child: new SizedBox(
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: map["Code"]!=''?new Text(map["Name"]+' ('+map["Code"]+')'):
                            new Text(map["Name"],)),
                      );
                    }).toList(),

                  ),
                ),
              );
            }
            catch(e){
              return Text("EX: Unable to fetch employees");

            }
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return new Text("ER: Unable to fetch employees");
          }
          // return loader();
          return new Center(child: SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2.2,),
            height: 20.0,
            width: 20.0,
          ),);
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
