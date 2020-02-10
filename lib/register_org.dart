import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'askregister.dart';
import 'package:multi_shift/services/checklogin.dart';
import 'home.dart';
import 'package:multi_shift/model/user.dart';
import 'globals.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MyHomePage(title: 'ubiShift');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _name,_cname,_email,_pass,_cont,_phone,_city,_contcode;
  bool loader = false;
  bool _isButtonDisabled = false;
  final FocusNode __name = FocusNode();
  final FocusNode __cname = FocusNode();
  final FocusNode __email = FocusNode();
  final FocusNode __pass = FocusNode();
  final FocusNode __cont = FocusNode();
  final FocusNode __contcode = FocusNode();
  final FocusNode __phone = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  Map<String, dynamic>res;
  List<Map> _myJson = [{ "ind": "0"    ,   "id": "2"  ,   "name": "Afghanistan"  ,   "countrycode": "+93"}    ,
    { "ind":"1"       ,      "id": "4"  ,   "name": "Albania"  ,   "countrycode": "+355"}    ,
    { "ind":"2"       ,      "id": "50"  ,   "name": "Algeria"  ,   "countrycode": "+213"}    ,
    { "ind":"3"       ,      "id": "5"  ,   "name": "American Samoa"  ,   "countrycode": "+1"}    ,
    { "ind":"4"       ,      "id": "6"  ,   "name": "Andorra"  ,   "countrycode": "+376"}    ,
    { "ind":"5"       ,      "id": "7"  ,   "name": "Angola"  ,   "countrycode": "+244"}    ,
    { "ind":"6"       ,      "id": "11"  ,   "name": "Anguilla"  ,   "countrycode": "+264"}      ,
    { "ind":"7"       ,      "id": "3"  ,   "name": "Antigua and Barbuda"  ,   "countrycode": "+1"}      ,
    { "ind":"8"       ,      "id": "160"  ,   "name": "Argentina"  ,   "countrycode": "+54"}      ,
    { "ind":"9"       ,      "id": "8"  ,   "name": "Armenia"  ,   "countrycode": "+374"}      ,
    { "ind":"10"     ,      "id": "9"  ,   "name": "Aruba"  ,   "countrycode": "+297"}      ,
    { "ind":"11"     ,      "id": "10"  ,   "name": "Australia"  ,   "countrycode": "+61"}      ,
    { "ind":"12"     ,      "id": "1"  ,   "name": "Austria"  ,   "countrycode": "+43"}      ,
    { "ind":"13"     ,       "id": "12"  ,   "name": "Azerbaijan"  ,   "countrycode": "+994"}      ,
    { "ind":"14"     ,      "id": "27"  ,   "name": "Bahamas"  ,   "countrycode": "+242"}      ,
    { "ind":"15"     ,      "id": "25"  ,   "name": "Bahrain"  ,   "countrycode": "+973"}      ,
    { "ind":"16"     ,      "id": "14"  ,   "name": "Bangladesh"  ,   "countrycode": "+880"}      ,
    { "ind":"17"     ,      "id": "15"  ,   "name": "Barbados"  ,   "countrycode": "+246"}      ,
    { "ind":"18"     ,      "id": "29"  ,   "name": "Belarus"  ,   "countrycode": "+375"}      ,
    { "ind":"19"     ,      "id": "13"  ,   "name": "Belgium"  ,   "countrycode": "+32"}      ,
    { "ind":"20"     ,      "id": "30"  ,   "name": "Belize"  ,   "countrycode": "+501"}      ,
    { "ind":"21"     ,      "id": "16"  ,   "name": "Benin"  ,   "countrycode": "+229"}      ,
    { "ind":"22"     ,      "id": "17"  ,   "name": "Bermuda"  ,   "countrycode": "+441"}      ,
    { "ind":"23"     ,      "id": "20"  ,   "name": "Bhutan"  ,   "countrycode": "+975"}      ,
    { "ind":"24"     ,      "id": "23"  ,   "name": "Bolivia"  ,   "countrycode": "+591"}      ,
    { "ind":"25"     ,      "id": "22"  ,   "name": "Bosnia and Herzegovina"  ,   "countrycode": "+387"}      ,
    { "ind":"26"     ,      "id": "161"  ,   "name": "Botswana"  ,   "countrycode": "+267"}      ,
    { "ind":"27"     ,      "id": "24"  ,   "name": "Brazil"  ,   "countrycode": "+55"}      ,
    { "ind":"28"     ,      "id": "28"  ,   "name": "British Virgin Islands"  ,   "countrycode": "+284"}      ,
    { "ind":"29"     ,      "id": "26"  ,   "name": "Brunei"  ,   "countrycode": "+673"}      ,
    { "ind":"30"     ,      "id": "19"  ,   "name": "Bulgaria"  ,   "countrycode": "+359"}      ,
    { "ind":"31"     ,      "id": "18"  ,   "name": "Burkina Faso"  ,   "countrycode": "+226"}      ,
    { "ind":"32"     ,      "id": "21"  ,   "name": "Burundi"  ,   "countrycode": "+257"}      ,
    { "ind":"33"     ,      "id": "101"  ,   "name": "Cambodia"  ,   "countrycode": "+855"}      ,
    { "ind":"34"     ,      "id": "32"  ,   "name": "Cameroon"  ,   "countrycode": "+237"}      ,
    { "ind":"35"     ,      "id": "34"  ,   "name": "Canada"  ,   "countrycode": "+1"}      ,
    { "ind":"36"     ,      "id": "43"  ,   "name": "Cape Verde"  ,   "countrycode": "+238"}      ,
    { "ind":"37"     ,      "id": "33"  ,   "name": "Cayman Islands"  ,   "countrycode": "+345"}      ,
    { "ind":"38"     ,      "id": "163"  ,   "name": "Central African Republic"  ,   "countrycode": "+236"}      ,
    { "ind":"39"     ,      "id": "203"  ,   "name": "Chad"  ,   "countrycode": "+235"}      ,
    { "ind":"40"     ,      "id": "165"  ,   "name": "Chile"  ,   "countrycode": "+56"}      ,
    { "ind":"41"     ,      "id": "205"  ,   "name": "China"  ,   "countrycode": "+86"}      ,
    { "ind":"42"     ,      "id": "233"  ,   "name": "Christmas Island"  ,   "countrycode": "+61"}      ,
    { "ind":"43"     ,      "id": "39"  ,   "name": "Cocos Islands"  ,   "countrycode": "+891"}      ,
    { "ind":"44"     ,      "id": "38"  ,   "name": "Colombia"  ,   "countrycode": "+57"}      ,
    { "ind":"45"     ,      "id": "40"  ,   "name": "Comoros"  ,   "countrycode": "+269"}      ,
    { "ind":"46"     ,      "id": "41"  ,   "name": "Cook Islands"  ,   "countrycode": "+682"}      ,
    { "ind":"47"     ,      "id": "42"  ,   "name": "Costa Rica"  ,   "countrycode": "+506"}      ,
    { "ind":"48"     ,      "id": "36"  ,   "name": "Cote dIvoire"  ,   "countrycode": "+225"}      ,
    { "ind":"49"     ,      "id": "90"  ,   "name": "Croatia"  ,   "countrycode": "+385"}      ,
    { "ind":"50"     ,      "id": "31"  ,   "name": "Cuba"  ,   "countrycode": "+53"}      ,
    { "ind":"51"     ,      "id": "44"  ,   "name": "Cyprus"  ,   "countrycode": "+357"}      ,
    { "ind":"52"     ,      "id": "45"  ,   "name": "Czech Republic"  ,   "countrycode": "+420"}      ,
    { "ind":"53"     ,      "id": "48"  ,   "name": "Denmark"  ,   "countrycode": "+45"}      ,
    { "ind":"54"     ,      "id": "47"  ,   "name": "Djibouti"  ,   "countrycode": "+253"}      ,
    { "ind":"55"     ,      "id": "226"  ,   "name": "Dominica"  ,   "countrycode": "+767"}      ,
    { "ind":"56"     ,      "id": "49"  ,   "name": "Dominican Republic"  ,   "countrycode": "+1"}      ,
    { "ind":"57"     ,      "id": "55"  ,   "name": "Ecuador"  ,   "countrycode": "+593"}      ,
    { "ind":"58"     ,      "id": "58"  ,   "name": "Egypt"  ,   "countrycode": "+20"}      ,
    { "ind":"59"     ,      "id": "57"  ,   "name": "El Salvador"  ,   "countrycode": "+503"}      ,
    { "ind":"60"     ,      "id": "80"  ,   "name": "Equatorial Guinea"  ,   "countrycode": "+240"}      ,
    { "ind":"60"     ,      "id": "56"  ,   "name": "Eritrea"  ,   "countrycode": "+291"}      ,
    { "ind":"62"     ,      "id": "60"  ,   "name": "Estonia"  ,   "countrycode": "+372"}      ,
    { "ind":"63"     ,      "id": "59"  ,   "name": "Ethiopia"  ,   "countrycode": "+251"}      ,
    { "ind":"64"     ,      "id": "62"  ,   "name": "Falkland Islands"  ,   "countrycode": "+500"}      ,
    { "ind":"65"     ,      "id": "63"  ,   "name": "Faroe Islands"  ,   "countrycode": "+298"}      ,
    { "ind":"66"     ,      "id": "65"  ,   "name": "Fiji"  ,   "countrycode": "+679"}      ,
    { "ind":"67"     ,      "id": "186"  ,   "name": "Finland"  ,   "countrycode": "+358"}      ,
    { "ind":"68"     ,      "id": "61"  ,   "name": "France"  ,   "countrycode": "+33"}      ,
    { "ind":"69"     ,      "id": "64"  ,   "name": "French Guiana"  ,   "countrycode": "+594"}      ,
    { "ind":"70"     ,      "id": "67"  ,   "name": "French Polynesia"  ,   "countrycode": "+689"}      ,
    { "ind":"71"     ,      "id": "69"  ,   "name": "Gabon"  ,   "countrycode": "+241"}      ,
    { "ind":"72"     ,      "id": "223"  ,   "name": "Gambia"  ,   "countrycode": "+220"}      ,
    { "ind":"73"     ,      "id": "70"  ,   "name": "Gaza Strip"  ,   "countrycode": "+970"}      ,
    { "ind":"74"     ,      "id": "77"  ,   "name": "Georgia"  ,   "countrycode": "+995"}      ,
    { "ind":"75"     ,      "id": "46"  ,   "name": "Germany"  ,   "countrycode": "+49"}      ,
    { "ind":"76"     ,      "id": "78"  ,   "name": "Ghana"  ,   "countrycode": "+233"}      ,
    { "ind":"77"     ,      "id": "75" ,"name": "Gibraltar"  ,   "countrycode": "+350"}      ,
    { "ind":"78"     ,      "id": "81"  ,   "name": "Greece"  ,   "countrycode": "+30"}      ,
    { "ind":"79"     ,      "id": "82"  ,   "name": "Greenland"  ,   "countrycode": "+299"}      ,
    { "ind":"80"     ,      "id": "228"  ,   "name": "Grenada"  ,   "countrycode": "+473"}      ,
    { "ind":"81"     ,      "id": "83"  ,   "name": "Guadeloupe"  ,   "countrycode": "+590"}      ,
    { "ind":"82"     ,      "id": "84"  ,   "name": "Guam"  ,   "countrycode": "+1"}      ,
    { "ind":"83"     ,      "id": "76"  ,   "name": "Guatemala"  ,   "countrycode": "+502"}      ,
    { "ind":"84"     ,      "id": "72"  ,   "name": "Guernsey"  ,   "countrycode": "+44"}      ,
    { "ind":"85"     ,      "id": "167"  ,   "name": "Guinea"  ,   "countrycode": "+224"}      ,
    { "ind":"86"     ,      "id": "79"  ,   "name": "Guinea-Bissau"  ,   "countrycode": "+245"}      ,
    { "ind":"87"     ,      "id": "85"  ,   "name": "Guyana"  ,   "countrycode": "+592"}      ,
    { "ind":"88"     ,      "id": "168"  ,   "name": "Haiti"  ,   "countrycode": "+509"}      ,
    { "ind":"89"     ,      "id": "218"  ,   "name": "Holy See"  ,   "countrycode": "+379"}      ,
    { "ind":"90"     ,      "id": "87"  ,   "name": "Honduras"  ,   "countrycode": "+504"}      ,
    { "ind":"91"     ,      "id": "89"  ,   "name": "Hong Kong"  ,   "countrycode": "+852"}      ,
    { "ind":"92"     ,      "id": "86"  ,   "name": "Hungary"  ,   "countrycode": "+36"}      ,
    { "ind":"93"     ,      "id": "97"  ,   "name": "Iceland"  ,   "countrycode": "+354"}      ,
    { "ind":"94"     ,      "id": "93"  ,   "name": "India"  ,   "countrycode": "+91"}      ,
    { "ind":"95"     ,      "id": "169"  ,   "name": "Indonesia"  ,   "countrycode": "+62"}      ,
    { "ind":"96"     ,      "id": "94"  ,   "name": "Iran"  ,   "countrycode": "+98"}      ,
    { "ind":"97"     ,      "id": "96"  ,   "name": "Iraq"  ,   "countrycode": "+964"}      ,
    { "ind":"98"     ,      "id": "95"  ,   "name": "Ireland"  ,   "countrycode": "+353"}      ,
    { "ind":"99"     ,      "id": "74"  ,   "name": "Isle of Man"  ,   "countrycode": "+44"}      ,
    { "ind":"100"     ,      "id": "92"  ,   "name": "Israel"  ,   "countrycode": "+972"}      ,
    { "ind":"101"     ,      "id": "91"  ,   "name": "Italy"  ,   "countrycode": "+39"}      ,
    { "ind":"102"     ,      "id": "99"  ,   "name": "Jamaica"  ,   "countrycode": "+876"}      ,
    { "ind":"103"     ,      "id": "98"  ,   "name": "Japan"  ,   "countrycode": "+81"}      ,
    { "ind":"104"     ,      "id": "73"  ,   "name": "Jersey"  ,   "countrycode": "+44"}      ,
    { "ind":"105"     ,      "id": "100"  ,   "name": "Jordan"  ,   "countrycode": "+962"}      ,
    { "ind":"106"     ,      "id": "102"  ,   "name": "Kazakhstan"  ,   "countrycode": "+7"}      ,
    { "ind":"107"     ,      "id": "52"  ,   "name": "Kenya"  ,   "countrycode": "+254"}      ,
    { "ind":"108"     ,      "id": "104"  ,   "name": "Kiribati"  ,   "countrycode": "+686"}      ,
    { "ind":"109"     ,      "id": "106"  ,   "name": "Kosovo"  ,   "countrycode": "+383"}      ,
    { "ind":"110"     ,      "id": "107"  ,   "name": "Kuwait"  ,   "countrycode": "+965"}      ,
    { "ind":"111"     ,      "id": "103"  ,   "name": "Kyrgyzstan"  ,   "countrycode": "+996"}      ,
    { "ind":"112"     ,      "id": "109"  ,   "name": "Laos"  ,   "countrycode": "+856"}      ,
    { "ind":"113"     ,      "id": "114"  ,   "name": "Latvia"  ,   "countrycode": "+371"}      ,
    { "ind":"114"     ,      "id": "171"  ,   "name": "Lebanon"  ,   "countrycode": "+961"}      ,
    { "ind":"115"     ,      "id": "112"  ,   "name": "Lesotho"  ,   "countrycode": "+266"}      ,
    { "ind":"116"     ,      "id": "111"  ,   "name": "Liberia"  ,   "countrycode": "+231"}      ,
    { "ind":"117"     ,      "id": "110"  ,   "name": "Libya"  ,   "countrycode": "+218"}      ,
    { "ind":"118"     ,      "id": "66"  ,   "name": "Liechtenstein"  ,   "countrycode": "+423"}      ,
    { "ind":"119"     ,      "id": "113"  ,   "name": "Lithuania"  ,   "countrycode": "+370"}      ,
    { "ind":"120"     ,      "id": "108"  ,   "name": "Luxembourg"  ,   "countrycode": "+352"}      ,
    { "ind":"121"     ,      "id": "117"  ,   "name": "Macau"  ,   "countrycode": "+853"}      ,
    { "ind":"122"     ,      "id": "125"  ,   "name": "Macedonia"  ,   "countrycode": "+389"}      ,
    { "ind":"123"     ,      "id": "172"  ,   "name": "Madagascar"  ,   "countrycode": "+261"}      ,
    { "ind":"124"     ,      "id": "132"  ,   "name": "Malawi"  ,   "countrycode": "+265"}      ,
    { "ind":"125"     ,      "id": "118"  ,   "name": "Malaysia"  ,   "countrycode": "+60"}      ,
    { "ind":"126"     ,      "id": "131"  ,   "name": "Maldives"  ,   "countrycode": "+960"}      ,
    { "ind":"127"     ,      "id": "173"  ,   "name": "Mali"  ,   "countrycode": "+223"}      ,
    { "ind":"128"     ,      "id": "115"  ,   "name": "Malta"  ,   "countrycode": "+356"}      ,
    { "ind":"129"     ,      "id": "124"  ,   "name": "Marshall Islands"  ,   "countrycode": "+692"}      ,
    { "ind":"130"     ,      "id": "119"  ,   "name": "Martinique"  ,   "countrycode": "+596"}      ,
    { "ind":"131"     ,      "id": "170"  ,   "name": "Mauritania"  ,   "countrycode": "+222"}      ,
    { "ind":"132"     ,      "id": "130"  ,   "name": "Mauritius"  ,   "countrycode": "+230"}      ,
    { "ind":"133"     ,      "id": "120"  ,   "name": "Mayotte"  ,   "countrycode": "+262"}      ,
    { "ind":"134"     ,      "id": "123"  ,   "name": "Mexico"  ,   "countrycode": "+52"}      ,
    { "ind":"135"     ,      "id": "68"  ,   "name": "Micronesia"  ,   "countrycode": "+691"}      ,
    { "ind":"136"     ,      "id": "122"  ,   "name": "Moldova"  ,   "countrycode": "+373"}      ,
    { "ind":"137"     ,      "id": "121"  ,   "name": "Monaco"  ,   "countrycode": "+377"}      ,
    { "ind":"138"     ,      "id": "127"  ,   "name": "Mongolia"  ,   "countrycode": "+976"}      ,
    { "ind":"139"     ,      "id": "126"  ,   "name": "Montenegro"  ,   "countrycode": "+382"}      ,
    { "ind":"140"     ,      "id": "128"  ,   "name": "Montserrat"  ,   "countrycode": "+664"}      ,
    { "ind":"141"     ,      "id": "116"  ,   "name": "Morocco"  ,   "countrycode": "+212"}      ,
    { "ind":"142"     ,      "id": "129"  ,   "name": "Mozambique"  ,   "countrycode": "+258"}      ,
    { "ind":"143"     ,      "id": "133"  ,   "name": "Myanmar"  ,   "countrycode": "+95"}      ,
    { "ind":"144"     ,      "id": "136"  ,   "name": "Namibia"  ,   "countrycode": "+264"}      ,
    { "ind":"145"     ,      "id": "137"  ,   "name": "Nauru"  ,   "countrycode": "+674"}      ,
    { "ind":"146"     ,      "id": "139"  ,   "name": "Nepal"  ,   "countrycode": "+977"}      ,
    { "ind":"147"     ,      "id": "142"  ,   "name": "Netherlands"  ,   "countrycode": "+31"}      ,
    { "ind":"148"     ,      "id": "135"  ,   "name": "Netherlands Antilles"  ,   "countrycode": "+599"}      ,
    { "ind":"149"     ,      "id": "138"  ,   "name": "New Caledonia"  ,   "countrycode": "+687"}      ,
    { "ind":"150"     ,      "id": "146"  ,   "name": "New Zealand"  ,   "countrycode": "+64"}      ,
    { "ind":"151"     ,      "id": "140"  ,   "name": "Nicaragua"  ,   "countrycode": "+505"}      ,
    { "ind":"152"     ,      "id": "174"  ,   "name": "Niger"  ,   "countrycode": "+227"}      ,
    { "ind":"153"     ,      "id": "225"  ,   "name": "Nigeria"  ,   "countrycode": "+234"}      ,
    { "ind":"154"     ,      "id": "141"  ,   "name": "Niue"  ,   "countrycode": "+683"}      ,
    { "ind":"155"     ,      "id": "144"  ,   "name": "North Korea"  ,   "countrycode": "+850"}      ,
    { "ind":"156"     ,      "id": "143"  ,   "name": "Northern Mariana Islands"  ,   "countrycode": "+1"}      ,
    { "ind":"157"     ,      "id": "134"  ,   "name": "Norway"  ,   "countrycode": "+47"}      ,
    { "ind":"158"     ,      "id": "147"  ,   "name": "Oman"  ,   "countrycode": "+968"}      ,
    { "ind":"159"     ,      "id": "153"  ,   "name": "Pakistan"  ,   "countrycode": "+92"}      ,
    { "ind":"160"     ,      "id": "150"  ,   "name": "Palau"  ,   "countrycode": "+680"}      ,
    { "ind":"161"     ,      "id": "149"  ,   "name": "Panama"  ,   "countrycode": "+507"}      ,
    { "ind":"162"     ,      "id": "155"  ,   "name": "Papua New Guinea"  ,   "countrycode": "+675"}      ,
    { "ind":"163"     ,      "id": "157"  ,   "name": "Paraguay"  ,   "countrycode": "+595"}      ,
    { "ind":"164"     ,      "id": "151"  ,   "name": "Peru"  ,   "countrycode": "+51"}      ,
    { "ind":"165"     ,      "id": "178"  ,   "name": "Philippines"  ,   "countrycode": "+63"}      ,
    { "ind":"166"     ,      "id": "152"  ,   "name": "Pitcairn Islands"  ,   "countrycode": "+64"}      ,
    { "ind":"167"     ,      "id": "154"  ,   "name": "Poland"  ,   "countrycode": "+48"}      ,
    { "ind":"168"     ,      "id": "148"  ,   "name": "Portugal"  ,   "countrycode": "+351"}      ,
    { "ind":"169"     ,      "id": "156"  ,   "name": "Puerto Rico"  ,   "countrycode": "+1"}      ,
    { "ind":"170"     ,      "id": "158"  ,   "name": "Qatar"  ,   "countrycode": "+974"}      ,
    { "ind":"171"     ,      "id": "164"  ,   "name": "Republic of the Congo"  ,   "countrycode": "+243"}      ,
    { "ind":"172"     ,      "id": "166"  ,   "name": "Reunion"  ,   "countrycode": "+262"}      ,
    { "ind":"173"     ,      "id": "175"  ,   "name": "Romania"  ,   "countrycode": "+40"}      ,
    { "ind":"174"     ,      "id": "159"  ,   "name": "Russia"  ,   "countrycode": "+7"}      ,
    { "ind":"175"     ,      "id": "182"  ,   "name": "Rwanda"  ,   "countrycode": "+250"}      ,
    { "ind":"176"     ,      "id": "88"  ,   "name": "Saint Helena"  ,   "countrycode": "+290"}      ,
    { "ind":"177"     ,      "id": "105"  ,   "name": "Saint Kitts and Nevis"  ,   "countrycode": "+869"}      ,
    { "ind":"178"     ,      "id": "229"  ,   "name": "Saint Lucia"  ,   "countrycode": "+758"}      ,
    { "ind":"179"     ,      "id": "191"  ,   "name": "Saint Martin"  ,   "countrycode": "+1"}      ,
    { "ind":"180"     ,      "id": "195"  ,   "name": "Saint Pierre and Miquelon"  ,   "countrycode": "+508"}      ,
    { "ind":"181"     ,      "id": "232"  ,   "name": "Saint Vincent and the Grenadines"  ,   "countrycode": "+784"}      ,
    { "ind":"182"     ,      "id": "230"  ,   "name": "Samoa"  ,   "countrycode": "+685"}      ,
    { "ind":"183"     ,      "id": "180"  ,   "name": "San Marino"  ,   "countrycode": "+378"}      ,
    { "ind":"184"     ,      "id": "197"  ,   "name": "Sao Tome and Principe"  ,   "countrycode": "+239"}      ,
    { "ind":"185"     ,      "id": "184"  ,   "name": "Saudi Arabia"  ,   "countrycode": "+966"}      ,
    { "ind":"186"     ,      "id": "193"  ,   "name": "Senegal"  ,   "countrycode": "+221"}      ,
    { "ind":"187"     ,      "id": "196"  ,   "name": "Serbia"  ,   "countrycode": "+381"}      ,
    { "ind":"188"     ,      "id": "200"  ,   "name": "Seychelles"  ,   "countrycode": "+248"}      ,
    { "ind":"189"     ,      "id": "224"  ,   "name": "Sierra Leone"  ,   "countrycode": "+232"}      ,
    { "ind":"190"     ,      "id": "187"  ,   "name": "Singapore"  ,   "countrycode": "+65"}      ,
    { "ind":"191"     ,      "id": "188"  ,   "name": "Slovakia"  ,   "countrycode": "+421"}      ,
    { "ind":"192"     ,      "id": "190"  ,   "name": "Slovenia"  ,   "countrycode": "+386"}      ,
    { "ind":"193"     ,      "id": "189"  ,   "name": "Solomon Islands"  ,   "countrycode": "+677"}      ,
    { "ind":"194"     ,      "id": "194"  ,   "name": "Somalia"  ,   "countrycode": "+252"}      ,
    { "ind":"195"     ,      "id": "179"  ,   "name": "South Africa"  ,   "countrycode": "+27"}      ,
    { "ind":"196"     ,      "id": "176"  ,   "name": "South Korea"  ,   "countrycode": "+82"}      ,
    { "ind":"197"     ,      "id": "51"  ,   "name": "Spain"  ,   "countrycode": "+34"}      ,
    { "ind":"198"     ,      "id": "37"  ,   "name": "Sri Lanka"  ,   "countrycode": "+94"}      ,
    { "ind":"299"     ,      "id": "198"  ,   "name": "Sudan"  ,   "countrycode": "+249"}      ,
    { "ind":"200"     ,      "id": "192"  ,   "name": "Suriname"  ,   "countrycode": "+597"}      ,
    { "ind":"201"     ,      "id": "199"  ,   "name": "Svalbard"  ,   "countrycode": "+47"}      ,
    { "ind":"202"     ,      "id": "185"  ,   "name": "Swaziland"  ,   "countrycode": "+268"}      ,
    { "ind":"203"     ,      "id": "183"  ,   "name": "Sweden"  ,   "countrycode": "+46"}      ,
    { "ind":"204"     ,      "id": "35"  ,   "name": "Switzerland"  ,   "countrycode": "+41"}      ,
    { "ind":"205"     ,      "id": "201"  ,   "name": "Syria"  ,   "countrycode": "+963"}      ,
    { "ind":"206"     ,      "id": "162"  ,   "name": "Taiwan"  ,   "countrycode": "+886"}      ,
    { "ind":"207"     ,      "id": "202"  ,   "name": "Tajikistan"  ,   "countrycode": "+992"}      ,
    { "ind":"208"     ,      "id": "53"  ,   "name": "Tanzania"  ,   "countrycode": "+255"}      ,
    { "ind":"209"     ,      "id": "204"  ,   "name": "Thailand"  ,   "countrycode": "+66"}      ,
    { "ind":"210"     ,      "id": "206"  ,   "name": "Timor-Leste"  ,   "countrycode": "+670"}      ,
    { "ind":"211"     ,      "id": "181"  ,   "name": "Togo"  ,   "countrycode": "+228"}      ,
    { "ind":"212"     ,      "id": "209"  ,   "name": "Tonga"  ,   "countrycode": "+676"}      ,
    { "ind":"213"     ,      "id": "211"  ,   "name": "Trinidad and Tobago"  ,   "countrycode": "+868"}      ,
    { "ind":"214"     ,      "id": "208"  ,   "name": "Tunisia"  ,   "countrycode": "+216"}      ,
    { "ind":"215"     ,      "id": "210"  ,   "name": "Turkey"  ,   "countrycode": "+90"}      ,
    { "ind":"216"     ,      "id": "207"  ,   "name": "Turkmenistan"  ,   "countrycode": "+993"}      ,
    { "ind":"217"     ,      "id": "212"  ,   "name": "Turks and Caicos Islands"  ,   "countrycode": "+1"}      ,
    { "ind":"218"     ,      "id": "213"  ,   "name": "Tuvalu"  ,   "countrycode": "+688"}      ,
    { "ind":"219"     ,      "id": "219"  ,   "name": "U.S. Virgin Islands"  ,   "countrycode": "+1"}      ,
    { "ind":"220"     ,      "id": "54"  ,   "name": "Uganda"  ,   "countrycode": "+256"}      ,
    { "ind":"221"     ,      "id": "214"  ,   "name": "Ukraine"  ,   "countrycode": "+380"}      ,
    { "ind":"222"     ,      "id": "215"  ,   "name": "United Arab Emirates"  ,   "countrycode": "+971"}      ,
    { "ind":"223"     ,      "id": "71" ,   "name": "United Kingdom" ,   "countrycode": "+44"}      ,
    { "ind":"224"    ,      "id": "216" ,   "name": "United States" ,   "countrycode": "+1"}      ,
    { "ind":"225"    ,      "id": "177" ,   "name": "Uruguay" ,   "countrycode": "+598"}      ,
    { "ind":"226"    ,      "id": "217" ,   "name": "Uzbekistan" ,   "countrycode": "+998"}      ,
    { "ind":"227"    ,      "id": "221" ,   "name": "Vanuatu" ,   "countrycode": "+678"}      ,
    { "ind":"228"    ,      "id": "235" ,   "name": "Venezuela" ,   "countrycode": "+58"}      ,
    { "ind":"229"    ,      "id": "220" ,   "name": "Vietnam" ,   "countrycode": "+84"}      ,
    { "ind":"230"    ,      "id": "222" ,   "name": "Wallis and Futuna" ,   "countrycode": "+681"}      ,
    { "ind":"231"    ,      "id": "227" ,   "name": "West Bank" ,   "countrycode": "+970"}      ,
    { "ind":"232"    ,      "id": "231" ,   "name": "Western Sahara" ,   "countrycode": "+212"}      ,
    { "ind":"233"    ,      "id": "234" ,   "name": "Yemen" ,   "countrycode": "+967"}      ,
    { "ind":"234"    ,      "id": "237" ,   "name": "Zaire" ,   "countrycode": "+243"}      ,
    { "ind":"235"    ,      "id": "236" ,   "name": "Zambia" ,   "countrycode": "+260"}      ,
    { "ind":"236"    ,      "id": "238" ,   "name": "Zimbabwe" ,   "countrycode": "+263"} ];

  String _country;
  bool _obscureText = true;
  String  _tempcontry  = '';
  @override
  void initState() {
    _name = new TextEditingController();
    _cname = new TextEditingController();
    _email = new TextEditingController();
    _phone = new TextEditingController();
    _pass = new TextEditingController();
    _cont = new TextEditingController();
    _city = new TextEditingController();
    _contcode = new TextEditingController();
    super.initState();
  }
  setLocal(var fname, var empid, var  orgid) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('fname',fname);
    await prefs.setString('empid',empid);
    await prefs.setString('orgid',orgid);
  }
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text("ubiShift", style: new TextStyle(fontSize: 20.0)),
            ],
          ),
          leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AskRegisterationPage()),
            );
          },),
          backgroundColor: appBarColor(),
        ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: loader ? runloader():new Form(
              key: _formKey,
              autovalidate: true,

              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text('Register Your Company',
                      textAlign: TextAlign.center,
                      style: new TextStyle(fontWeight: FontWeight.bold, fontSize:20.0, color: appBarColor()),
                    ),
                  ),

                  new Text('Note: This is not Employee registration form. The Employees should Sign In & not register here',
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize:14.0, color: Colors.orange[900], ),
                  ),

                  new TextFormField(
                    /*   validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter company name';
                      }
                    },*/
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.business),
                      hintText: 'Company',
                      labelText: 'Company',
                    ),
                    controller: _name,
                    focusNode: __name,
                  ),
                  new TextFormField(
                    /*  validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter contact person name';
                      }
                    },*/
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Contact Person',
                      labelText: 'Contact Person',
                    ),
                    controller: _cname,
                    focusNode: __cname,
                  ),
                  new TextFormField(
                    /*    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter valid email';
                      }
                    },*/
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Email',
                      labelText: 'Email',
                    ),
                    //obscureText: true,
                    controller: _email,
                    focusNode: __email,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  new InputDecorator(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.satellite),
                      labelText: 'Country',
                    ),
                    //   isEmpty: _color == '',
                    child:  new DropdownButton<String>(
                      isDense: true,
                      //    hint: new Text("Select"),
                      value: _country,
                      onChanged: (String newValue) {
                        setState(() {
                          _country = newValue;
                          print("*************************");
                          print(newValue);
                          print(_myJson[int.parse(newValue)]['countrycode']);
                          print(_myJson[int.parse(newValue)]['name']);
                          _contcode.text = _myJson[int.parse(newValue)]['countrycode'];
                          _tempcontry = _myJson[int.parse(newValue)]['id'];
                          print(_tempcontry);
                          print(_myJson);

                        });
                      },
                      items: _myJson.map((Map map) {
                        return new DropdownMenuItem<String>(
                          value: map["ind"].toString(),
                          child: new Text(
                            map["name"],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 27,
                        child:Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child:  new TextFormField(
                            enabled: false,
                            textAlign: TextAlign.justify,
                            style: new TextStyle(
                              height: 1.25,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.phone),
                              fillColor: Colors.black12,
                              // filled: true,
                            ),
                            controller: _contcode,
                            focusNode: __contcode,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 73,
                        child: new TextFormField(
                          /*    validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Phone';
                              }
                            },*/
                          decoration: const InputDecoration(
                            //icon: const Icon(Icons.phone),
                            hintText: 'Phone',
                            labelText: 'Phone',
                          ),
                          controller: _phone,
                          focusNode: __phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),

                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child:  new TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              icon: const Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: const Icon(Icons.lock))),
                          /*        validator: (val) => val.length < 6 ? 'Password too short.' : null,
                          onSaved: (val) => _password = val,*/
                          obscureText: _obscureText,
                          controller: _pass,
                          focusNode: __pass,
                        ),

                      ),
                      new FlatButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: _toggle,
                        child: Row(
                          children: <Widget>[
                            Icon(_obscureText ?Icons.visibility:Icons.visibility_off),
                          ],
                        ),
                      ),
                      // child: new Text(_obscureText ? "show": "Hide")),
                    ],
                  ),

                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.location_city),
                      hintText: 'City(optional)',
                      labelText: 'City',
                    ),
                    controller: _city,
                    keyboardType: TextInputType.text,
                  ),

                  new Container(
                      padding: const EdgeInsets.only(left: 0.0, top: 20.0),
                      child: _isButtonDisabled?new RaisedButton(
                      color: Colors.orange,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: const Text('Please wait...',style: TextStyle(fontSize: 18.0),),
                      onPressed: (){}
                      ):new RaisedButton(
                        color: Colors.orange,
                        textColor: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        child: const Text('Register Company',style: TextStyle(fontSize: 18.0),),
                        onPressed: () async{

/*
                          setLocal('Ubitech Solutions','0','0');
                          showDialog(context: context, child:
                          new AlertDialog(
                            title: new Text("Congratulations"),
                            content: new Text(prefs.getString('fname')),
                            actions: <Widget>[
                              new RaisedButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                child: new Text('Start Trial'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ));
                          print('============*******************===============');
                          return;
*/
                          if(_isButtonDisabled)
                            return null;

                          if(_name.text.trim()=='') {
                            showDialog(context: context, child:
                            new AlertDialog(
                              title: new Text("Alert"),
                              content: new Text("Please enter company name"),
                            ));
                            FocusScope.of(context).requestFocus(__name);
                          }
                          else if(_cname.text.trim()=='') {
                            showDialog(context: context, child:
                            new AlertDialog(
                              title: new Text("Alert"),
                              content: new Text("Please enter contact person name"),
                            ));
                            FocusScope.of(context).requestFocus(__cname);
                          }
                          else if(_email.text.trim()=='') {
                            showDialog(context: context, child:
                            new AlertDialog(
                              title: new Text("Alert"),
                              content: new Text("Please enter valid email"),
                            ));
                            FocusScope.of(context).requestFocus(__email);
                          }
                          else if(_pass.text.length<6) {
                            showDialog(context: context, child:
                            new AlertDialog(
                              title: new Text("Alert"),
                              content: new Text("Please enter valid password \n (password must contains at least 6 character)"),
                            ));
                            FocusScope.of(context).requestFocus(__pass);
                          }
                          else if(_tempcontry=='' ) {
                            showDialog(context: context, child:
                            new AlertDialog(
                              title: new Text("Alert"),
                              content: new Text("Please Select a Country."),
                            ));
                            FocusScope.of(context).requestFocus(__phone);
                          }
                          else if(_country=='0') {
                            showDialog(context: context, child:
                            new AlertDialog(
                              title: new Text("Alert"),
                              content: new Text("Please enter valid phone"),
                            ));
                            FocusScope.of(context).requestFocus(__phone);
                          }
                          else if(_phone.text.length<6) {
                            showDialog(context: context, child:
                            new AlertDialog(
                              title: new Text("Alert"),
                              content: new Text("Please enter valid phone"),
                            ));
                            FocusScope.of(context).requestFocus(__phone);
                          }
                          else {
                            setState(() {
                              _isButtonDisabled=true;

                            });

                            var prefs=await SharedPreferences.getInstance();

                            String referrerId=prefs.getString("referrerId")??"0";
                            String ReferralValidFrom=prefs.getString("ReferralValidFrom")??"0000-00-00";
                            String ReferralValidTo=prefs.getString("ReferralValidTo")??"0000-00-00";
                            String referrerAmt=prefs.getString("referrerAmt")??"0%";
                            String referrenceAmt=prefs.getString("referrenceAmt")??"0%";
                            print("referrer id sent"+referrerId.toString());
                            print("ReferralValidFrom"+ReferralValidFrom);
                            print("ReferralValidTo"+ReferralValidTo);
                            print("referrerAmt"+referrerAmt);
                            print("referrenceAmt"+referrenceAmt);
                            var url = globals.path+"register_org";
                            http.post(url, body: {
                              "org_name": _name.text.trim(),
                              "name": _cname.text.trim(),
                              "phone": _phone.text.trim(),
                              "email": _email.text.trim(),
                              "password": _pass.text,
                              "country": _tempcontry,
                              "countrycode": '',
                              "address": _city.text.trim(),
                              "referrerId":referrerId,
                              "ReferralValidFrom":ReferralValidFrom,
                              "ReferralValidTo":ReferralValidTo,
                              "referrerAmt":referrerAmt,
                              "referrenceAmt":referrenceAmt,
                            }) .then((response) {
                              if (response.statusCode == 200) {

                                print("-----------------> After Registration ---------------->");
                                print(response.body.toString());
                                res = json.decode(response.body);
                                if (res['sts'] == 'true') {
                                  setLocal(res['f_name'],res['id'],res['org_id']);

                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    title: new Text("ubiShift"),
                                    content: new Text("Hi " + res['f_name'] +
                                        " \nYour company has been registered successfully."),
                                    actions: <Widget>[
                                      new RaisedButton(
                                        color: Colors.green,
                                        textColor: Colors.white,
                                        child: new Text('Start Trial'),
                                        onPressed: () {
                                          Navigator.of(context, rootNavigator: true).pop();
                                          login(_phone.text, _pass.text, context);
                                        },
                                      ),
                                    ],
                                  ));

                                } else if (res['sts'] == 'false1' ||
                                    res['sts'] == 'false3') {
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    title: new Text("ubiShift"),
                                    content: new Text(
                                        "Email id is already registered"),
                                  ));
                                } else if (res['sts'] == 'false2' ||
                                    res['sts'] == 'false4') {
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    title: new Text("ubiShift"),
                                    content: new Text(
                                        "Phone id is already registered"),
                                  ));
                                } else {
                                  showDialog(context: context, child:
                                  new AlertDialog(
                                    title: new Text("ubiShift"),
                                    content: new Text(
                                        "Oops!! Company not registered \n Try later"),
                                  ));
                                }
                                setState(() {
                                  _isButtonDisabled=false;

                                });
                              } else {
                                setState(() {
                                  _isButtonDisabled=false;

                                });
                                showDialog(context: context, child:
                                new AlertDialog(
                                  title: new Text("Error"),
                                  // content: new Text("Unable to call service"),
                                  content: new Text("Response status: ${response
                                      .statusCode} \n Response body: ${response
                                      .body}"),
                                )
                                );

                              }
                              //   print("Response status: ${response.statusCode}");
                              //   print("Response body: ${response.body}");
                            }).catchError((onError) {
                              setState(() {
                                _isButtonDisabled=false;
                              });
                              showDialog(context: context, child:
                              new AlertDialog(
                                title: new Text("Error"),
                                content: new Text("Too slow internet"),
                              )
                              );
                            });
                          }
                          // return false;

                        },
                      )),
                ],
              ))),
    );

  }

  login(var username,var userpassword, BuildContext context) async{
    var user = User(username,userpassword);
    Login dologin = Login();
    setState(() {
      loader = true;
    });
    var islogin = await dologin.checkLogin(user);
    print(islogin);
    if(islogin=="success"){
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );*/
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false,
      );
    }else if(islogin=="failure"){
      setState(() {
        loader = false;
      });
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Invalid login credentials")));
    }else{
      setState(() {
        loader = false;
      });
      Scaffold.of(context)
          .showSnackBar(
          SnackBar(content: Text("Poor network connection.")));
    }
  }


  runloader(){
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

}