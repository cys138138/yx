import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yx/utils/WidgetsUtils.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';

/**
 * 流水明细
 */
class RunWaterListPage extends StatefulWidget {
  @override
  _RunWaterListPage createState() => _RunWaterListPage();
}

class _RunWaterListPage extends State<RunWaterListPage> {
  List<dynamic> _orderList = List<dynamic>();
  WidgetsUtils widgetsUtils;
  TextStyle leftMenuStyle = new TextStyle(fontSize: 16.0, color: Colors.black);

  @override
  void initState() {
    super.initState();
    _getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    widgetsUtils = new WidgetsUtils(context);
    var mapList = _orderList;
    List<Widget> _body = List();
    if (_orderList.length == 0) {
      _body.clear();
      _body.add(new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      ));
    } else {
      _body.clear();
      _body.add(new Container(
          margin: EdgeInsets.only(top: 15.0),
          child: new ListView.builder(
            itemBuilder: (context, index) => initItem(index),
            itemCount: mapList.length,
          )));
    }

    return Scaffold(
      appBar: new AppBar(
        title: widgetsUtils.getAppBar('流水明细'),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new Stack(
        children: _body,
      ),
    );
  }

  initItem(int index) {
    Map<String, dynamic> _item = _orderList[index];
    Widget title = Text(_item["txn_type_str"], style: leftMenuStyle);

    DateTime date = DateTime.parse(_item["create_at"]);
    String s_time = date.year.toString() +'-'+ date.month.toString()+'-'+date.day.toString();
    Widget subtitle = Text(s_time);
    Widget trailing = Text("¥"+_item["amount"].toString(),style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,fontSize: 16.0),);

    List<Widget> wItem = List<Widget>();

    wItem.add(new Container(
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: title,
            subtitle: subtitle,
            trailing:trailing,
            leading: new ClipRRect(borderRadius: BorderRadius.circular(9.0),child: Icon(Icons.card_giftcard,size: 39.0,color: Colors.blueAccent,),),
          ),
          new Divider(
            height: 1.0,
          ),
        ],
      ),
    ));

    return new InkWell(
      onTap: () {},
      child: new Column(
        children: wItem,
      ),
    );
  }

  void _getOrderList() {
    SpUtils.getUserInfo().then((userInfoBean) {
      if (userInfoBean != null && userInfoBean.id != null) {
        print('authorization Token ' + userInfoBean.token);
        YxHttp.get(YxApi.GET_PTOMOTE_LIST + userInfoBean.id + '/balance/transactions/',
                headers: {'authorization': 'Token ' + userInfoBean.token})
            .then((res) {
          try {
            print(res);
            var data = jsonDecode(res);
            setState(() {
              _orderList = data['content']["txn_list"];
            });
          } catch (e) {
            print('错误catch s $e');
          }
        });
      }
    });
  }
}
