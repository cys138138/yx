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

class _NewsDetailPageState extends State<YxStarDetailPage>  with TickerProviderStateMixin{
  String _url, _title, _id;
  var newsDetail = Map();

  var wid;

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
    }else {
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
                    showBottomSheet<State>(
                        context: context,
                        builder: (BuildContext context){
                          return new bottomSheetDliog();
                        }
                    );
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
          SliverToBoxAdapter(
              child: toboxAdapter
          ),
        ],
      ),
    );
  }

  void getNewsDetail(String id) {
    YxHttp.get(YxApi.STAR_DETAIL + _id + "/").then((res) {
      try {
        Map<String, dynamic> map = jsonDecode(res);

        Future.delayed(new Duration(milliseconds: 100),(){
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

class bottomSheetDliog extends StatefulWidget{
  State<StatefulWidget> createState() => new bottomSheetDliogState();
}
class bottomSheetDliogState extends State{
  int buycount = 1;
  @override
  Widget build(BuildContext context){
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
          new Positioned(
            top: -25,
            child: new Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      //商品缩略图
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Image.asset('assets/images/short05.jpg', fit: BoxFit.cover, height: 120,),
                      ),
                      //价格编号说明
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text('¥89.8', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                            Text('商品编号：001', style: TextStyle(fontSize: 16),)
                          ],
                        ),
                      ),
                    ],
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 8),
                    child: Text('产品规格', style: TextStyle(fontSize: 20),),
                  ),
                  new Row(
                    children: <Widget>[
                      new FlatButton(
                        color: Color.fromARGB(255, 180, 10, 10),
                        disabledColor: Color.fromARGB(255, 200, 10, 10),
                        child: Text('时尚运动版', style: TextStyle(color: Colors.white),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        onPressed: null,
                      ),
                      Text('    '),
                      new FlatButton(
                        color: Color.fromARGB(255, 180, 10, 10),
                        child: Text('炫动休闲版', style: TextStyle(color: Color.fromARGB(255, 200, 10, 10)),),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color.fromARGB(255, 200, 10, 10)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        onPressed: null,
                      ),
                    ],
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width - 30,
                    padding: EdgeInsets.only(top: 15, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('购买数量', style: TextStyle(fontSize: 20),),
                        //数量选择器
                        new Container(
                          width: 100,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 30,
                                child: new GestureDetector(
                                  child: Icon(Icons.remove, size: 12,),
                                  onTap: (){
                                    setState(() {
                                      if(buycount > 1){
                                        buycount --;
                                      }
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: new Container(
                                  alignment: AlignmentDirectional.center,
                                  child: Text(buycount.toString(), style: TextStyle(color: Colors.grey),),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                child: new GestureDetector(
                                  child: Icon(Icons.add, size: 12,),
                                  onTap: (){
                                    setState(() {
                                      buycount ++;
                                    });
                                  },
                                ),
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
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ),
          //底部按钮组
          new Positioned(
            width: MediaQuery.of(context).size.width,
            height: 80,
            bottom: 0,
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: FloatingActionButton(
                    child: Text(' 加入购物车'),
                    shape: Border(),
                    backgroundColor: Color.fromARGB(255, 180, 10, 10),
                    isExtended: true,
                    onPressed: null,
                  ),
                ),
                Expanded(
                  child: FloatingActionButton(
                    child: Text('立即购买'),
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
