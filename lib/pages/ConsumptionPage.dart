import 'package:flutter/material.dart';

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
  var tabtitleStyle = new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);

  var timeStyle = new TextStyle(fontSize: 11.0, color: Colors.grey);

  List<TabTitle> tabList;
  TabController mController;

  var titleDecoration = new BoxDecoration(color: Color.fromARGB(240, 240, 243, 255));

  void initState() {
    super.initState();
    //初始化选项
    _initTabData();
    mController = TabController(length: tabList.length, vsync: this);
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

  CustomScrollView _getTabBarViewPage(int pid) {
    return new CustomScrollView(
      reverse: false,
      shrinkWrap: false,
      slivers: <Widget>[
        new SliverAppBar(
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
                  child: new Text("热门活动",style: tabtitleStyle,),
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
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            print("点击了$index");
                          },
                          child: new Container(
                            width: 100.0,
                            padding: EdgeInsets.all(10.0),
                            child: new Column(
                              children: <Widget>[
                                new CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://img.zcool.cn/community/006eae59c73b61a8012053f847d75f.jpg"),
                                  radius: 35.0,
                                ),
                                new Center(
                                  child: new Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: new Text(
                                      "$pid 私人定制",
                                      style: titleStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                new Center(
                                    child: new Center(
                                  child: new Text(
                                    "$pid 明星介绍",
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
                  child: new Text("艺人列表",style: tabtitleStyle,),
                ),
                decoration: titleDecoration,
                padding: EdgeInsets.all(10.0),
              ),
            ],
          )),
        ),
        SliverFixedExtentList(
          itemExtent: 80.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              var row = ListTile(
                  leading: new CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://img.zcool.cn/community/006eae59c73b61a8012053f847d75f.jpg"),
                    radius: 30.0,
                  ),
                  title: new Text(
                    "名字",
                    style: titleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: new Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new Text(
                      "介绍",
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
                      print("$index i clik");
                    },
                  ),
                  new Divider(
                    height: 1.0,
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _initTabData() {
    tabList = List<TabTitle>.generate(20, (int i) {
      return new TabTitle(
          new Tab(
            child: new Text("测试$i"),
          ),
          i);
    });
  }
}

class TabTitle {
  int pid;
  Widget tabWidget;
  TabTitle(this.tabWidget, this.pid);
}
