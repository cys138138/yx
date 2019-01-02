import 'package:flutter/material.dart';
import 'package:yx/pages/ConsumptionPage.dart';
import 'package:yx/pages/IndexPage.dart';
import 'package:yx/pages/PackagePage.dart';
import 'package:yx/utils/net/ParamsUtils.dart';
import 'pages/MyInfoPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

//首页
void main() {
  debugPaintSizeEnabled = false;
  runApp(new MyApp(0));
}

//运行首页
class MyApp extends StatefulWidget {
  int _toutesIndex=0;
  @override
  State<StatefulWidget> createState() {
    return new MyMainState(_toutesIndex);
  }

  MyApp(this._toutesIndex);

}

class MyMainState extends State<MyApp> {

  // 默认索引第一个tab
  int _tabIndex = 0;

  // 正常情况的字体样式
  final tabTextStyleNormal = new TextStyle(color: const Color(0xff969696));

  // 选中情况的字体样式
  final tabTextStyleSelect = new TextStyle(color: const Color(0xff63ca6c));

  // 底部菜单栏图标数组
  var tabImages;

  // 页面内容
  var _body;

  // 菜单文案
  var tabTitles = ['约享', '套餐', '消费', '我的'];

  // 路由map
  Map<String, WidgetBuilder> _routes = new Map();

  // 生成image组件
  Image getTabImage(path) {
    return new Image.asset(path, width: 20.0, height: 20.0);
  }

  void initData() {
    // 先那一次数据，把accesstoken放到内存
    ParamsUtils.getParams();
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('images/ic_nav_news_normal.png'),
          getTabImage('images/ic_nav_news_actived.png')
        ],
        [
          getTabImage('images/ic_nav_tweet_normal.png'),
          getTabImage('images/ic_nav_tweet_actived.png')
        ],
        [
          getTabImage('images/ic_nav_discover_normal.png'),
          getTabImage('images/ic_nav_discover_actived.png')
        ],
        [
          getTabImage('images/ic_nav_my_normal.png'),
          getTabImage('images/ic_nav_my_pressed.png')
        ]
      ];
    }
    _body = new IndexedStack(
      children: <Widget>[
        new IndexPage(),
        new PackagePage(),
        new ConsumptionPage(),
        new MyInfoPage()
      ],
      index: _tabIndex,
    );

    _routes = {
    // When we navigate to the "/second" route, build the SecondScreen Widget
    '/usre_info': (context) => MyApp(3),
    '/star_list': (context) => MyApp(2),
    '/packege_list': (context) => MyApp(1),
    '/index': (context) => MyApp(0),
    };
  }

  //获取菜单栏字体样式
  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabTextStyleSelect;
    } else {
      return tabTextStyleNormal;
    }
  }

  // 获取图标
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  // 获取标题文本
  Text getTabTitle(int curIndex) {
    return new Text(
      tabTitles[curIndex],
      style: getTabTextStyle(curIndex),
    );
  }

  // 获取BottomNavigationBarItem
  List<BottomNavigationBarItem> getBottomNavigationBarItem() {
    List<BottomNavigationBarItem> list = new List();
    for (int i = 0; i < 4; i++) {
      list.add(new BottomNavigationBarItem(
          icon: getTabIcon(i), title: getTabTitle(i)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: const Color.fromARGB(255, 252, 130, 45),
      ),
      routes: _routes,
      home: new Scaffold(
//          appBar: new AppBar(
//            title: new Center(child:
//              new Text(tabTitles[_tabIndex],
//                  style: new TextStyle(color: Colors.white)
//              ),
//            ),
//            iconTheme: new IconThemeData(color: Colors.white),
//          ),
          body: _body,
          bottomNavigationBar: new CupertinoTabBar(
            items: getBottomNavigationBarItem(),
            currentIndex: _tabIndex,
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
          ),
//          drawer: new Container(child: new LeftDraw(),)
      ),
    );
  }

  MyMainState(this._tabIndex);
}
