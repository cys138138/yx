import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yx/app/OsApplication.dart';
import 'package:yx/domain/event/LoginEvent.dart';
import 'package:yx/utils/WidgetsUtils.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';

class PromoteListPage extends StatefulWidget {
  @override
  _PromoteListPage createState() => _PromoteListPage();
}

class _PromoteListPage extends State<PromoteListPage> {
  Map<String, dynamic> _orderList = Map<String, dynamic>();
  WidgetsUtils widgetsUtils;
  TextStyle leftMenuStyle = new TextStyle(fontSize: 16.0, color: Colors.black);

  bool isDataNull = false;

  @override
  void initState() {
    super.initState();
    _getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    widgetsUtils = new WidgetsUtils(context);
    var mapList = _orderList['promo_list'];
    List<Widget> _body = List();
    if (_orderList.length == 0) {
      _body.clear();
      _body.add(new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      ));
    }
    else if(isDataNull){
      _body.add(new Center(
        child: new Center(
          child: Text("暂无数据"),
        ),
      ));
    }
    else {
      _body.clear();
      _body.add(new Container(
          margin: EdgeInsets.only(top: 15.0),
          decoration: new BoxDecoration(
            color: Colors.grey[200],
          ),
          child: new ListView.builder(
            itemBuilder: (context, index) => initItem(index),
            itemCount: mapList.length,
          )));
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

  initItem(int index) {
    Map<String, dynamic> _item = _orderList['promo_list'][index];
    Widget title = Text(_item["user"]["mobile"], style: leftMenuStyle);


    DateTime date = DateTime.parse(_item["user"]["date_join"]);
        String s_time = date.year.toString() +'-'+ date.month.toString()+'-'+date.day.toString();
    Widget subtitle = Text(s_time);

    Widget l_subtitle = Text(
      _item["user"]["nickname"] +
          " " +
          "ID： " +
          _item["user"]["user_id"].toString(),
      style: new TextStyle(color: Colors.black),
    );
    Widget r_subtitle = Text(
      "总业绩:" + _item["total_score"].toString(),
      style: new TextStyle(color: Colors.orange),
    );

    List<Widget> wItem = List<Widget>();

    if (index == 0) {
      //动态加头
      wItem.add(new Container(
        decoration: new BoxDecoration(
          color: Colors.redAccent,
        ),
        height: 90.0,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top:15.0),
                    child: Center(
                      child: Text("总业绩",style: new TextStyle(color: Colors.white,fontSize: 14.0),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom:15.0),
                    child: Center(
                      child: Text(_orderList["self_detail"]["total_score"].toString(),style: new TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top:15.0),
                    child: Center(
                      child: Text("推广人数",style: new TextStyle(color: Colors.white,fontSize: 14.0),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom:15.0),
                    child: Center(
                      child: Text(_orderList["self_detail"]["promo_count"].toString(),style: new TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      ));
    }

    wItem.add(new Container(
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                l_subtitle,
                r_subtitle,
              ],
            ),
          ),
          new Divider(
            height: 1.0,
          ),
          ListTile(
            title: title,
            subtitle: subtitle,
          )
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
        YxHttp.get(YxApi.GET_PTOMOTE_LIST + userInfoBean.id + '/promotelist/',
                headers: {'authorization': 'Token ' + userInfoBean.token})
            .then((res) {
          try {
            Map<String, dynamic> data = jsonDecode(res);
            print(data);
            setState(() {
              _orderList = data['content']["promote_list"];
              if(_orderList['promo_list'].length == 0){
                isDataNull = true;
              }else{
                isDataNull = false;
              }
            });
          } catch (e) {
            print('错误catch s $e');
          }
        });
      }
    });
  }
}
