import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yx/app/OsApplication.dart';
import 'package:yx/domain/event/LoginEvent.dart';
import 'package:yx/utils/WidgetsUtils.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
import 'package:yx/utils/toast/TsUtils.dart';

/**
 * 绑定银行卡
 */
class BindBankCardPage extends StatefulWidget {
  @override
  _BindBankCardPage createState() => _BindBankCardPage();
}

class _BindBankCardPage extends State<BindBankCardPage> {
  WidgetsUtils widgetsUtils;
  TextStyle leftMenuStyle = new TextStyle(fontSize: 16.0, color: Colors.black);
  static const double ARROW_ICON_WIDTH = 16.0;
  var titleTextStyle = new TextStyle(fontSize: 16.0);

  var _verifyController = new TextEditingController();
  var textPadding = const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0);
  var _cardNameController = new TextEditingController();
  var _cardAddController = new TextEditingController();
  var _cardnoController = new TextEditingController();

  List<dynamic> _bankList = jsonDecode('[{"value":"CDB","text":"国家开发银行"},{"value":"ICBC","text":"中国工商银行"},{"value":"ABC","text":"中国农业银行"},{"value":"BOC","text":"中国银行"},{"value":"CCB","text":"中国建设银行"},{"value":"PSBC","text":"中国邮政储蓄银行"},{"value":"COMM","text":"交通银行"},{"value":"CMB","text":"招商银行"},{"value":"SPDB","text":"上海浦东发展银行"},{"value":"CIB","text":"兴业银行"},{"value":"HXBANK","text":"华夏银行"},{"value":"GDB","text":"广东发展银行"},{"value":"CMBC","text":"中国民生银行"},{"value":"CITIC","text":"中信银行"},{"value":"CEB","text":"中国光大银行"},{"value":"EGBANK","text":"恒丰银行"},{"value":"CZBANK","text":"浙商银行"},{"value":"BOHAIB","text":"渤海银行"},{"value":"SPABANK","text":"平安银行"},{"value":"SHRCB","text":"上海农村商业银行"},{"value":"YXCCB","text":"玉溪市商业银行"},{"value":"YDRCB","text":"尧都农商行"},{"value":"BJBANK","text":"北京银行"},{"value":"SHBANK","text":"上海银行"},{"value":"JSBANK","text":"江苏银行"},{"value":"HZCB","text":"杭州银行"},{"value":"NJCB","text":"南京银行"},{"value":"NBBANK","text":"宁波银行"},{"value":"HSBANK","text":"徽商银行"},{"value":"CSCB","text":"长沙银行"},{"value":"CDCB","text":"成都银行"},{"value":"CQBANK","text":"重庆银行"},{"value":"DLB","text":"大连银行"},{"value":"NCB","text":"南昌银行"},{"value":"FJHXBC","text":"福建海峡银行"},{"value":"HKB","text":"汉口银行"},{"value":"WZCB","text":"温州银行"},{"value":"QDCCB","text":"青岛银行"},{"value":"TZCB","text":"台州银行"},{"value":"JXBANK","text":"嘉兴银行"},{"value":"CSRCB","text":"常熟农村商业银行"},{"value":"NHB","text":"南海农村信用联社"},{"value":"CZRCB","text":"常州农村信用联社"},{"value":"H3CB","text":"内蒙古银行"},{"value":"SXCB","text":"绍兴银行"},{"value":"SDEB","text":"顺德农商银行"},{"value":"WJRCB","text":"吴江农商银行"},{"value":"ZBCB","text":"齐商银行"},{"value":"GYCB","text":"贵阳市商业银行"},{"value":"ZYCBANK","text":"遵义市商业银行"},{"value":"HZCCB","text":"湖州市商业银行"},{"value":"DAQINGB","text":"龙江银行"},{"value":"JINCHB","text":"晋城银行JCBANK"},{"value":"ZJTLCB","text":"浙江泰隆商业银行"},{"value":"GDRCC","text":"广东省农村信用社联合社"},{"value":"DRCBCL","text":"东莞农村商业银行"},{"value":"MTBANK","text":"浙江民泰商业银行"},{"value":"GCB","text":"广州银行"},{"value":"LYCB","text":"辽阳市商业银行"},{"value":"JSRCU","text":"江苏省农村信用联合社"},{"value":"LANGFB","text":"廊坊银行"},{"value":"CZCB","text":"浙江稠州商业银行"},{"value":"DYCB","text":"德阳商业银行"},{"value":"JZBANK","text":"晋中市商业银行"},{"value":"BOSZ","text":"苏州银行"},{"value":"GLBANK","text":"桂林银行"},{"value":"URMQCCB","text":"乌鲁木齐市商业银行"},{"value":"CDRCB","text":"成都农商银行"},{"value":"ZRCBANK","text":"张家港农村商业银行"},{"value":"BOD","text":"东莞银行"},{"value":"LSBANK","text":"莱商银行"},{"value":"BJRCB","text":"北京农村商业银行"},{"value":"TRCB","text":"天津农商银行"},{"value":"SRBANK","text":"上饶银行"},{"value":"FDB","text":"富滇银行"},{"value":"CRCBANK","text":"重庆农村商业银行"},{"value":"ASCB","text":"鞍山银行"},{"value":"NXBANK","text":"宁夏银行"},{"value":"BHB","text":"河北银行"},{"value":"HRXJB","text":"华融湘江银行"},{"value":"ZGCCB","text":"自贡市商业银行"},{"value":"YNRCC","text":"云南省农村信用社"},{"value":"JLBANK","text":"吉林银行"},{"value":"DYCCB","text":"东营市商业银行"},{"value":"KLB","text":"昆仑银行"},{"value":"ORBANK","text":"鄂尔多斯银行"},{"value":"XTB","text":"邢台银行"},{"value":"JSB","text":"晋商银行"},{"value":"TCCB","text":"天津银行"},{"value":"BOYK","text":"营口银行"},{"value":"JLRCU","text":"吉林农信"},{"value":"SDRCU","text":"山东农信"},{"value":"XABANK","text":"西安银行"},{"value":"HBRCU","text":"河北省农村信用社"},{"value":"NXRCU","text":"宁夏黄河农村商业银行"},{"value":"GZRCU","text":"贵州省农村信用社"},{"value":"FXCB","text":"阜新银行"},{"value":"HBHSBANK","text":"湖北银行黄石分行"},{"value":"ZJNX","text":"浙江省农村信用社联合社"},{"value":"XXBANK","text":"新乡银行"},{"value":"HBYCBANK","text":"湖北银行宜昌分行"},{"value":"LSCCB","text":"乐山市商业银行"},{"value":"TCRCB","text":"江苏太仓农村商业银行"},{"value":"BZMD","text":"驻马店银行"},{"value":"GZB","text":"赣州银行"},{"value":"WRCB","text":"无锡农村商业银行"},{"value":"BGB","text":"广西北部湾银行"},{"value":"GRCB","text":"广州农商银行"},{"value":"JRCB","text":"江苏江阴农村商业银行"},{"value":"BOP","text":"平顶山银行"},{"value":"TACCB","text":"泰安市商业银行"},{"value":"CGNB","text":"南充市商业银行"},{"value":"CCQTGB","text":"重庆三峡银行"},{"value":"XLBANK","text":"中山小榄村镇银行"},{"value":"HDBANK","text":"邯郸银行"},{"value":"KORLABANK","text":"库尔勒市商业银行"},{"value":"BOJZ","text":"锦州银行"},{"value":"QLBANK","text":"齐鲁银行"},{"value":"BOQH","text":"青海银行"},{"value":"YQCCB","text":"阳泉银行"},{"value":"SJBANK","text":"盛京银行"},{"value":"FSCB","text":"抚顺银行"},{"value":"ZZBANK","text":"郑州银行"},{"value":"SRCB","text":"深圳农村商业银行"},{"value":"BANKWF","text":"潍坊银行"},{"value":"JJBANK","text":"九江银行"},{"value":"JXRCU","text":"江西省农村信用"},{"value":"HNRCU","text":"河南省农村信用"},{"value":"GSRCU","text":"甘肃省农村信用"},{"value":"SCRCU","text":"四川省农村信用"},{"value":"GXRCU","text":"广西省农村信用"},{"value":"SXRCCU","text":"陕西信合"},{"value":"WHRCB","text":"武汉农村商业银行"},{"value":"YBCCB","text":"宜宾市商业银行"},{"value":"KSRB","text":"昆山农村商业银行"},{"value":"SZSBK","text":"石嘴山银行"},{"value":"HSBK","text":"衡水银行"},{"value":"XYBANK","text":"信阳银行"},{"value":"NBYZ","text":"鄞州银行"},{"value":"ZJKCCB","text":"张家口市商业银行"},{"value":"XCYH","text":"许昌银行"},{"value":"JNBANK","text":"济宁银行"},{"value":"CBKF","text":"开封市商业银行"},{"value":"WHCCB","text":"威海市商业银行"},{"value":"HBC","text":"湖北银行"},{"value":"BOCD","text":"承德银行"},{"value":"BODD","text":"丹东银行"},{"value":"JHBANK","text":"金华银行"},{"value":"BOCY","text":"朝阳银行"},{"value":"LSBC","text":"临商银行"},{"value":"BSB","text":"包商银行"},{"value":"LZYH","text":"兰州银行"},{"value":"BOZK","text":"周口银行"},{"value":"DZBANK","text":"德州银行"},{"value":"SCCB","text":"三门峡银行"},{"value":"AYCB","text":"安阳银行"},{"value":"ARCU","text":"安徽省农村信用社"},{"value":"HURCB","text":"湖北省农村信用社"},{"value":"HNRCC","text":"湖南省农村信用社"},{"value":"NYNB","text":"广东南粤银行"},{"value":"LYBANK","text":"洛阳银行"},{"value":"NHQS","text":"农信银清算中心"},{"value":"CBBQS","text":"城市商业银行资金清算中心"}]');

  var _bankName="招商银行";

  @override
  void initState() {
    super.initState();
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
    if (_bankList.length == 0) {
      _body.add(new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      ));
    } else {
      _body.add(Container(
        child: new Container(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: textPadding,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "持卡人",
                        style: titleTextStyle,
                      ),
                      flex: 1,
                    ),
                    new Expanded(
                      child: TextField(
                        controller: _cardNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "输入持卡人姓名"
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
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
                        "开户行",
                        style: titleTextStyle,
                      ),
                      flex: 1,
                    ),
                    new Expanded(
                      child: TextField(
                        controller: _cardAddController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "输入开户行"
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
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
                        "卡号",
                        style: titleTextStyle,
                      ),
                      flex: 1,
                    ),
                    new Expanded(
                      child: new TextField(
                        controller: _cardnoController,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "输入卡号",
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
                        _showSelect(context);
                      },
                      child: Text(
                      _bankName,
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
                        "绑定",
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
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        title: widgetsUtils.getAppBar('绑定银行卡'),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new SingleChildScrollView(child: new Stack(
        children: _body,
      )),
    );
  }

  void _post() {
    if (_bankName == null) {
      return TsUtils.showShort("银行必选");
    }
    if (_cardNameController.text.trim().isEmpty) {
      return TsUtils.showShort("持卡人必填");
    }
    if (_cardnoController.text.trim().isEmpty) {
      return TsUtils.showShort("卡号必填");
    }
    if (_cardAddController.text.trim().isEmpty) {
      return TsUtils.showShort("开户行必填");
    }
    SpUtils.getUserInfo().then((userInfoBean) {
      if (userInfoBean != null && userInfoBean.id != null) {
        YxHttp.post(
            YxApi.BIND_BANK_CARD + userInfoBean.id + '/bindcard/',
            headers: {
              'authorization': 'Token ' + userInfoBean.token
            },
            params: {
              "name":_cardNameController.text.trim(),
              "card_no":_cardnoController.text.trim(),
              "sms_code": _verifyController.text.trim(),
              "bank": _bankName,
              "bank_addr":_cardAddController.text.trim()
            }
            ).then((res1) {
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

  void _showSelect(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
              itemCount: _bankList.length,
              itemBuilder: (context, index) {
                var item = _bankList[index];
                print(item);
                return InkWell(
                    onTap: () {
                      setState(() {
                        _bankName = item["text"].toString();
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            children: <Widget>[
                              Text(
                                item["text"].toString(),
                                style: TextStyle(
                                    color: Colors.black),
                              ),
                              Text(
                                  "(code:" +
                                      item["value"]
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
