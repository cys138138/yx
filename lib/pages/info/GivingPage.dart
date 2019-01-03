import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yx/app/OsApplication.dart';
import 'package:yx/domain/event/LoginEvent.dart';
import 'package:yx/utils/WidgetsUtils.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';

/**
 * 赠送界面
 */
class GivingPage extends StatefulWidget {
  @override
  _GivingPagePage createState() => _GivingPagePage();
}

class _GivingPagePage extends State<GivingPage> {
  Map<String, dynamic> _orderList = Map<String, dynamic>();
  WidgetsUtils widgetsUtils;
  TextStyle leftMenuStyle = new TextStyle(fontSize: 16.0, color: Colors.black);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widgetsUtils = new WidgetsUtils(context);
    List<Widget> _body = List();
    if (_orderList.length == 0) {
      _body.add(new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      ));
    } else {
      _body.clear();
    }

    return Scaffold(
      appBar: new AppBar(
        title: widgetsUtils.getAppBar('推广列表'),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new Stack(
        children: _body,
      ),
    );
  }
}
