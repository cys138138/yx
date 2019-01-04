import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yx/utils/WidgetsUtils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
import 'package:yx/utils/toast/TsUtils.dart';


/**
 * 绑定银行卡
 */
class QrcodePage extends StatefulWidget {
  @override
  _QrcodePage createState() => _QrcodePage();
}

class _QrcodePage extends State<QrcodePage> {
  WidgetsUtils widgetsUtils;
  static const double ARROW_ICON_WIDTH = 16.0;
  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var textPadding = const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0);
  Widget qrImg = new CircularProgressIndicator(
    backgroundColor: Colors.green,
  );

  String _promtoCode="";

  @override
  void initState() {
    super.initState();
    initQrcode();
  }


  @override
  Widget build(BuildContext context) {
    widgetsUtils = new WidgetsUtils(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        title: widgetsUtils.getAppBar('绑定银行卡'),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new SingleChildScrollView(
          child: new Stack(
          children: <Widget>[
            new Container(
              child: Column(children: <Widget>[
                qrImg,

                new Container(
                  margin: EdgeInsets.only(top:10.0),
                  padding: EdgeInsets.only(top: 10.0),
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width - 80,
                  height: 50.0,
                  child: Text(_promtoCode,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                ),
                new Container(
                  margin: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width - 80,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Colors.deepOrange
                  ),
                  child: FlatButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: _promtoCode)).then((res){
                            TsUtils.showShort("邀请码已复制至剪切板");
                        });
                      },
                      child: Text("点击复制",style: TextStyle(color: Colors.white,fontSize: 14.0),)
                  ),
                )
              ],),
              alignment: Alignment.center,
              margin: EdgeInsets.all(20.0),
            )
          ],
      )),
    );
  }

  void initQrcode() {
    SpUtils.getUserInfo().then((userInfoBean) {
      if(userInfoBean !=null && userInfoBean.id != null){
        YxHttp.get(YxApi.GET_MY_HOME_DATA+userInfoBean.id,headers: {
          'authorization': 'Token ' + userInfoBean.token
        }).then((res){
          try {
            Map<String,dynamic> data = jsonDecode(res);
            setState(() {
              _promtoCode = data['content']["balance"]['user']["promo_code"].toString();
              qrImg = new QrImage(
                data: _promtoCode,
                size: 300.0,
              );
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
  }

}
