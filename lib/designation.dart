import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:multi_shift/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'settings.dart';
import 'profile.dart';
import 'reports.dart';

class Designation extends StatefulWidget {
  @override
  _Designation createState() => _Designation();
}
TextEditingController desg;
class _Designation extends State<Designation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 2;
  String _sts = 'Active';
  String _sts1 = 'Active';
  String _orgName;
  String admin_sts='0';
  bool _isButtonDisabled= false;
  @override
  void initState() {
    super.initState();
    desg = new TextEditingController();
    getOrgName();
  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName= prefs.getString('org_name') ?? '';
      admin_sts= prefs.getString('sstatus') ?? '0';
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
            padding: EdgeInsets.only(left: 2.0, right: 2.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 8.0),
                Center(
                  child: Text('Designations',
                    style: new TextStyle(fontSize: 22.0, color: Colors.orangeAccent,),),
                ),
                Divider(height: 10.0,),
                SizedBox(height: 2.0),
                Container(
                  padding: EdgeInsets.only(left: 30.0,right: 30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Designations', style: TextStyle(
                          color: Colors.orange),),
                      Text('Status', style: TextStyle(
                          color: Colors.orange),),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(height: 5.0),
                new Expanded(
                  child: getDesgWidget(),

                ),

              ],
            ),

          ),
          floatingActionButton: new FloatingActionButton(
            mini: false,
            backgroundColor: Colors.blue,
            onPressed: (){
              setState(() {
                _isButtonDisabled=false;
              });
              _showDialog(context);
            },
            tooltip: 'Add Designation',
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

  getDesgWidget() {
    return new FutureBuilder<List<Desg>>(
        future: getDesignation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
                itemCount: snapshot.data.length,
                padding: EdgeInsets.only(left: 30.0,right: 30.0),
                itemBuilder: (BuildContext context, int index) {
                  return new Column(
                      children: <Widget>[
                  new FlatButton(
                  child : new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        // color: Colors.amber.shade400,
                        padding: EdgeInsets.only(top:5.0,bottom: 5.0),
                        margin: EdgeInsets.only(top:5.0),
                        alignment: FractionalOffset.center,
                        child: new Text(snapshot.data[index].desg.toString()),
                      ),
                      new Container(
                        // color: Colors.amber.shade400,
                        padding: EdgeInsets.only(top:7.0,bottom: 7.0),
                        alignment: FractionalOffset.center,
                        child: new Text(snapshot.data[index].status.toString(),style: TextStyle(color: snapshot.data[index].status.toString()!='Active'?Colors.deepOrange:Colors.green),),
                      ),
                    ],
                  ),
                      onPressed: (){
                        //null;
                        editDesg(context,snapshot.data[index].desg.toString(),snapshot.data[index].status.toString(),snapshot.data[index].id.toString());
                      }

                  ),
                  Divider(color: Colors.blueGrey.withOpacity(0.25),),]
                  );
                }
            );
          }
          return loader();
        }
    );
  }
  ////////////////drop down- start

  _showDialog(context) async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          height: MediaQuery.of(context).size.height*0.20,
          child: Column(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: desg,
                  autofocus: false,
                  //   controller: client_name,
                  decoration: new InputDecoration(
                      labelText: 'Designation ', hintText: 'Designation Name'),
                ),
              ),
              new Expanded(
                child:  new InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  isEmpty: _sts == '',
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      value: _sts,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _sts = newValue;
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                          _showDialog(context);
                        });
                      },
                      items: <String>['Active', 'Inactive'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              shape: Border.all(color: Colors.black54),
              child: const Text('CANCEL',style: TextStyle(color: Colors.black),),
              onPressed: () {
                desg.text='';
                _sts='Active';
                Navigator.of(context, rootNavigator: true).pop('dialog');
              }),
          new RaisedButton(
              color: Colors.orangeAccent,
              child: (_isButtonDisabled)?Text('WAIT...'):Text('SAVE',style: TextStyle(color: Colors.white),),
              onPressed: ()
              {

                if(desg.text==''){
                    showInSnackBar('Input Designation');
                  }
                else {
                  if(_isButtonDisabled)
                    return null;
                  setState(() {
                    _isButtonDisabled=true;
                  });

                  addDesg(desg.text, _sts).
                  then((res) {
                    if(res=='0')
                      showInSnackBar('Unable to add designation');
                    else if(res=='-1')
                      showInSnackBar('Designation already exists');
                    else {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      showInSnackBar('Designation added successfully');
                      getDesgWidget();
                      desg.text = '';
                      _sts = 'Active';
                    }

                    setState(() {
                      _isButtonDisabled=false;
                    });
                  }
                  ).catchError((err){
                    showInSnackBar('unable to call service');
                    setState(() {
                      _isButtonDisabled=false;
                    });
                  });
                }

              }),
        ],
      ),
    );
  }
////////////////drop down- end


/******************* Editing Designation ************************************/

//////////edit department
  editDesg(context,dept,sts,did) async {
    _sts1=sts;
    var new_dept = new TextEditingController();
    new_dept.text=dept;
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          height: MediaQuery.of(context).size.height*0.20,
          child: Column(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: new_dept,
                  //    focusNode: f_dept,
                  autofocus: false,
                  //   controller: client_name,
                  decoration: new InputDecoration(
                      labelText: dept, hintText: dept),
                ),
              ),
              new Expanded(
                child:  new InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  isEmpty: _sts1 == '',
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      value: _sts1,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _sts1 = newValue;
                          Navigator.of(context, rootNavigator: true).pop('dialog'); // here I pop to avoid multiple Dialogs
                          //print("this is set state"+_sts1);
                          editDesg(context, dept, _sts1, did);
                        });
                      },
                      items: <String>['Active', 'Inactive'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              shape: Border.all(color: Colors.black54),
              child: const Text('CANCEL',style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              }),
          new RaisedButton(
              color: Colors.orangeAccent,
              child: const Text('UPDATE', style: TextStyle(color: Colors.white)),
              onPressed: ()
              {
                if( new_dept.text==''){
                  //  FocusScope.of(context).requestFocus(f_dept);
                  showInSnackBar('Input Designation Name');
                }
                else {
                  if(_isButtonDisabled)
                    return null;
                  setState(() {
                    _isButtonDisabled=true;
                  });
                  updateDesg(new_dept.text,_sts1,did).
                  then((res) {
                    if(res=='0')
                      showInSnackBar('Unable to update designation');
                    else if(res=='-1')
                      showInSnackBar('Designation name already exist');
                    else {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      showInSnackBar('Designation updated successfully');
                      getDesgWidget();
                      new_dept.text = '';
                      _sts1 = 'Active';
                    }

                    setState(() {
                      _isButtonDisabled=false;
                    });
                  }
                  );
                }

              }),
        ],
      ),
    );
  }
//////////edit department-end



}/////////mail class close
