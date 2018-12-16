import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConsumptionPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Consumption();
  }

}

class Consumption extends State<ConsumptionPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child:
          new Text("消费")
        ),
      ),
      body: new Container(decoration: new BoxDecoration(
        color: Colors.black26
      ),
      height: 200.0,
        child: new Column(children: <Widget>[
            new Container(
                margin: EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    new Align(
                        alignment: Alignment.centerLeft,child:
                    new Text("热门活动"),),
//                    ListView.builder(
//                        scrollDirection:Axis.horizontal,
//                        itemCount: 10,
//                        itemBuilder: (context,index){
//                          return  new Column(
//                            children: <Widget>[
//                                new CircleAvatar(
//                                backgroundImage: AssetImage("images/ic_avatar_default.png"),
//                                radius: 15.0,
//                              ),
//                              new Center(child:
//                                new Text("私人定制"),
//                              ),
//                              new Center(
//                                child: new Text("明星介绍"),
//                              )
//                            ],
//                          );
//
//                    })
                  ],

                ),
            height: 150.0,
            )
        ],),
        ),
      );
  }
}