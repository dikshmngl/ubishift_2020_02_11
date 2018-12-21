import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loc{
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  Location _location = new Location();
  String error;
  //Permission permission;
  @override

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    try {
      ////this.permission = Permission.AccessFineLocation;
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      bool res = true;//await SimplePermissions.checkPermission(permission);
      //print(res);
      if (res) {
        return fetchlocation();
      } else {
        return fetchlocation();
        //return requestPermission();
      }
    }catch(e){
      print(e.toString());
      return e.toString();
    }
  }

/*  requestPermission() async {
    final res  = await SimplePermissions.requestPermission(permission);
    bool res1 = await SimplePermissions.checkPermission(permission);
    //print("permission status is " + res.toString());
    //print(res);
    if(res.toString()=="PermissionStatus.authorized"){
      return fetchlocation();
    }else if(res.toString()=="PermissionStatus.deniedNeverAsk"){
      //bool opensett = await SimplePermissions.openSettings();
      //print("this is open settings "+ opensett.toString());
      return "PermissionStatus.deniedNeverAsk";
    }else{
      return requestPermission();
    }
  }
  checkPermission() async {
    bool res = await SimplePermissions.checkPermission(Permission.AccessFineLocation);
    print("permission is " + res.toString());
    return res;
  }*/

  fetchlatilongi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, double> location;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        location = await _location.getLocation();
        error = null;
        return location;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          error = 'Permission denied';
        } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          error =
          'Permission denied - please ask the user to enable it from the app settings';
        }
        location = null;
        return location;
      }
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      //if (!mounted) return;
      _startLocation = location;
      double latitude = _startLocation["latitude"];
      double longitude = _startLocation["longitude"];
      prefs.setString('latit', latitude.toString());
      prefs.setString('longi', longitude.toString());
      print(latitude);
      print(longitude);
      _location = null;
      location = null;
      final coordinates = new Coordinates(latitude, longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);
      var first = addresses.first;
      return "${first.featureName} : ${first.addressLine}";
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  fetchlocation() async {
    try {
      /*final prefs = await SharedPreferences.getInstance();
      Map<String, double> location;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        location = await _location.getLocation();
        error = null;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          error = 'Permission denied';
        } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          error =
          'Permission denied - please ask the user to enable it from the app settings';
        }
        location = null;
      }
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      //if (!mounted) return;
      _startLocation = location;
      double latitude = _startLocation["latitude"];
      double longitude = _startLocation["longitude"];
      prefs.setString('latit', latitude.toString());
      prefs.setString('longi', longitude.toString());
      print(latitude);
      print(longitude);
      _location = null;
      location = null;
      final coordinates = new Coordinates(latitude, longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);
      var first = addresses.first;
      return "${first.featureName} : ${first.addressLine}";*/
      return "Fetching location, please wait a while... or refresh";
    }catch(e){
      print(e.toString());
      return "Unable to fetch: Click below REFRESH link and make sure GPS is on to get location.";
    }
    }

    void handleDone(){
    print("done");
    }

}