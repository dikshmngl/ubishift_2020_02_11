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

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeList createState() => _EmployeeList();
}
TextEditingController dept;
//FocusNode f_dept ;
class _EmployeeList extends State<EmployeeList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 2;
  String _sts = 'Active';
  String _sts1 = 'Active';
  String admin_sts='0';
  String _orgName;
  @override
  void initState() {
    super.initState();
    dept = new TextEditingController();
    // f_dept = FocusNode();
    getOrgName();
  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName= prefs.getString('org_name') ?? '';
      admin_sts= prefs.getString('sstatus') ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value, textAlign: TextAlign.center,));
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
            leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
              Navigator.pop(context);}),
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
          body:
          Container(
         //   padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 8.0),
                Center(
                  child: Text('Employees',
                    style: new TextStyle(fontSize: 22.0, color: Colors.orangeAccent,),),
                ),
                Divider(height: 10.0,),
                SizedBox(height: 2.0),
                Container(
                 padding: EdgeInsets.only(bottom:10.0,top: 10.0),
                  width: MediaQuery.of(context).size.width*.9,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.30,
                        child: Text('Employees', style: TextStyle(color: Colors.orange),textAlign: TextAlign.left,),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.22,
                        child: Text('Department', style: TextStyle(color: Colors.orange),textAlign: TextAlign.left,),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.22,
                        child: Text('Designation', style: TextStyle( color: Colors.orange),textAlign: TextAlign.left),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.16,
                        child: Text('Status', style: TextStyle(color: Colors.orange),textAlign: TextAlign.left),
                      ),

                    ],
                  ),
                ),
                Divider(height: 0.2,),
                new Expanded(
                  child: getDeptWidget(),
                ),

              ],
            ),

          ),
          floatingActionButton: new FloatingActionButton(
            mini: false,
            backgroundColor: Colors.blue,
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEmployee()),
              );
            },
            tooltip: 'Add Employee',
            child: new Icon(Icons.add),
          ),
        );

  }

  loader() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
      ),
    );
  }

  getDeptWidget() {
    return new FutureBuilder<List<Emp>>(
        future: getEmployee(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
                itemCount: snapshot.data.length,
            //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                itemBuilder: (BuildContext context, int index) {
                  return  new Column(
                      children: <Widget>[
                        new FlatButton(
                          child : new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(
                                width: MediaQuery.of(context).size.width*0.3,
                                child: new Text(snapshot.data[index].Name.toString()),
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width*0.22,
                                child: new Text(snapshot.data[index].Department.toString(),),
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width*0.22,
                                child: new Text(snapshot.data[index].Designation.toString(),),
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width*0.16,
                                child: new Text(snapshot.data[index].Status.toString(),style: TextStyle(color: snapshot.data[index].Status.toString()!='Active'?Colors.deepOrange:Colors.green),),
                              ),
                            ],
                          ),
                          onPressed: (){
                            null;
                            //    editDept(context,snapshot.data[index].dept.toString(),snapshot.data[index].status.toString(),snapshot.data[index].id.toString());
                          },),
                        Divider(color: Colors.blueGrey.withOpacity(0.25),height: 0.2,),
                      ]
                  );
                }
            );
          }
          return loader();
        }
    );
  }
}/////////mail class close
