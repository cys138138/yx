import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConsumptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Consumption();
  }
}

class Consumption extends State<ConsumptionPage> {
  var titleStyle = new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);

  var timeStyle = new TextStyle(fontSize: 11.0, color: Colors.grey);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(
          child: new Text("消费", style: new TextStyle(color: Colors.white)),
        ),
      ),
      body: new CustomScrollView(
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
                    child: new Text("热门活动"),
                  ),
                  decoration: new BoxDecoration(color: Colors.black26),
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
                                      child: new Text("私人定制dfdfffffffff",style: titleStyle,maxLines: 1,overflow: TextOverflow.ellipsis,),),
                                  ),
                                  new Center(
                                    child:
                                    new Center(child:
                                      new Text("明星介绍fdsfdsfddfdsfdsfdsfdsfdsfffffffffffffdddddd",style: timeStyle,maxLines: 1,overflow: TextOverflow.ellipsis,),
                                    )

                                  ),
                                ],
                              ),
                            ));
                      }),
                ),
                new Container(
                  child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new Text("艺人列表"),
                  ),
                  decoration: new BoxDecoration(color: Colors.black26),
                  padding: EdgeInsets.all(10.0),
                ),
              ],
            )
            ),
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
                    maxLines: 1,overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: new Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new Text(
                      "介绍",
                      style: timeStyle,
                      maxLines: 1,overflow: TextOverflow.ellipsis,
                    ),
                  ),
                    trailing:new Icon(Icons.chevron_right,color: Colors.orange,)
                );
                return Column(children: <Widget>[
                  InkWell(
                    child: row,
                    onTap: () {
                      print("$index i clik");
                    },
                  ),
                  new Divider(height: 1.0,)
                ],);
              },
            ),
          ),
        ],
      ),
    );
  }
}
