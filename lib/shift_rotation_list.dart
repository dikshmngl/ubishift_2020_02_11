import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'drawer.dart';
import 'department.dart';
import 'designation.dart';
import 'employee_list.dart';
import 'shift_list.dart';
import 'change_password.dart';
import 'permission.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'profile.dart';
import 'attendance_summary.dart';
import 'globals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment.dart';
import 'reports.dart';
import 'shift_rotation.dart';
import 'package:multi_shift/services/services.dart';

class ShiftRotaionList extends StatefulWidget {
  @override
  _ShiftRotaionList createState() => _ShiftRotaionList();
}

class _ShiftRotaionList extends State<ShiftRotaionList> {
  Future<http.Response> _responseFuture;

  @override
  void initState() {
    super.initState();
    _responseFuture = http.get('http://174.138.61.246:8080/support/dc/1');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ExpansionTile Test'),
      ),
      body: new FutureBuilder(
        future: _responseFuture,
        builder: (BuildContext context, AsyncSnapshot<http.Response> response) {
          if (!response.hasData) {
            return const Center(
              child: const Text('Loading...'),
            );
          } else if (response.data.statusCode != 200) {
            return const Center(
              child: const Text('Error loading data'),
            );
          } else {
            List<dynamic> json = jsonDecode(response.data.body);
            return new MyExpansionTileList(json);
          }
        },
      ),
    );
  }
}

class MyExpansionTileList extends StatelessWidget {
  final List<dynamic> elementList;

  MyExpansionTileList(this.elementList);

  List<Widget> _getChildren() {
    List<Widget> children = [];
    elementList.forEach((element) {
      children.add(
        new MyExpansionTile(element['did'], element['dname']),
      );
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: _getChildren(),
    );
  }
}

class MyExpansionTile extends StatefulWidget {
  final int did;
  final String name;
  MyExpansionTile(this.did, this.name);
  @override
  State createState() => new MyExpansionTileState();
}

class MyExpansionTileState extends State<MyExpansionTile> {
  PageStorageKey _key;
  Future<http.Response> _responseFuture;

  @override
  void initState() {
    super.initState();
    _responseFuture =
        http.get('http://174.138.61.246:8080/support/dcreasons/${widget.did}');
  }

  @override
  Widget build(BuildContext context) {
    _key = new PageStorageKey('${widget.did}');
    return new ExpansionTile(
      key: _key,
      title: new Text(widget.name),
      children: <Widget>[
        new FutureBuilder(
          future: _responseFuture,
          builder:
              (BuildContext context, AsyncSnapshot<http.Response> response) {
            if (!response.hasData) {
              return const Center(
                child: const Text('Loading...'),
              );
            } else if (response.data.statusCode != 200) {
              return const Center(
                child: const Text('Error loading data'),
              );
            } else {
              List<dynamic> json = jsonDecode(response.data.body);
              List<Widget> reasonList = [];
              json.forEach((element) {
                reasonList.add(new ListTile(
                  dense: true,
                  title: new Text(element['reason']),
                ));
              });
              return new Column(children: reasonList);
            }
          },
        )
      ],
    );
  }
}
