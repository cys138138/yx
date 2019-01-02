import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yx/app/OsApplication.dart';
import 'package:yx/domain/event/GoPageEvent.dart';
import 'package:yx/utils/ProgressDialog.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
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
  _NewsDetailPageState(this._id, this._url, this._title);

  @override
  void initState() {
    super.initState();
    print(newsDetail.length);

    getNewsDetail(_id);
  }

  @override
  Widget build(BuildContext context) {
    var toboxAdapter;
    var bgImg;
    var bottom;
    if (newsDetail.length == 0) {
      toboxAdapter = new Padding(padding: EdgeInsets.all(5.0));
      bottom = new Padding(padding: EdgeInsets.all(5.0));
      bgImg = new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      );
    } else {
      bgImg = Image.network(
        newsDetail["img_url"],
        fit: BoxFit.cover,
      );
      bottom = new Positioned(
        width: MediaQuery.of(context).size.width,
        height: 50,
        bottom: 0,
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
              new Builder(
                builder: (BuildContext context) {
                  return new Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 130, 45),
                    ),
                    child: new Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: FlatButton(
                        child: Text(
                          '立即预约',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Scaffold.of(context).showBottomSheet(
                            (BuildContext context) {
                              return ModalBottomSheet(_id);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
      toboxAdapter = new Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          new Column(
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
              ),
            ],
          ),
          bottom
        ],
      );
    }

    List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        SliverAppBar(
          //标题居中
          centerTitle: true,
          //展开高度250
          expandedHeight: 300.0,
          //不随着滑动隐藏标题
          floating: true,
          //固定在顶部
          pinned: true,
          forceElevated: true,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            // title: Text('我是一个FlexibleSpaceBar',),
            background: bgImg,
          ),
          leading: IconButton(
            color: Colors.grey,
            icon: BackButtonIcon(),
            onPressed: () {
              Navigator.pop(super.context);
            },
          ),
          backgroundColor: Colors.transparent,
          // title: Text('产品详情'),
        )
      ];
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: _sliverBuilder,
          body: new Container(
            child: toboxAdapter,
          ),
        ),
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
  String _id;
  _ModalBottomSheetState createState() => _ModalBottomSheetState(this._id);

  ModalBottomSheet(this._id);

}

class _ModalBottomSheetState extends State<ModalBottomSheet>
    with SingleTickerProviderStateMixin {

  String _id;
  bool _loading = false;
  Map pageRowData = {
    'specifications': <Map>[
      {'id': 1, 'name': '3000秒','value':300.0},
      {'id': 2, 'name': '5000秒','value':500.0},
      {'id': 3, 'name': '10000秒','value':1000.0},
      {'id': 4, 'name': '15000秒','value':1500.0},
    ],
    'selectSpecIndex': 0,
    'quantity': 1,
  };

  TextEditingController textEditingController = new TextEditingController();

  double _totalSeconde = 0.0;

  @override
  void initState() {
    super.initState();
    OsApplication.eventBus.on<GoPageEvent>().listen((event) {
      try{
        if(event.pageName == "LoginPage"){
          return Navigator.pushNamed(context, '/usre_info');
        }else if(event.pageName == "MyInfoPage"){
          return Navigator.pushNamed(context, '/usre_info');
        }

      }catch(e){

      }
    });
  }

  Widget build(BuildContext context) {
    return ProgressDialog(
        loading: _loading,
        msg: "预约中。。",
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[300])),
          ),
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
                              disabledColor: pageRowData['selectSpecIndex'] == index
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
                                borderRadius: BorderRadius.all(Radius.circular(8)),
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
                        width: 100.0,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 20.0),
                        child: new TextField(
                          //文本输入控件
                          onChanged: (String str) {
                            //输入监听
                            print('用户输入变更');
                          },
                          onSubmitted: (String str) {
                            //提交监听
                            print('用户提交变更');
                          },
                          keyboardType: TextInputType.number, //设置输入框文本类型
                          controller: textEditingController, //控制器，控制文字内容
                          textAlign: TextAlign.left, //设置内容显示位置是否居中等
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.blueAccent,
                          ),
                          autofocus: false, //自动获取焦点
                          decoration: new InputDecoration(
                            labelText: '自定义秒数',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
//                icon: new Container(
//                  padding: EdgeInsets.all(0.0),
//                  child: new Icon(Icons.phone),
//                ),
//                errorText: '这是错误的errorText',
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0), //设置显示文本的一个内边距
//                border: InputBorder.none,//取消默认的下划线边框
                          ),
                        ),
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
                                      if (pageRowData['quantity'] == 1) {
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
                        onPressed: (){
                          String inputVal = textEditingController.text;
                          //如果没有输入自定义则获取选中的
                          if(inputVal.isEmpty){
                            var selectMap = pageRowData['specifications'][pageRowData['selectSpecIndex']]['value'];
                            int nums = pageRowData['quantity'];
                            var totalNums = selectMap * nums;

                            SpUtils.getUserInfo().then((userInfoBean) {
                              setState(() {
                                _loading = true;
                              });
                              if(userInfoBean.id == null){
                                Future.delayed(Duration(seconds: 2),(){
                                  setState(() {
                                    _loading = false;
                                  });
                                  OsApplication.eventBus.fire(new GoPageEvent('LoginPage'));
                                });
                                return;
                              }
                              YxHttp.post(YxApi.BUY_STAR_TIME+_id+"/purchase/",headers: {
                                'authorization': 'Token '+userInfoBean.token
                              }).then((res){
                                TsUtils.showShort(res["desc"]);
                                if(res["errors"].length > 0){
                                  setState(() {
                                    _loading = false;
                                  });
                                }else{
                                  Future.delayed(Duration(seconds: 2),(){
                                    setState(() {
                                      _loading = false;
                                    });
                                    OsApplication.eventBus.fire(new GoPageEvent('MyInfoPage'));
                                  });
                                }
                              });
                            });
                          }else{
                            //暂时选中没有任何作用，之前的傻叉功能
                            SpUtils.getUserInfo().then((userInfoBean) {
                              if(userInfoBean.id == null){
                                setState(() {
                                  _loading = true;
                                });
                                Future.delayed(Duration(seconds: 2),(){
                                  OsApplication.eventBus.fire(new GoPageEvent('LoginPage'));
                                });
                                return;
                              }
                              YxHttp.post(YxApi.BUY_STAR_TIME+_id+"/purchase/",headers: {
                                'authorization': 'Token '+userInfoBean.token
                              }).then((res){
                                TsUtils.showShort(res["desc"]);
                                if(res["errors"].length > 0){
                                  setState(() {
                                    _loading = false;
                                  });
                                }else{
                                  Future.delayed(Duration(seconds: 2),(){
                                    setState(() {
                                      _loading = false;
                                    });
                                    OsApplication.eventBus.fire(new GoPageEvent('MyInfoPage'));
                                  });
                                }
                              });
                            });

                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  _ModalBottomSheetState(this._id);
}
