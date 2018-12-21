import 'package:multi_shift/model/user.dart';
import 'package:dio/dio.dart';
import 'package:multi_shift/model/employee.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_shift/globals.dart' as globals;
import 'gethome.dart';
import 'package:multi_shift/model/timeinout.dart';
import 'saveimage.dart';
import 'newservices.dart';

class Login{

  var dio = new Dio();
  checkLogin(User user) async{
    String usrpwd = user.userPassword;

    try {
      final prefs = await SharedPreferences.getInstance();

      print(user.userName + "----");
      print(user.userPassword + "----");
      FormData formData = new FormData.from({
        "userName": user.userName,
        "password": user.userPassword,
        "device": "iOS"
      });

     // Response response1 = await dio.post("https://sandbox.ubiattendance.com/index.php/services/checkLogin",data: formData);
     // Response response1 = await dio.post("https://ubiattendance.ubihrm.com/index.php/services/checkLogin",data: formData);
      Response response1 = await dio.post(globals.path+"checkLogin", data: formData);
     // Response response1 = await dio.post("http://192.168.0.200/UBIHRM/HRMINDIA/services/checkLogin", data: formData);
      print("------->"+response1.toString());
      print(response1.statusCode.toString());
      if (response1.statusCode == 200) {
        Map employeeMap = json.decode(response1.data);
        print(employeeMap.toString());

        if (employeeMap["response"] == 1) {
          var user = new Employee.fromJson(employeeMap);
          print(user.fname + " " + user.lname);
          print(user.org_perm);
          prefs.setInt('response', user.response);
          prefs.setString('fname', user.fname);
          prefs.setString('lname', user.lname);
          prefs.setString('empid', user.empid);
          prefs.setString('email', user.email);
          prefs.setString('status', user.status);
          prefs.setString('orgid', user.orgid);
          prefs.setString('orgdir', user.orgid);
          prefs.setString('sstatus', user.sstatus);
          prefs.setString('org_name', user.org_name);
          prefs.setString('desination', user.desination);
          prefs.setString('desinationId', user.desinationId);
          prefs.setString('profile', user.profile);
          prefs.setString('org_perm', user.org_perm);
          prefs.setString('store', employeeMap["store"]);
          prefs.setString('buysts', employeeMap["buysts"]);
          prefs.setString('trialstatus', employeeMap["trialstatus"]);
          prefs.setString('orgmail', employeeMap["orgmail"]);
          prefs.setString('usrpwd', usrpwd);
          prefs.setString('lid', '0');
          //print(user.orgid+" "+user.org_name +" "+user.fname+" "+user.email);
          // default 0, check punch location id
         // prefs.setString('profile', "http://ubiattendance.ubihrm.com/assets/img/avatar.png");
          // prefs.setString('profile', "https://sandbox.ubiattendance.com/public/uploads/"+user.orgid+"/"+user.profile);
          //prefs.setString('profile', "http://192.168.0.200/UBIHRM/HRMINDIA/public/uploads/"+user.orgdir+"/"+user.profile);
          //prefs.setString('profile',"https://ubitech.ubihrm.com/public/uploads/" + user.orgdir + "/" +user.profile);
        //  print(user.orgdir);
          print(prefs.getString('profile'));
          return "success";
        } else {
          prefs.setInt('response', employeeMap["response"]);
          //print("asdfa");
          return "failure";
        }
      } else {
        return "Poor network connection.";
      }
    }catch(e){
      print(e.toString());
      return "Poor network connection.";
    }
    //print(userMap["response"]);
    //var values = userMap.keys.toList();
    //print(values);
  }

  checkLoginForQr(User user) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      print(user.userName + "----");
      print(user.userPassword + "----");
      if(user.userName=='' || user.userPassword=='')
        return "failure";
      FormData formData = new FormData.from({
        "userName": user.userName,
        "password": user.userPassword,
        "qr":true,
      });

      // Response response1 = await dio.post("https://sandbox.ubiattendance.com/index.php/services/checkLogin",data: formData);
      // Response response1 = await dio.post("https://ubiattendance.ubihrm.com/index.php/services/checkLogin",data: formData);
      Response response1 = await dio.post(globals.path+"checkLogin", data: formData);
      // Response response1 = await dio.post("http://192.168.0.200/UBIHRM/HRMINDIA/services/checkLogin", data: formData);
      print(response1.toString());
      print(response1.statusCode.toString());
      if (response1.statusCode == 200) {
        Map employeeMap = json.decode(response1.data);
        //print(employeeMap["response"]);

        if (employeeMap["response"] == 1) {
          var user = new Employee.fromJson(employeeMap);
          print(user.fname + " " + user.lname);
          print(user.org_perm);
          Home ho = new Home();
          StreamLocation sl = new StreamLocation();
          sl.startStreaming(1);
          Map timeinout = await ho.checkTimeInQR(user.empid, user.orgid);
          print(timeinout);
          var marktimeinout = MarkTime(timeinout["uid"].toString(), timeinout["location"], timeinout["aid"].toString(), timeinout["act"], timeinout["shiftId"], timeinout["refid"].toString(), timeinout["latit"].toString(), timeinout["longi"].toString());
          if(timeinout["act"]!="Imposed") {
            SaveImage mark = new SaveImage();
            bool res = await mark.saveTimeInOutQR(marktimeinout);
            if (res)
              return "success";
            else
              return "poor network";
          }else{
            return "imposed";
          }
        } else {
          return "failure";
        }
      } else {
        return "poor network";
      }
    }catch(e){
      print(e.toString());
      return "poor network";
    }
  }

  markAttByQR(String qr) async{
    List splitstring = qr.split("ykks==");
    User qruser = new User(splitstring[0], splitstring[1]);
    String result = await checkLoginForQr(qruser);
    return result;
    print(splitstring[0]);
    print(splitstring[1]);
    print(qr);
   //return "success";
  }

}