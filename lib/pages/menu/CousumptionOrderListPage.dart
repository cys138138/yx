import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yx/utils/WidgetsUtils.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';

class CousumptionOrderListPage extends StatefulWidget {
  @override
  _CousumptionOrderListPage createState() => _CousumptionOrderListPage();
}

class _CousumptionOrderListPage extends State<CousumptionOrderListPage> {
  List<dynamic> _orderList= List<dynamic>();
  WidgetsUtils widgetsUtils;
  TextStyle leftMenuStyle = new TextStyle(fontSize: 14.0, color: Colors.black);

  @override
  void initState() {
    super.initState();
    _getOrderList();

  }

  @override
  Widget build(BuildContext context) {
    widgetsUtils = new WidgetsUtils(context);

    Widget _body;
    if (_orderList.length == 0) {
      _body = new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      );
    }else{
      _body = new Container(
        margin: EdgeInsets.only(top: 15.0),
        decoration: new BoxDecoration(
          color: Colors.grey[200],
        ),
        child: new ListView.builder(
        itemBuilder: (context, index) => initItem(index),
        itemCount: _orderList.length,
      ),);
    }

    return Scaffold(
      appBar: new AppBar(
        title: widgetsUtils.getAppBar('消费记录'),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: _body,
    );
  }

  initItem(int index) {
    Map<String,dynamic> _item =  _orderList[index];
    bool type = _item["product"] != null ? true : false;
    Widget img = type ? new ClipRRect(borderRadius: BorderRadius.circular(3.0),child: Image.network(_item["product"]["img_url"],width: 80.0,height: 80.0,)) : new ClipRRect(borderRadius: BorderRadius.circular(3.0),child: Image.network(_item["star"]["img_url"],width: 80.0,height: 80.0,));
    Widget title = type ? Text(_item["product"]["name"],style: leftMenuStyle) : Text(_item["star"]["name"],style: leftMenuStyle);
    Widget trailing = type ? Text(_item["product"]["create_at"]) : Text(_item["star"]["create_at"]);
    Widget subtitle = type ? Text(_item["product"]["price"].toString()+'元') : Text(_item["star"]["seconds"].toString()+'秒');
    Widget l_subtitle = Text("订单号： "+_item["serial_no"].toString(),style: new TextStyle(color: Colors.black),);
    Widget r_subtitle = Text(_item["status"].toString(),style: new TextStyle(color: Colors.orange),);

    return new InkWell(
      onTap: () {
      },
      child: new Column(
        children: <Widget>[
          Container(

            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              Padding(padding: EdgeInsets.all(10.0),child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  l_subtitle,
                  r_subtitle,
                ],),),
              new Divider(
                height: 1.0,
              ),
              ListTile(
                leading: img,
                title: title,
                trailing: trailing,
                subtitle: subtitle,
              )
            ],),
          ),
        ],
      ),
    );
  }


  void _getOrderList() {
    SpUtils.getUserInfo().then((userInfoBean) {
      if(userInfoBean !=null && userInfoBean.id != null){
        print('authorization Token '+userInfoBean.token);
        YxHttp.get(YxApi.GET_ORDER_LIST+userInfoBean.id+'/orderlist/',headers: {
          'authorization': 'Token '+userInfoBean.token
        }).then((res){
          try {
            Map<String,dynamic> data = jsonDecode(res);
            print(data);
            setState(() {
              _orderList = data['content']["order_list"];
            });
          } catch (e) {
            print('错误catch s $e');
          }
        });
      }


    });
  }
}
