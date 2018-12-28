import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yx/domain/PackageClassBean.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
import 'package:yx/utils/toast/TsUtils.dart';

class OrderDetailPage extends StatefulWidget {
  String _url, _title, _id;
  PackageClassBean packageItem;

  OrderDetailPage(this.packageItem);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState(packageItem);
}

class _NewsDetailPageState extends State<OrderDetailPage>
    with TickerProviderStateMixin {
  PackageClassBean packageItem;
  var orderDetail = Map();
  _NewsDetailPageState(this.packageItem);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var toboxAdapter;
    var bgImg;
    var bottom;
    bgImg = Image.network(
      packageItem.img_url,
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
                              "套餐金额",
                              style: new TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                            new Text(
                              "¥"+packageItem.price,
                              style: new TextStyle(
                                  fontSize: 16.0,
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
                            return ModalBottomSheet();
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
              margin: EdgeInsets.only(top: 50.0,bottom: 30.0),
              height: 250.0,
              child:
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      print("this is p");
                    },
                    child: new Container(
                      height: 200.0,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: const Color.fromARGB(255, 252, 130, 45),
                        image: DecorationImage(
                          image: AssetImage('images/bg_paybag.png',),
                          fit: BoxFit.cover,
                          alignment: AlignmentDirectional.bottomEnd,
                        ),
                      ),
                      child: new Stack(
                        children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                flex: 2,
                                child: new Padding(
                                  padding: EdgeInsets.all(25),
                                  child: Text(packageItem.name, style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                                ),
                              ),
                              new Expanded(
                                flex: 2,
                                child: new Padding(
                                    padding: EdgeInsets.all(15),
                                    child: new Center(
                                      child: Text('¥' + packageItem.price, style: TextStyle(color: Colors.white, fontSize: 30), textAlign: TextAlign.center,),
                                    )
                                ),
                              ),
                            ],
                          ),
                          new Positioned(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            bottom: 0,
                            child: new ClipPath(
                              clipper: BottomClipper("top"),
                              child: new Container(
                                padding: EdgeInsets.only(left: 15, top: 6),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4))
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(packageItem.desc, style: TextStyle(color: Colors.black54,fontSize: 18.0),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          new Positioned(
                            width: MediaQuery.of(context).size.width,
                            height: 10,
                            top: -1,
                            child: new ClipPath(
                              clipper: BottomClipper("buttom"),
                              child: new Container(
                                padding: EdgeInsets.only(left: 15, top: 6),
                                decoration: BoxDecoration(
                                    color: Colors.white,
//                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4))
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Divider(height: 28, color: Colors.grey[200],),
                ],
              ),
            ),
            new Container(
              height: 60.0,
              child: new Padding(
                padding: EdgeInsets.all(10.0),
                child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      "套餐权益",
                      style: new TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            new Container(
              child: new Padding(
                padding: EdgeInsets.all(10.0),
                child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      packageItem.seconds,
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    )),
              ),
            ),
            new Container(
              height: 60.0,
              child: new Padding(
                padding: EdgeInsets.all(10.0),
                child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      "注意事项",
                      style: new TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            new Container(
              child: new Padding(
                padding: EdgeInsets.only(left: 10.0, top: 5.0),
                child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      packageItem.reminds,
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

    List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        SliverAppBar(
          //标题居中
          centerTitle: true,
          //展开高度250
          expandedHeight: 50.0,
          //不随着滑动隐藏标题
          floating: false,
          //固定在顶部
          pinned: true,
          forceElevated: true,
          brightness: Brightness.dark,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 252, 130, 45),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
             title: new Text("套餐", style: new TextStyle(color: Colors.white)),
            background: null,
          ),
          leading: IconButton(
            color: Colors.white,
            icon: BackButtonIcon(),
            onPressed: () {
              Navigator.pop(super.context);
            },
          ),
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
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
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
  int totalNums = 0;

  TextEditingController textEditingController = new TextEditingController();

  Widget build(BuildContext context) {
    return new Container(
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
                    onPressed: null,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class BottomClipper extends CustomClipper<Path> {

  String position = 'top';

  @override
  Path getClip(Size size) {
    var path = Path();
    if(position.contains("buttom")){
      path.moveTo(0.0, 0.0);
      path.lineTo(10, 0.0);
      int doble = 72;
      for(var i = 1; i <= (doble / 2); i++){
        path.lineTo(size.width / doble * ((4 * (i - 1)) + 1), 0);
        path.quadraticBezierTo(size.width / doble * (2 * (2 * i - 1)), 10, size.width / doble * (4 * i - 1), 0);
        path.lineTo(size.width / doble * (4 * i), 0);
      }
      path.lineTo(size.width, 0);
      path.close();

      return path;

    }
    path.lineTo(0.0, 6);
    int doble = 80;
    for(var i = 1; i <= (doble / 2); i++){
      path.lineTo(size.width / doble * ((4 * (i - 1)) + 1), 6);
      path.quadraticBezierTo(size.width / doble * (2 * (2 * i - 1)), 0, size.width / doble * (4 * i - 1), 6);
      path.lineTo(size.width / doble * (4 * i), 6);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

  BottomClipper(this.position);
}
