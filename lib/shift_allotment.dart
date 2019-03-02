import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:multi_shift/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'reports.dart';
import 'settings.dart';
import 'home.dart';
import 'globals.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';

class ShiftAllotment extends StatefulWidget {
  @override
  _ShiftAllotment createState() => _ShiftAllotment();
}
TextEditingController today;

//FocusNode f_dept ;
class _ShiftAllotment extends State<ShiftAllotment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  int _currentIndex = 1;
  String _orgName;
  bool res = true;
  String admin_sts='0';
  List<Map<String,String>> empList;
  var formatter = new DateFormat('dd-MMM-yyyy');
  @override
  void initState() {
    super.initState();
print(' state initilized....');
    getEmployeesWithIdName().then((data){
      setState(() {
        empList=data;
      });
      print(empList);

    });

    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    // f_dept = FocusNode();
    getOrgName();
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
            return;
          }
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
              MaterialPageRoute(builder: (context) => MyApp()),
            );
            return;
          }
          setState((){_currentIndex = newIndex;});
        },
        // this will be set when a new tab is tapped
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
            icon: new Icon(Icons.home,color: Colors.black54,),
            title: new Text('Home',style: TextStyle(color: Colors.black54)),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings'))
        ],
      ),
      endDrawer: new AppDrawer(),
      body: Container(
        //   padding: EdgeInsets.only(left: 2.0, right: 2.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Allot Shift',
                style: new TextStyle(
                  fontSize: 22.0,
                  color: Colors.black54,
                ),
              ),
            ),
            Divider(
              height: 10.0,
            ),
            SizedBox(height: 2.0),
            Container(
              child: DateTimePickerFormField(
                dateOnly: true,
                format: formatter,
                controller: today,
                decoration: InputDecoration(
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
            Center(
                child: new Form(
                  key: _formKey,
                  autovalidate: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new MultiSelect(
                          autovalidate: false,
                          titleText: 'Select Employees',
                          validator: (value) {
                            if (value == null) {
                              return 'Please select one or more option(s)2';
                            }
                          },
                          errorText: 'Please select one or more employee(s)1',
                          dataSource: empList,
                          textField: 'display',
                          valueField: 'value',
                          filterable: true,
                          required: true,
                          value: null,
                          onSaved: (value) {
                            print('The value is $value');
                          }),
                      SizedBox(
                        width: 10.0,
                      ),
                      RaisedButton(
                        child: Text(' Save ' ,style: TextStyle(color: Colors.white),),
                        color: Colors.orangeAccent,
                        onPressed: () {
                          _onFormSaved();
                        },
                      )
                    ],
                  ),
                ))
           /* new Expanded(
              child: res == true ? getEmpDataList(today.text) : Center(child: Text('No Employees Found'),),
            ),*/
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


  void _onFormSaved() {
    final FormState form = _formKey.currentState;
    form.save();
  }


} /////////mail class close
