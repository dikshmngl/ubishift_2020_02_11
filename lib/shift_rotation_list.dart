import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:multi_shift/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:multi_shift/addEmployee.dart';
import 'home.dart';
import 'settings.dart';
import 'reports.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'globals.dart';

class ShiftPlanner extends StatefulWidget {
  @override
  _ShiftPlanner createState() => _ShiftPlanner();
}

class _ShiftPlanner extends State<ShiftPlanner> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 2;
  String _sts = 'Active';
  String _sts1 = 'Active';
  String admin_sts = '0';
  String _orgName;
  List<Shiftplanner> items = null;

  @override
  void initState() {
    super.initState();
    getOrgName();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName = prefs.getString('org_name') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '';
    });
    getShiftEmployee().then((EmpList) {
      setState(() {
        items = EmpList;
        print(items);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (newIndex) {
            if (newIndex == 1) {
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
            if (newIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
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
              icon: new Icon(Icons.home),
              title: new Text('Home'),
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
        body: getEmpWidget());
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

  getEmpWidget() {
 /*   print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    print(items);
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');*/
    if (items != null) {
      return new Container(
        child: items.length > 0
            ? new ListView(
                children: [
                  new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          items[index].Expansionsts =
                              !items[index].Expansionsts;
                          //print(items[index].Expansionsts);
                        });
                      },
                      children: items.map((Shiftplanner item) {
                        print("Default shift is: " +
                            item.DefaultShift.toString());
                        return new ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return new ListTile(
                                //leading: item.iconpic,
                                title: new Text(
                              item.Name,
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ));
                          },
                          isExpanded: item.Expansionsts,
                          body: new Container(
                            padding: EdgeInsets.only(
                                top: 15, bottom: 15, left: 5, right: 5),
                            color: Colors.green[50],
                            child: (item.type == '1')
                                ? new Container(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Default shift: ",
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        item.DefaultShift +
                                            ' ( ' +
                                            item.DefaultTimes +
                                            ' )',
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 08.0,
                                      ),
                                      Text(
                                        "Planned shift for: ",
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "" + item.months + "\n",
                                        style: new TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      new Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width *0.28,
                                            child:Text('Date Range',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                          ),

                                          Container(
                                            width: MediaQuery.of(context).size.width *0.30,
                                            child:Text('Shift',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width *0.22,
                                            child:Text('Timings',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                          ),
                                        ],
                                      ),
                                      Divider(color: Colors.black87,),
                                      new ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: item.Details.length,
                                          //  padding: EdgeInsets.only(left: 5.0,right: 5.0),

                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return new Column(children: <
                                                Widget>[

                                              new Row(
                                                //crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.28,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(FormatDay(
                                                                item
                                                                    .Details[
                                                                        index]
                                                                    .FromDay
                                                                    .toString())+' to '+FormatDay(
                                                              item
                                                                  .Details[
                                                              index]
                                                                  .ToDay
                                                                  .toString()),
                                                            style: TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                ),
                                                          ),
                                                        ],
                                                      )),

                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.30,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                                item
                                                                    .Details[
                                                                        index]
                                                                    .Shift
                                                                    .toString(),
                                                            style: TextStyle(
                                                                //fontWeight: FontWeight.bold
                                                                ),
                                                          ),
                                                        ],
                                                      )),
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.22,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                                item
                                                                    .Details[
                                                                        index]
                                                                    .Timings
                                                                    .toString(),
                                                            style: TextStyle(
                                                                //fontWeight: FontWeight.bold
                                                                ),
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                              Divider(),
                                            ]);
                                          }),
                                      Divider(color: Colors.black,),
                                      item.Special.length>0?new Text('Custom shift for:',style: TextStyle(fontSize: 16.0,color: Colors.black54,fontWeight: FontWeight.bold)):Center(),
                                      item.Special.length>0?Divider():Center(),
                                      item.Special.length>0? new Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width *0.28,
                                            child:Text('Assigned For',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width *0.3,
                                            child:Text('Shift',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width *0.22,
                                            child:Text('Timings',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                          ),
                                        ],
                                      ):Center(),
                                      item.Special.length>0?Divider(color: Colors.black,):Center(),
                                      item.Special.length>0?Container(
                                        child: Row(
                                          children: <Widget>[
                                            /*   Text('Custom Shift',style: new TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.orangeAccent,
                                              ),

*/
                                            Expanded(
                                              child: new ListView.builder(
                                                  scrollDirection: Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount: item.Special.length,
                                                  //  padding: EdgeInsets.only(left: 5.0,right: 5.0),
                                                  itemBuilder: (BuildContext context,int index) {
                                                    //   if(item.Special.length>0){
                                                    return new Column(children: <
                                                        Widget>[
                                                      new Row(
                                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            width:
                                                            MediaQuery.of(context).size.width * 0.22,
                                                            child:Text(item.Special[index].ShiftDate),
                                                          ),
                                                          Container(
                                                            width:
                                                            MediaQuery.of(context).size.width * 0.3,
                                                            child:Text(item.Special[index].Shift),
                                                          ),
                                                          Container(
                                                            width:
                                                            MediaQuery.of(context).size.width * 0.22,
                                                            child:Text(item.Special[index].Timings),
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(),
                                                    ]);
                                                    //  }
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ):Center(),
                                    ],
                                  ))
                                : (item.type == '0')
                              ?new Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Default shift: ",
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black54,fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.DefaultShift +
                                              ' ( ' +
                                              item.DefaultTimes +
                                              ' )',
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 08.0,
                                        ),
                                        Text(
                                          "Planned shift for: ",
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          "" + item.days + "\n",
                                          style: new TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        new Row(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width *0.28,
                                              child:Text('Effective From',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width *0.3,
                                              child:Text('Shift',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width *0.22,
                                              child:Text('Timings',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                        Divider(color: Colors.black87,),
                                      new ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: item.Details.length,
                                          //  padding: EdgeInsets.only(left: 5.0,right: 5.0),

                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return new Column(children: <
                                                Widget>[
                                              new Row(
                                                //crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.28,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                                Formatdate(item
                                                                    .Details[
                                                                index]
                                                                    .EffectiveFrom
                                                                    .toString()),
                                                            style: TextStyle(
                                                                //fontWeight: FontWeight.bold
                                                                ),
                                                          ),
                                                        ],
                                                      )),
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.30,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                                item
                                                                    .Details[
                                                                        index]
                                                                    .Shift
                                                                    .toString(),
                                                            style: TextStyle(
                                                                //fontWeight: FontWeight.bold
                                                                ),
                                                          ),
                                                        ],
                                                      )),
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.22,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                                item
                                                                    .Details[
                                                                        index]
                                                                    .Timings
                                                                    .toString(),
                                                            style: TextStyle(
                                                                //fontWeight: FontWeight.bold
                                                                ),
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ]);
                                          }),
                                        Divider(color: Colors.black,height:25.0),
                                        item.Special.length>0?new Text('Custom shift for:',style: TextStyle(fontSize: 16.0,color: Colors.black54,fontWeight: FontWeight.bold)):Center(),
                                        item.Special.length>0?Divider():Center(),
                                        item.Special.length>0? new Row(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width *0.28,
                                              child:Text('Assigned For',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width *0.3,
                                              child:Text('Shift',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width *0.22,
                                              child:Text('Timings',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ):Center(),
                                        item.Special.length>0?Divider(color: Colors.black,):Center(),
                                        item.Special.length>0?Container(
                                          child: Row(
                                            children: <Widget>[
                                           /*   Text('Custom Shift',style: new TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.orangeAccent,
                                              ),

*/
                                              Expanded(
                                                child: new ListView.builder(
                                                    scrollDirection: Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: item.Special.length,
                                                    //  padding: EdgeInsets.only(left: 5.0,right: 5.0),
                                                    itemBuilder: (BuildContext context,int index) {
                                                      //   if(item.Special.length>0){
                                                      return new Column(children: <
                                                          Widget>[
                                                        new Row(
                                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: <Widget>[
                                                           Container(
                                                             width:
                                                             MediaQuery.of(context).size.width * 0.22,
                                                             child:Text(item.Special[index].ShiftDate),
                                                           ),
                                                           Container(
                                                             width:
                                                             MediaQuery.of(context).size.width * 0.3,
                                                             child:Text(item.Special[index].Shift),
                                                           ),
                                                           Container(
                                                             width:
                                                             MediaQuery.of(context).size.width * 0.22,
                                                             child:Text(item.Special[index].Timings),
                                                           ),
                                                          ],
                                                        ),
                                                        Divider(),
                                                      ]);
                                                      //  }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ):Center(),
                                    ],
                                  ),
                            ):Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Default shift: ",
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item.DefaultShift +
                                        ' ( ' +
                                        item.DefaultTimes +
                                        ' )',
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 08.0,
                                  ),
                                  item.Special.length>0?new Text('Custom shift for:',style: TextStyle(fontSize: 16.0,color: Colors.black54,fontWeight: FontWeight.bold)):Center(),
                                  item.Special.length>0?Divider():Center(),
                                  item.Special.length>0? new Row(
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width *0.28,
                                        child:Text('Assigned For',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width *0.3,
                                        child:Text('Shift',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width *0.22,
                                        child:Text('Timings',style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ):Center(),
                                  item.Special.length>0?Divider(color: Colors.black,):Center(),
                                  item.Special.length>0?Container(
                                    child: Row(
                                      children: <Widget>[
                                        /*   Text('Custom Shift',style: new TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.orangeAccent,
                                              ),

*/
                                        Expanded(
                                          child: new ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: item.Special.length,
                                              //  padding: EdgeInsets.only(left: 5.0,right: 5.0),
                                              itemBuilder: (BuildContext context,int index) {
                                                //   if(item.Special.length>0){
                                                return new Column(children: <
                                                    Widget>[
                                                  new Row(
                                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                        width:
                                                        MediaQuery.of(context).size.width * 0.22,
                                                        child:Text(item.Special[index].ShiftDate),
                                                      ),
                                                      Container(
                                                        width:
                                                        MediaQuery.of(context).size.width * 0.3,
                                                        child:Text(item.Special[index].Shift),
                                                      ),
                                                      Container(
                                                        width:
                                                        MediaQuery.of(context).size.width * 0.22,
                                                        child:Text(item.Special[index].Timings),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(),
                                                ]);
                                                //  }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ):Center(),
                                ],
                              ),
                            ),
                          ),

                        );
                      }).toList(),
                    ),
                  )
                ],
              )
            : Center(
                child: new Text(
                  'No shift assigned',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
      );
    } else {
      return new Center(
        child: loader(),
      );
    }
  }
} /////////mail class close
