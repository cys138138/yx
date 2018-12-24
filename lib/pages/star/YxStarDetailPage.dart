import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class YxStarDetailPage extends StatefulWidget {
  String _url, _title, _id;

  YxStarDetailPage(this._id, this._url, this._title);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState(_id, _url, _title);
}

class _NewsDetailPageState extends State<YxStarDetailPage>
    with TickerProviderStateMixin {
  String _url, _title, _id;
  var newsDetail = Map();

  var wid;

  int fuckIndex = 0;

  _NewsDetailPageState(this._id, this._url, this._title);

  @override
  void initState() {
    super.initState();
    print(newsDetail.length);

    getNewsDetail(_id);
  }

  @override
  Widget build(BuildContext context) {
    var fleSpace;
    var toboxAdapter;
    var bottom;
    if (newsDetail.length == 0) {
      fleSpace = new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      );
      toboxAdapter = new Padding(padding: EdgeInsets.all(5.0));
      bottom = new Padding(padding: EdgeInsets.all(5.0));
    } else {
      fleSpace = new FlexibleSpaceBar(
        background: Image.network(
          newsDetail["img_url"],
          fit: BoxFit.cover,
        ),
      );
      toboxAdapter = new Container(
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
                          color: Colors.grey),
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
                padding: EdgeInsets.only(left: 10.0, top: 5.0),
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
      );
      bottom = new Container(
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
                                    color: Colors.grey),
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
                  onPressed: () {
                    Future(() => showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ModalBottomSheet();
                        }));
                  },
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 252, 130, 45),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: bottom,
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            //自定义按钮返回
//            leading: new InkWell(child: new Icon(Icons.add),onTap: (){
//              Navigator.of(context).pop();
//            },),
            iconTheme: new IconThemeData(color: Colors.white, opacity: 0.8),
            expandedHeight: 300.0,
            flexibleSpace: fleSpace,
          ),
          SliverToBoxAdapter(child: toboxAdapter),
        ],
      ),
    );
  }

  void getNewsDetail(String id) {
    YxHttp.get(YxApi.STAR_DETAIL + _id + "/").then((res) {
      try {
        Map<String, dynamic> map = jsonDecode(res);

        Future.delayed(new Duration(milliseconds: 100), () {
          setState(() {
            newsDetail = map['content']['products'];
          });
        });
      } catch (e) {
        print('错误catch s $e');
        setState(() {
          newsDetail = Map();
        });
      }
    });
  }
}

class ModalBottomSheet extends StatefulWidget {
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet>
    with SingleTickerProviderStateMixin {
  var heightOfModalBottomSheet = 100.0;

  Widget build(BuildContext context) {

    return InkWell(
        child: Container(
          height: 500.0,
          child: new Stack(
            children: <Widget>[
              new Container(
                height:50.0,
                child: new Align(child: new Row(
                  children: <Widget>[
                    new Expanded(
                      flex: 1,
                      child: new Row(
                        // 为了让评论数显示在最右侧，所以需要外面的Expanded和这里的MainAxisAlignment.end
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.black,
                              ), onPressed: (){
                            Navigator.pop(context);
                          })
                        ],
                      ),
                    )

                  ],
                ),alignment: Alignment.topCenter,),
              )
              ,
            ],
          ),
        ),
      onTap: (){},
    );

    return Container(
      height: heightOfModalBottomSheet,
      child: RaisedButton(
          child: Text("Press"),
          onPressed: () {
            heightOfModalBottomSheet += 100;
            setState(() {});
          }),
    );
  }
}

