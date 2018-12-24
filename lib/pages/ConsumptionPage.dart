import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yx/pages/star/Detail.dart';
import 'package:yx/pages/star/YxStarDetailPage.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';

class ConsumptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Consumption();
  }
}

class Consumption extends State<ConsumptionPage>
    with SingleTickerProviderStateMixin {
  var titleStyle = new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);
  var tabtitleStyle =
      new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);

  var timeStyle = new TextStyle(fontSize: 11.0, color: Colors.grey);

  List<TabTitle> tabList = List();
  TabController mController;

  var titleDecoration =
      new BoxDecoration(color: Color.fromARGB(240, 240, 243, 255));

  var hotStarData=[];

  var allStarList = [];

  void initState() {
    super.initState();

    //初始化选项
    _initTabData();
    _initHotStarData();
  }

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 7,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Center(
            child: new Text("消费", style: new TextStyle(color: Colors.white)),
          ),
        ),
        body: new Column(
          children: <Widget>[
            new Container(
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 1.0,
                //是否可以滚动
                controller: mController,
                labelColor: Colors.red,
                unselectedLabelColor: Color(0xff666666),
                labelStyle: TextStyle(fontSize: 16.0),
                tabs: tabList.map((item) {
                  return item.tabWidget;
                }).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: mController,
                children: tabList.map((item) {
                  return _getTabBarViewPage(item.pid);
                }).toList(),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  CustomScrollView _getTabBarViewPage(String pid) {
    var _choiceType = [];
    for(int k = 0;k<allStarList.length;k++){
      if(pid == "0"|| allStarList[k]['stype']['id'] == pid){
        _choiceType.add(allStarList[k]);
      }
    }
    int totalCount = _choiceType.length;
    bool nodata = false;
    if(_choiceType.length == 0){
      totalCount = 1;
      nodata = true;
    }
    var hotWidget = new SliverAppBar(
      pinned: false,
      expandedHeight: 230.0,
      backgroundColor: Colors.white,
      iconTheme: new IconThemeData(color: Colors.transparent),
      flexibleSpace: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Align(
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    "热门活动",
                    style: tabtitleStyle,
                  ),
                ),
                decoration: titleDecoration,
                padding: EdgeInsets.all(10.0),
              ),
              new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                ),
                height: 150.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hotStarData.length,
                    itemBuilder: (context, index) {
                      var Item = hotStarData[index];
                      return InkWell(
                          onTap: () {
                            tapRow(Item);
                          },
                          child: new Container(
                            width: 100.0,
                            padding: EdgeInsets.all(10.0),
                            child: new Column(
                              children: <Widget>[
                                new CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      Item["img_url"]),
                                  radius: 35.0,
                                ),
                                new Center(
                                  child: new Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: new Text(
                                      Item["name"],
                                      style: titleStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                new Center(
                                    child: new Center(
                                      child: new Text(
                                        Item["desc"],
                                        style: timeStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                              ],
                            ),
                          ));
                    }),
              ),
              new Container(
                child: new Align(
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    "艺人列表",
                    style: tabtitleStyle,
                  ),
                ),
                decoration: titleDecoration,
                padding: EdgeInsets.all(10.0),
              ),
            ],
          )),
    );
    List<Widget> _li = [
        new SliverFixedExtentList(
        itemExtent: 80.0,
        delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            if(nodata){
              print("没数据");
              return new Center(
                child: new Text("暂无数据。。"),
              );
            }
            var row = ListTile(
                leading: new CircleAvatar(
                  backgroundImage: NetworkImage(
                      _choiceType[index]["img_url"]),
                  radius: 30.0,
                ),
                title: new Text(
                  _choiceType[index]["name"],
                  style: titleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: new Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: new Text(
                    _choiceType[index]["desc"],
                    style: timeStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: new Icon(
                  Icons.chevron_right,
                  color: Colors.orange,
                ));


            return Column(
              children: <Widget>[
                InkWell(
                  child: row,
                  onTap: () {
                    tapRow(_choiceType[index]);
                  },
                ),
                new Divider(
                  height: 1.0,
                )
              ],
            );

          },
          childCount: totalCount,
        ),
      ),

    ];

    if("0".contains(pid)){
      _li.insert(0, hotWidget);
    }

    return new CustomScrollView(
      reverse: false,
      shrinkWrap: false,
      slivers: _li,
    );
  }

  void _initTabData() {
    tabList = [];
    setState(() {
      tabList.add(new TabTitle(
          new Tab(
            child: new Text("全部"),
          ),"0"));
    });
    YxHttp.get(YxApi.STAR_TYPE_LIST).then((res) {
      try {
        Map<String, dynamic> map = jsonDecode(res);
        var _listData = map['content']['products'];
        List<TabTitle> tempList = List();
        for (var i = 0; i < _listData.length; i++) {
          tempList.add(new TabTitle(
              new Tab(
                child: new Text(_listData[i]['name']),
              ),
              _listData[i]['id']));
        }
        //湛文看好了
        setState(() {
          tabList.addAll(tempList);
          mController = TabController(length: tabList.length, vsync: this);
        });

      } catch (e) {
        print('错误catch s $e');
      }
    });
  }

  void _initHotStarData() {
    YxHttp.get(YxApi.STAR_ALL_LIST).then((res) {
      try {
        Map<String, dynamic> map = jsonDecode(res);

        var _listData = map['content']['hot_star_list'];
        var _all_star_list = map['content']['all_star_list'];
        setState(() {
          hotStarData = _listData;
          allStarList = _all_star_list;
        });

      } catch (e) {
        print('错误catch s $e');
      }
    });
  }

  void tapRow(item) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new YxStarDetailPage(
          item['id'], "", item['name']);
    }));
  }
}

class TabTitle {
  String pid;
  Widget tabWidget;
  TabTitle(this.tabWidget, this.pid);
}
