import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yx/app/OsApplication.dart';
import 'package:yx/domain/PackageClassBean.dart';
import 'package:yx/domain/event/GoPageEvent.dart';
import 'package:yx/utils/ProgressDialog.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
import 'package:yx/utils/toast/TsUtils.dart';
import 'package:yx/pages/menu/CousumptionOrderListPage.dart';


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
    OsApplication.eventBus.on<GoPageEvent>().listen((event) {
      try{
        if(event.pageName == "LoginPage"){
          return Navigator.pushNamed(context, '/usre_info');
        }else if(event.pageName == "MyInfoPage"){
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new CousumptionOrderListPage();
            
          }));
        }

      }catch(e){

      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                        '立即购买',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {




                        Scaffold.of(context).showBottomSheet(
                              (BuildContext context) {
                            return ModalBottomSheet(packageItem);
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
                    )
                ),
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
             title: new Text("约享套餐", style: new TextStyle(color: Colors.white)),
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
  PackageClassBean packageItem;

  ModalBottomSheet(this.packageItem);

  _ModalBottomSheetState createState() => _ModalBottomSheetState(packageItem);
}

class _ModalBottomSheetState extends State<ModalBottomSheet>
    with SingleTickerProviderStateMixin {



  int totalNums = 0;
  bool _loading = false;

  TextEditingController textEditingController = new TextEditingController();

  PackageClassBean packageItem;

  Widget build(BuildContext context) {

    return ProgressDialog(
      loading: _loading,
      msg: "购买中。。",
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.white24,
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
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: Center(child: Text(
                        '确认购买',
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                      )),
                    ),
                    new Divider(height: 0.5, color: Colors.grey,),
                    new Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: <Widget>[
                          new Center(
                            child: Text(packageItem.name, style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: new Center(
                                child: new Text(
                                  '¥' + packageItem.price,
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                )
                            ),
                          ),

                        ],
                      ),
                    )
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
                  Container(
                    decoration: new BoxDecoration(color: Colors.orange),
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      child: Text('确认购买',style: TextStyle(color: Colors.white),),
                      shape: Border(),
                      onPressed: (){
                        SpUtils.getUserInfo().then((userInfoBean) {
                          setState(() {
                            _loading = true;
                          });
                          if(userInfoBean.id == null){
                            Future.delayed(Duration(seconds: 2),(){
                              OsApplication.eventBus.fire(new GoPageEvent('LoginPage'));
                              setState(() {
                                _loading = false;
                              });
                            });

                            return;
                          }
                          // /api/user/85/product/1/purchase/
                          YxHttp.post(YxApi.BUY_PRODUCT+userInfoBean.id+'/product/'+packageItem.id+"/purchase/",headers: {
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
  _ModalBottomSheetState(this.packageItem);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
