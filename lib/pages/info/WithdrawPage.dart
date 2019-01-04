import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yx/app/OsApplication.dart';
import 'package:yx/domain/event/DataChangeEvent.dart';
import 'package:yx/domain/event/LoginEvent.dart';
import 'package:yx/pages/info/BindBankCardPage.dart';
import 'package:yx/utils/WidgetsUtils.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
import 'package:yx/utils/toast/TsUtils.dart';

/**
 * 提现
 */
class WithdrawPage extends StatefulWidget {
  @override
  _WithdrawPage createState() => _WithdrawPage();
}

class _WithdrawPage extends State<WithdrawPage> {
  List<dynamic> _orderList = List<dynamic>();
  WidgetsUtils widgetsUtils;
  TextStyle leftMenuStyle = new TextStyle(fontSize: 16.0, color: Colors.black);
  static const double ARROW_ICON_WIDTH = 16.0;
  var titleTextStyle = new TextStyle(fontSize: 16.0);

  String uname = "";
  String bank_card_id;
  var _verifyController = new TextEditingController();
  var textPadding = const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0);
  var _moneyController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    banklist();
    OsApplication.eventBus.on<DataChangeEvent>().listen((event) {
      setState(() {
        _orderList.clear();
        banklist();
      });
    });
  }
  int _seconds = 0;

  String _verifyStr = '获取验证码';

  Timer _timer;

  _startTimer() {
    _seconds = 5;

    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }

      _seconds--;
      _verifyStr = '$_seconds(s)';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }

  Widget _buildVerifyCodeEdit() {
    var node = new FocusNode();
    Widget verifyCodeEdit = new TextField(
      onChanged: (str) {},
      decoration: new InputDecoration(
        hintText: '请输入验证码',
        border: InputBorder.none,
      ),
      maxLines: 1,
      controller: _verifyController,
      //键盘展示为数字
      keyboardType: TextInputType.number,
      //只能输入数字
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      onSubmitted: (text) {
        FocusScope.of(context).reparentIfNeeded(node);
      },
    );

    Widget verifyCodeBtn = new InkWell(
      onTap: (_seconds == 0)
          ? () {
        setState(() {
          _startTimer();
        });
        //获取验证码
        SpUtils.getUserInfo().then((userInfoBean) {
          if (userInfoBean != null && userInfoBean.id != null) {
            YxHttp.get(YxApi.GET_FORGOTPASSWORD_SMS_CODE +
                userInfoBean.sys_id)
                .then((res) {
              try {
                Map<String, dynamic> data = jsonDecode(res);
                if (data["error"] != null) {
                  return TsUtils.showShort(data["desc"]);
                }
                return TsUtils.showShort("短信已发送，请留意手机短信");
              } catch (e) {
                print('错误catch s $e');
              }
            });
          }
        });
      }
          : null,
      child: new Container(
        alignment: Alignment.center,
        width: 80.0,
        height: 40.0,
        decoration: new BoxDecoration(
          border: new Border.all(
            width: 1.0,
            color: Colors.blue,
          ),
        ),
        child: new Text(
          '$_verifyStr',
          style: new TextStyle(fontSize: 14.0),
        ),
      ),
    );

    return new Padding(
      padding: const EdgeInsets.only(left: 0.0, top: 0.0),
      child: new Stack(
        children: <Widget>[
          verifyCodeEdit,
          new Align(
            alignment: Alignment.bottomRight,
            child: verifyCodeBtn,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widgetsUtils = new WidgetsUtils(context);
    List<Widget> _body = List();
    if (_orderList.length == 0) {
      _body.add(new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      ));
    } else {
      var rightArrowIcon = new Image.asset(
        'images/ic_arrow_right.png',
        width: ARROW_ICON_WIDTH,
        height: ARROW_ICON_WIDTH,
      );
      _body.add(Container(
        child: new Container(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
                child: InkWell(
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          "提现到",
                          style: titleTextStyle,
                        ),
                        flex: 1,
                      ),
                      new Expanded(
                        child: new Text(
                          uname,
                          style:
                          TextStyle(fontSize: 16.0, color: Colors.deepOrange),
                        ),
                        flex: 3,
                      ),
                      InkWell(
                        child: rightArrowIcon,
                        onTap: () {
                          _showSelect(context);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _showSelect(context);
                  },
                ),
              ),
              new Divider(
                height: 1.0,
              ),
              new Padding(
                padding: textPadding,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "提现金额",
                        style: titleTextStyle,
                      ),
                      flex: 1,
                    ),
                    new Expanded(
                      child: new TextField(
                        controller: _moneyController,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "输入金额",
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        //只能输入数字
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                      ),
                      flex: 3,
                    ),
                    InkWell(
                      onTap: (){
                        SpUtils.getUserInfo().then((userInfoBean) {
                          if(userInfoBean !=null && userInfoBean.id != null){
                            YxHttp.get(YxApi.GET_MY_HOME_DATA+userInfoBean.id,headers: {
                              'authorization': 'Token ' + userInfoBean.token
                            }).then((res){
                              try {
                                Map<String,dynamic> data = jsonDecode(res);
                                setState(() {
                                  _moneyController.text = data['content']["balance"]['total'].toString();
                                });
                              } catch (e) {
                                print('错误catch s $e');
                              }
                            });
                          }else{
                            TsUtils.showShort("先去登录");
                            Navigator.of(context).pop();
                          }
                        });

                      },
                      child: Text(
                        "全部转出",
                        style:
                        TextStyle(fontSize: 14.0, color: Colors.deepOrange),
                      ),),

                  ],
                ),
              ),
              new Divider(
                height: 1.0,
              ),
              new Padding(
                padding: textPadding,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "验证码",
                        style: titleTextStyle,
                      ),
                      flex: 1,
                    ),
                    new Expanded(
                      child: _buildVerifyCodeEdit(),
                      flex: 4,
                    ),
                  ],
                ),
              ),
              new Divider(
                height: 1.0,
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0),
                alignment: Alignment.center,
                child: new Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 40.0,
                  decoration: new BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(3.0)),
                  child: new FlatButton(
                      onPressed: () {
                        _post();
                      },
                      child: Text(
                        "提现",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      )),
                ),
              )
            ],
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: new AppBar(
        title: widgetsUtils.getAppBar('提现'),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new Stack(
        children: _body,
      ),
    );
  }

  void _post() {
    if (bank_card_id == null) {
      return TsUtils.showShort("银行卡必选");
    }
    if (_moneyController.text.trim().isEmpty) {
      return TsUtils.showShort("金额必填");
    }
    if (_verifyController.text.trim().isEmpty) {
      return TsUtils.showShort("验证码必填");
    }
    SpUtils.getUserInfo().then((userInfoBean) {
      if (userInfoBean != null && userInfoBean.id != null) {
        YxHttp.post(
            YxApi.POST_WITHDRAW + userInfoBean.id + '/balance/withdraw/',
            headers: {
              'authorization': 'Token ' + userInfoBean.token
            },
            params: {
              "sms_code": _verifyController.text.trim(),
              "amount": _moneyController.text.trim(),
              "bank_card_id": bank_card_id
            }).then((res1) {
          try {
            Map<String, dynamic> data = res1;
            TsUtils.showShort(data["desc"]);
          } catch (e) {
            print('错误catch s $e');
          }
        });
      }
    });
  }

  void banklist() {
    SpUtils.getUserInfo().then((userInfoBean) {
      if (userInfoBean != null && userInfoBean.id != null) {
        YxHttp.get(
            YxApi.GET_BANK_CARD_LIST +
                userInfoBean.id +
                '/bankcardlist/',
            headers: {'authorization': 'Token ' + userInfoBean.token})
            .then((res) {
          try {
            Map<String, dynamic> data = jsonDecode(res);            
            setState(() {
              _orderList = data['content']["bank_card_list"];
              if(_orderList.length == 0){
                TsUtils.showShort("还没添加银行卡，请先添加");
                Future.delayed(Duration(seconds: 2),(){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
                    return BindBankCardPage();
                  }));
                });
              }
            });
          } catch (e) {
            print('错误catch s $e');
          }
        });
      }
    });
  }

  void _showSelect(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
              itemCount: _orderList.length,
              itemBuilder: (context, index) {
                var item = _orderList[index];
                return InkWell(
                    onTap: () {
                      setState(() {
                        uname = item["bank"].toString();
                        bank_card_id = item["id"].toString();
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            children: <Widget>[
                              Text(
                                item["bank"].toString(),
                                style: TextStyle(
                                    color: Colors.black),
                              ),
                              Text(
                                  "(卡号:" +
                                      item["card_no"]
                                          .toString() +
                                      ")",
                                  style: TextStyle(
                                      color: Colors.grey)),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1.0,
                        ),
                      ],
                    ));
              });
        });
  }
}
