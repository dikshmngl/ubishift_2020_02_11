import 'package:shared_preferences/shared_preferences.dart';

class Shared{

  getSharedOrganizationName() async{
    final prefs = await SharedPreferences.getInstance();
    String org_name=prefs.getString('org_name');
    return org_name;
  }

}