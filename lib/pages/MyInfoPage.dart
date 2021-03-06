import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yx/app/OsApplication.dart';
import 'package:yx/domain/event/LoginEvent.dart';
import 'package:yx/pages/info/BankCardListPage.dart';
import 'package:yx/pages/info/GivingPage.dart';
import 'package:yx/pages/info/PromoteListPage.dart';
import 'package:yx/pages/info/QrcodePage.dart';
import 'package:yx/pages/info/RunWaterListPage.dart';
import 'package:yx/pages/info/SetInfoPage.dart';
import 'package:yx/pages/info/UserInfoPage.dart';
import 'package:yx/pages/info/WithdrawPage.dart';
import 'package:yx/pages/login/LoginPage.dart';
import 'package:yx/pages/info/CousumptionOrderListPage.dart';
import 'package:yx/pages/menu/SetPage.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  var userAvatar;
  var userName;
  var titles = [
    "我的消费记录",
    "推广列表",
    "流水明细",
    "绑定银行卡",
    "个人信息",
//    "我的团队",
    "邀请好友",
    "设置"
  ];
  var imagePaths = [
    "images/ic_my_message.png",
    "images/ic_my_blog.png",
    "images/ic_my_blog.png",
    "images/ic_my_question.png",
    "images/ic_discover_pos.png",
    "images/ic_my_team.png",
    "images/ic_my_recommend.png"
        "images/ic_my_recommend.png"
  ];

  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var rightArrowIcon = new Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  Map<String, dynamic> _userDataInfo;

  @override
  void initState() {
    super.initState();

    _getUserInfo();
    _getInitData();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        print(event.userName.toString());
        if (event != null && event.userName != null) {
          userName = event.userName;
          userAvatar = 'images/default_avatar.png';
          _getInitData();
        } else {
          userName = null;
          userAvatar = null;
          _userDataInfo = null;
          _login();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return initView();
  }

//  构建布局
  Widget initView() {
    return new CustomScrollView(reverse: false, shrinkWrap: false, slivers: <
        Widget>[
      new SliverAppBar(
          pinned: false,
          backgroundColor: Colors.transparent,
          brightness: Brightness.dark,
          expandedHeight: 330.0,
          iconTheme: new IconThemeData(color: Colors.transparent),
          flexibleSpace: new Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              ClipPath(
                clipper: BottomClipper(),
                child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 252, 130, 45),
                        image: DecorationImage(
                          image: AssetImage(
                            'images/bg_mine.png',
                          ),
                          fit: BoxFit.cover,
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    child: new InkWell(
                      onTap: () {
                        userAvatar == null ? _login() : null;
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 40.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new CircleAvatar(
                                  backgroundImage: userAvatar == null
                                      ? new AssetImage(
                                          'images/ic_avatar_default.png')
                                      : new AssetImage(userAvatar),
                                  radius: 50),
                              new Container(
                                margin: const EdgeInsets.fromLTRB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: new Text(
                                  userName == null ? '点击头像登录' : userName,
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          )),
                    )),
              ),
              new Positioned(
                width: MediaQuery.of(context).size.width,
                height: 160,
                bottom: 0,
                child: new Container(
                  margin: EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: Colors.grey[100])),
                  padding: EdgeInsets.only(left: 8, right: 8, top: 20),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text(
                                _userDataInfo == null
                                    ? "--"
                                    : _userDataInfo["balance"]['total']
                                            .toString() +
                                        '元',
                                style: TextStyle(fontSize: 16),
                              ),
                              new Text('我的余额',
                                  style: TextStyle(
                                      color: Colors.orange[200], height: 1.2)),
                            ],
                          ),
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text(
                                _userDataInfo == null
                                    ? "--"
                                    : _userDataInfo['all_score'].toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                              new Text(
                                '平台总消费',
                                style: TextStyle(
                                    color: Colors.orange[200], height: 1.2),
                              ),
                            ],
                          ),
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text(
                                _userDataInfo == null
                                    ? "--"
                                    : _userDataInfo["balance"]['seconds']
                                            .toString() +
                                        '秒',
                                style: TextStyle(fontSize: 16),
                              ),
                              new Text(
                                '可消费总额',
                                style: TextStyle(
                                    color: Colors.orange[200], height: 1.2),
                              ),
                            ],
                          ),
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text(
                                _userDataInfo == null
                                    ? "--"
                                    : _userDataInfo["balance"]['dynamic']
                                            .toString() +
                                        '元',
                                style: TextStyle(fontSize: 16),
                              ),
                              new Text(
                                '动态奖励',
                                style: TextStyle(
                                    color: Colors.orange[200], height: 1.2),
                              ),
                            ],
                          ),
                        ],
                      ),
                      new Divider(
                        height: 24,
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new InkWell(
                              onTap: (){
                                _jump(new WithdrawPage());
                              },
                              child: new Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Icon(
                                      Icons.payment,
                                      size: 30,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '提现',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        '可提现' +
                                            (_userDataInfo == null
                                                ? "--"
                                                : _userDataInfo["balance"]
                                                        ['withdrawable']
                                                    .toString()) +
                                            '元',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            new InkWell(
                                onTap: () {
                                  _jump(new GivingPage());
                                },
                                child: new Row(
                                  children: <Widget>[
                                    new Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Icon(
                                        Icons.card_giftcard,
                                        size: 30,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '转赠',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          '可转赠' +
                                              (_userDataInfo == null
                                                  ? "--"
                                                  : _userDataInfo["balance"]
                                                          ['transferrable']
                                                      .toString()) +
                                              '元',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
      new SliverFixedExtentList(
          delegate:
              new SliverChildBuilderDelegate((BuildContext context, int index) {
            String title = titles[index];
            return new Container(
                alignment: Alignment.centerLeft,
                child: new InkWell(
                  onTap: () {
                    switch (index) {
                      case 0:
                        return _jump(new CousumptionOrderListPage());
                        break;
                      case 1:
                        return _jump(new PromoteListPage());
                        break;
                      //流水明细
                      case 2:
                        return _jump(new RunWaterListPage());
                        break;
                      //银行卡
                      case 3:
                        return _jump(new BankCardListPage());
                        break;
                      //个人信息
                      case 4:
                        return _jump(new SetInfoPage(_userDataInfo));
                        break;
                        //二维码
                      case 5:
                        return _jump(new QrcodePage());
                        break;
                      case 6:
                        return _jump(new SetPage());
                        break;
                    }
                    print("the is the item of $title");
                  },
                  child: new Container(
                    child: new Column(
                      children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                  child: new Text(
                                title,
                                style: titleTextStyle,
                              )),
                              rightArrowIcon
                            ],
                          ),
                        ),
                        new Divider(
                          height: 1.0,
                        )
                      ],
                    ),
                  ),
                ));
          }, childCount: titles.length),
          itemExtent: 60.0),
    ]);
  }

  _login() async {
    final result = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) {
      return new LoginPage();
    }));
    if (result != null && result == 'refresh') {
      _getUserInfo();
    }
  }

  _userDetail() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new UserInfoPage();
    }));
  }

  _getUserInfo() async {
    SpUtils.getUserInfo().then((userInfoBean) {
      print(userInfoBean);
      if (userInfoBean.id == null) {
//        return _login();
      }

      if (userInfoBean != null && userInfoBean.username != null) {
        setState(() {
          userName = userInfoBean.username;
          userAvatar = 'images/default_avatar.png';
        });
      }
    });
  }

  void _getInitData() {
    SpUtils.getUserInfo().then((userInfoBean) {
      if (userInfoBean != null && userInfoBean.id != null) {
        print('authorization Token ' + userInfoBean.token);
        YxHttp.get(YxApi.GET_MY_HOME_DATA + userInfoBean.id,
                headers: {'authorization': 'Token ' + userInfoBean.token})
            .then((res) {
          try {
            Map<String, dynamic> data = jsonDecode(res);
            setState(() {
              _userDataInfo = data['content'];
            });
          } catch (e) {
            print('错误catch s $e');
          }
        });
      } else {
        _login();
      }
    });
  }

  void _jump(Widget pages) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return pages;
    }));
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 80);
    var firstControlPoint = Offset(size.width / 5, size.height - 20);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 5), size.height - 20);
    var secondPoint = Offset(size.width, size.height - 80);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
