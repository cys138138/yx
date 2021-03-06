import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yx/domain/PackageClassBean.dart';
import 'package:yx/pages/order/OrderDetailPage.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';

class PackagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new Package();
  }
}

class Package extends State<PackagePage> {
  List<PackageClassBean> packageList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPackageList();
  }

  @override
  Widget build(BuildContext context) {
    Widget _body;
    if (packageList.length == 0) {
      _body = new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _body = Container(
        padding: EdgeInsets.all(15.0),
        child: ListView.builder(
          itemBuilder: (context, index) => rendRow(index),
          itemCount: packageList.length,
        ),
      );
    }

    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        title: new Center(
          child: new Text("套餐", style: new TextStyle(color: Colors.white)),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: _body,
    );
  }

  void getPackageList() {
    YxHttp.get(YxApi.GET_PRODUCT_LIST).then((res) {
      try {
        List<PackageClassBean> _list = [];
        Map<String, dynamic> map = jsonDecode(res);
        var data = map['content']['products'];
        for (int i = 0; i < data.length; i++) {
          var mapItem = data[i];
          _list.add(PackageClassBean(
            mapItem["id"],
            mapItem["content"],
            mapItem["name"],
            mapItem["img_url"],
            mapItem["desc"],
            mapItem["price"],
            mapItem["quantity"],
            mapItem["seconds"],
            mapItem["reminds"],
            mapItem["create_at"],
          ));
        }

        Future.delayed(new Duration(milliseconds: 500),(){
          setState(() {
            packageList = _list;
          });
        });

      } catch (e) {
        print('错误catch s $e');
      }
    });
  }

  Widget rendRow(i) {
    var itemMap = packageList[i];
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            print("this is p $i");
            _tapRow(itemMap);
          },
          child: new Container(
            height: 170.0,
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
                        padding: EdgeInsets.all(15),
                        child: Text(itemMap.name, style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.start,),
                      ),
                    ),
                    new Expanded(
                      flex: 2,
                      child: new Padding(
                        padding: EdgeInsets.all(15),
                        child: new Center(
                          child: Text('¥' + itemMap.price, style: TextStyle(color: Colors.white, fontSize: 25), textAlign: TextAlign.center,),
                        )
                      ),
                    ),
                  ],
                ),
                new Positioned(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  bottom: 0,
                  child: new ClipPath(
                    clipper: BottomClipper(),
                    child: new Container(
                      padding: EdgeInsets.only(left: 15, top: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4))
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(itemMap.desc, style: TextStyle(color: Colors.black54),),
                          FlatButton(
                            child: Text('立即购买>>', style: TextStyle(color: Color.fromARGB(255, 252, 130, 45),),),
                            onPressed: (){
                              _tapRow(itemMap);

                            },
                          ),
                        ],
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
    );
  }

  void _tapRow(item) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new OrderDetailPage(item);
    }));
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
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
}