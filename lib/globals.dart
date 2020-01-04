import 'model/timeinout.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

//String path           =   "https://ubishift-sandbox.ubihrm.com/index.php/Att_services/";
//String path_hrm_india =   "https://ubishift-sandbox.ubihrm.com/index.php/Att_services/";

//String path             =   "http://192.168.0.200/ubishift/index.php/Att_services/";
//String path_hrm_india   =   "http://192.168.0.200/ubishift/index.php/Att_services/";

String path           =   "https://admin.ubishift.com/index.php/Att_services/";
String path_hrm_india =   "https://admin.ubishift.com/index.php/Att_services/";

MarkTime mk1;
List<LocationData> list = new List();
String globalstreamlocationaddr="";
bool stopstreamingstatus = false;
int timeOff=0,bulkAttn = 0,geoFence=0,payroll=0,tracking=0,visitpunch=0,department_permission = 0, designation_permission = 0, leave_permission = 0, shift_permission = 0, timeoff_permission = 1, punchlocation_permission = 1, employee_permission = 0, permission_module_permission = 0, report_permission = 0;
int globalalertcount = 0;
bool showAppInbuiltCamera=false;
appBarColor(){
  return Color.fromRGBO(170, 212, 0,1);
}