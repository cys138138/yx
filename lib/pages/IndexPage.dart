// 资讯列表页面
import 'dart:convert';

import 'package:banner_view/banner_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yx/pages/news/YxNewsDetailPage.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewsListPageState();
  }
}

class NewsListPageState extends State<IndexPage> {
  var bannerDataList = [];

  var listData = [];
  // 分页
  var _mCurPage = 0;
  Utf8Decoder decode = new Utf8Decoder();

  var titleStyle = new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);

  var timeStyle = new TextStyle(fontSize: 11.0, color: Colors.grey);

  void initState() {
    super.initState();
    getBannerDataList();
    getNewsList(_mCurPage);
  }

  @override
  Widget build(BuildContext context) {
    if (listData.length == 0) {
      return new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      );
    } else {



        var _body = new Refresh(
        onFooterRefresh: onFooterRefresh,
        onHeaderRefresh: onHeaderRefresh,
        childBuilder: (BuildContext context,
            {ScrollController controller, ScrollPhysics physics}) {
          return new Container(
              child: new ListView.builder(
                  // 这里itemCount是将轮播图组件、分割线和列表items都作为ListView的item算了
                  itemCount: listData.length * 2 + 1,
                  controller: controller,
                  physics: physics,
                  itemBuilder: (context, i) => rendRow(i)));
        },
      );

        return new Scaffold(
          appBar: new AppBar(
            title: new Center(
              child: new Text("约享", style: new TextStyle(color: Colors.white)),
            ),
            elevation: 0,
          ),
          body: _body,
        );
    }
  }

  rendRow(int i) {
    //第一行是banner
    if (i == 0) {
      return new Column(children: <Widget>[
        new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                color: const Color.fromARGB(255, 252, 130, 45),
              ),
              height: 100.0,
            ),
            new Container(
              margin: new EdgeInsets.only(top: 15.0),
              height: 150.0,
              child: new Center(
                child: new Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: new Center(
                        child: Swiper(
                      itemBuilder: (BuildContext context, int index) =>
                          rendBanner(index),
                      itemCount: bannerDataList.length,
                      itemWidth: MediaQuery.of(context).size.width,
                      autoplay: true,
                      loop: true,
                    ))),
              ),
            ),
          ],
        ),
        new Container(
          padding: EdgeInsets.all(10.0),
          child: new Text(
            "资讯",
            style: new TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          alignment: AlignmentDirectional.center,
        ),
        new Padding(
          child: new Divider(
            height: 1.0,
          ),
          padding: EdgeInsets.only(bottom: 10.0),
        )
      ]);
    } else {
      i -= 1;
      // i为奇数，渲染分割线
      if (i.isOdd) {
        return new Divider(height: 1.0);
      }

      // 将i取整
      i = i ~/ 2;
      // 得到列表item的数据

      var itemData = listData[i];
      var row = new ListTile(
          leading: new ClipRRect(
            borderRadius: BorderRadius.circular(3.0),
            child: new Image.network(
              itemData["img_url"],
              width: 100.0,
              height: 60.0,
              fit: BoxFit.cover,
            ),
          ),
          title: new Text(
            itemData["title"],
            style: titleStyle,
          ),
          subtitle: new Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: new Text(
              itemData["create_at"],
              style: timeStyle,
            ),
          ));
      return new InkWell(
        child: row,
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new YxNewsDetailPage(
                itemData['id'], itemData['url'], itemData['title']);
          }));
        },
      );
    }
  }

  getBannerDataList() {
    List<Map<String, dynamic>> dataList = [];

    YxHttp.get(YxApi.HOME_BANNER).then((res) {
      try {
        Map<String, dynamic> map = jsonDecode(res);
        var banners = map['content']['banners'];
        for (int i = 0; i < banners.length; i++) {
          var mapItem = banners[i]['news'];
          dataList.add({
            "url": "",
            "id": mapItem["id"],
            "title": mapItem['title'],
            "sub_title": mapItem['title'],
            'img_url': mapItem['img_url'],
          });
        }

        setState(() {
          bannerDataList = dataList;
        });
      } catch (e) {
        print('错误catch s $e');
      }
    });
  }

  // 获取文章列表数据
  getNewsList(int curPage) {
    var url = YxApi.HOME_ARTICLE + "?page=" + curPage.toString();
    YxHttp.get(url).then((res) {
      try {
        Map<String, dynamic> map = jsonDecode(res);
        setState(() {
          var _listData = map['content']['products'];
          if (curPage == 1) {
            listData.clear();
            listData.addAll(_listData);
          } else {
            listData.addAll(_listData);
          }
        });
      } catch (e) {
        print('错误catch s $e');
      }
    });
  }

  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        _mCurPage++;
        getNewsList(_mCurPage);
      });
    });
  }

  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      _mCurPage = 1;
      getBannerDataList();
      getNewsList(_mCurPage);
    });
  }

  Widget rendBanner(int i) {
    return new InkWell(
        onTap: () {
          var itemData = bannerDataList[i];
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new YxNewsDetailPage(
                itemData['id'], itemData['url'], itemData['title']);
          }));
        },
        child: new ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: new Image.network(
            bannerDataList[i]['img_url'],
            fit: BoxFit.cover,
          ),
        ));
  }
}
