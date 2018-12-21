import 'model/timeinout.dart';
String path="http://192.168.0.200/ubishift/index.php/Att_services/";
//String path="http://ec2-13-232-95-164.ap-south-1.compute.amazonaws.com/ubiattendance/index.php/att_services/";
//String path="https://sandbox.ubiattendance.com/index.php/Att_services/";
//String path="https://ubiattendance.ubihrm.com/index.php/Att_services/";
//String path_hrm_india="http://192.168.0.200/UBIHRM/HRMINDIA/services/"; //  FOR TIME OFF & FOR LEAVE
MarkTime mk1;
String path_hrm_india="https://ubitech.ubihrm.com/services/"; // FOR LEAVE
List<Map<String, double>> list = new List();
String globalstreamlocationaddr="";
bool stopstreamingstatus = false;
int department_permission = 0, designation_permission = 0, leave_permission = 0, shift_permission = 0, timeoff_permission = 1, punchlocation_permission = 1, employee_permission = 0, permission_module_permission = 0, report_permission = 0;
int globalalertcount = 0;