import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yx/utils/WidgetsUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class YxStarDetailPage extends StatefulWidget {
  String _url, _title, _id;

  YxStarDetailPage(this._id, this._url, this._title);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState(_id, _url, _title);
}

class _NewsDetailPageState extends State<YxStarDetailPage> {
  String _url, _title, _id;
  var newsDetail;

  var wid;

  _NewsDetailPageState(this._id, this._url, this._title);

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
    } else if (newsDetail == false) {
      wid = new Center(child: new Text("网络不通。。请重试吧！"));
    }

    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            title: new Center(child: new Text("账号或或或"),),
            expandedHeight: 800.0,
            flexibleSpace: new SingleChildScrollView(
              child: new Stack(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Container(
                        height: 300.0,
                        width: MediaQuery.of(context).size.width,
                        child: new Image.network(
                          newsDetail["img_url"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      new Container(
                        height: 60.0,
                        child: new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new Align(
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                newsDetail["name"],
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                      new Container(
                        child: new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new Align(
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                newsDetail["short_desc"],
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black12),
                              )),
                        ),
                      ),
                      new Container(
                        child: new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new Align(
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                newsDetail["seconds"].toString() + "秒起",
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              )),
                        ),
                      ),
                      new Container(
                        child: new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new Align(
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                newsDetail["desc"],
                                style: new TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal),
                              )),
                        ),
                      ),
                    ],
                  ),


                  new Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: new Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(top: BorderSide(color: Colors.grey[100]))
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: new Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: new Row(
                                children: <Widget>[
                                  Text('合计：¥'),
                                ],
                              ),
                            ),
                          ),
                          new Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: FlatButton(
                              child: Text('去结算()', style: TextStyle(color: Colors.white),),
                              onPressed: (){

                              },
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getNewsDetail(String id) {
    YxHttp.get(YxApi.STAR_DETAIL + _id + "/").then((res) {
      try {
        Map<String, dynamic> map = jsonDecode(res);
        print("sssssssssss");
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
