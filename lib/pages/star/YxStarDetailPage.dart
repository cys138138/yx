import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';

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
      bottomNavigationBar: new Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: new Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[100]))),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: new Row(
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new Column(
                            children: <Widget>[
                              new Text(
                                "预约秒数",
                                style: new TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey
                                ),
                              ),
                              new Text(
                                newsDetail["seconds"].toString() + "秒起",
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              new Container(
                height: 50,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: FlatButton(
                  child: Text(
                    '立即预约',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 252, 130, 45),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 300.0,
            flexibleSpace: new FlexibleSpaceBar(
              background: Image.network(
                newsDetail["img_url"],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: new Container(
                padding: EdgeInsets.only(left: 10.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  height: 60.0,
                  child: new Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          newsDetail["name"],
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
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
                    padding: EdgeInsets.only(left:10.0,top: 5.0),
                    child: new Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          newsDetail["desc"],
                          style: new TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.normal),
                        )),
                  ),
                  height: 100.0,
                ),
              ],
            ),
          )),
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
