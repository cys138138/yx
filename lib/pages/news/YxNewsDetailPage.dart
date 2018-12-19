import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class YxNewsDetailPage extends StatefulWidget {
  String _url,_title,_id;

  YxNewsDetailPage(this._id,this._url,this._title);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState(_id,_url,_title);
}

class _NewsDetailPageState extends State<YxNewsDetailPage> {
  String _url ,_title,_id;
  var newsDetail;

  var wid;

  _NewsDetailPageState(this._id,this._url,this._title);

  @override
  void initState() {
    super.initState();
    getNewsDetail(_id);
  }

  @override
  Widget build(BuildContext context) {
    if (newsDetail == null) {
      wid = new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      );
    }else if(newsDetail == false){
        wid = new Center(
            child:new Text("网络不通。。请重试吧！")
        );
    }else{
      wid = new SingleChildScrollView(
        child: new Column(children: <Widget>[
          new Container(
            child: new Center(
              child: new Text(_title,style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14.0)),
            ),
            padding: EdgeInsets.all(20.0),
          ),
          new Center(child: new Html(
            data: newsDetail['body'],
            padding: EdgeInsets.all(8.0),
            onLinkTap: (url) {
              print("Opening $url...");
            },
          )
          ),
          new Container(
            height: 100.0,
          )

        ],

        ),
      );
    }
     return new Scaffold(
      appBar: new AppBar(
        title: new Center(
          child: new Text(_title, style: new TextStyle(color: Colors.white)),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: wid,
    );

  }

  void getNewsDetail(String id) {
    YxHttp.get(YxApi.NEWS_DETAIL+_id+"/detail/").then((res){
      try {
        Map<String, dynamic> map = jsonDecode(res);
        setState(() {
          newsDetail = map['content']['products'];
        });
      } catch (e) {
        print('错误catch s $e');
        setState(() {
          newsDetail = false;
        });

      }

    });
  }

}
