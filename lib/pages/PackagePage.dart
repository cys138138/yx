import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PackagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new Package();
  }
}

class Package extends State<PackagePage> {
  var packageList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPackageList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(
          child: new Text("套餐", style: new TextStyle(color: Colors.white)),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView.builder(
          itemBuilder: (context, index) => rendRow(index),
          itemCount: packageList.length,
        ),
      ),
    );
  }

  void getPackageList() {
    List<Map<String,dynamic>> _list = [];
    for (int i=0;i<10;i++){
      Map<String,dynamic> _map = {
        "title":"100秒套餐",
        'sub_title':"用于消费100秒的套餐 $i",
        "money":"1000",
      };
      _list.add(_map);
    }
    packageList = _list;
  }

  Widget rendRow(i) {
    var itemMap = packageList[i];
    return new InkWell(
      onTap: () {
        print("this is p $i");
      },
      child: new Container(
        height: 110.0,
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: const Color.fromARGB(255, 252, 130, 45),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 6.0, bottom: 3.0, left: 6.0),
                  child: new Text(itemMap["title"],
                      style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 3.0, bottom: 6.0, left: 6.0),
                  child: new Text(itemMap["sub_title"],
                      style: new TextStyle(fontSize: 12.0, color: Colors.white)),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            new Container(
              margin: EdgeInsets.only(top: 5.0),
              child:  new Row(
                children: <Widget>[
                  new Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13.0)),
                    child: new Padding(
                      padding: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
                      child: new Center(
                        child: new Text("立即购买",
                            style: new TextStyle(
                                fontSize: 10.0, color: Colors.orange)),
                      ),
                    ),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Row(
                      // 为了让评论数显示在最右侧，所以需要外面的Expanded和这里的MainAxisAlignment.end
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text("¥"+itemMap["money"],
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ],
              ),),

          ],
        ),
      ),
    );
  }
}

