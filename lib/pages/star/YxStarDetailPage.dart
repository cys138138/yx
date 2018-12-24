import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yx/utils/toast/TsUtils.dart';

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
  Map pageRowData = {
    'specifications': <Map>[
      {'id': 1, 'name': '3000秒'},
      {'id': 2, 'name': '5000秒'},
      {'id': 3, 'name': '10000秒'},
      {'id': 4, 'name': '15000秒'},
    ],
    'selectSpecIndex': 0,
    'quantity': 1,
  };

  Widget build(BuildContext context) {
    var _body = InkWell(
      child: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            //面板内容
            new Container(
              child: new Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //产品规格
                    new Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 8),
                      child: Text(
                        '秒数规格',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    new Wrap(
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 0,
                      children:
                          pageRowData['specifications'].map<Widget>((Map map) {
                        int index = pageRowData['specifications'].indexOf(map);
                        return new Padding(
                          padding: EdgeInsets.all(0),
                          child: new FlatButton(
                            color: pageRowData['selectSpecIndex'] == index
                                ? Color.fromARGB(255, 200, 10, 10)
                                : null,
                            disabledColor:
                                pageRowData['selectSpecIndex'] == index
                                    ? Color.fromARGB(255, 200, 10, 10)
                                    : null,
                            child: Text(
                              map['name'],
                              style: TextStyle(
                                  color: pageRowData['selectSpecIndex'] == index
                                      ? Colors.white
                                      : Color.fromARGB(255, 200, 10, 10)),
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromARGB(255, 200, 10, 10)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            onPressed: () {
                              setState(() {
                                pageRowData['selectSpecIndex'] = index;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    new Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '数量',
                            style: TextStyle(fontSize: 20),
                          ),
                          //数量选择器
                          new Container(
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new InkWell(
                                  child: new Container(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.remove,
                                      size: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    if(pageRowData['quantity'] == 1){
                                      pageRowData['quantity'] = 1;
                                      TsUtils.showShort("数量不能小于1");
                                      return;
                                    }
                                    int tempcount = --pageRowData['quantity'];
                                    setState(() {
                                      print("点击了减");
                                      if (tempcount > 0) {
                                        pageRowData['quantity'] = tempcount;
                                      }
                                    });
                                  },
                                ),
                                Expanded(
                                  child: new Container(
                                    alignment: AlignmentDirectional.center,
                                    child: Text(
                                      pageRowData['quantity'].toString(),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                    ),
                                  ),
                                ),
                                new InkWell(
                                  child: new Container(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.add,
                                      size: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    int tempcount = ++pageRowData['quantity'];
                                    setState(() {
                                      print("点击了加");
                                      if (tempcount > 0) {
                                        pageRowData['quantity'] = tempcount;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //弹出面板关闭按钮
            new Positioned(
              width: 30,
              height: 30,
              top: 8,
              right: 8,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.black26,
                child: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            //底部按钮组
            new Positioned(
              width: MediaQuery.of(context).size.width,
              height: 50,
              bottom: 0,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: FloatingActionButton(
                      child: Text('确认预约'),
                      shape: Border(),
                      backgroundColor: Color.fromARGB(255, 230, 10, 10),
                      onPressed: null,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {},
    );
    return _body;
  }
}
