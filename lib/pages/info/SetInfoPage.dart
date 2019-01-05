import 'package:flutter/material.dart';
import 'package:yx/app/OsApplication.dart';
import 'package:yx/domain/event/LoginEvent.dart';
import 'package:yx/pages/news/NewsDetailPage.dart';
import 'package:yx/utils/WidgetsUtils.dart';
import 'package:yx/utils/cache/SpUtils.dart';
import 'package:yx/utils/net/YxApi.dart';
import 'package:yx/utils/net/YxHttp.dart';
import 'package:yx/utils/toast/TsUtils.dart';

class SetInfoPage extends StatefulWidget {
  Map<String, dynamic> userInfo;

  SetInfoPage(this.userInfo);

  @override
  _SetInfoPage createState() => _SetInfoPage(userInfo);
}

class _SetInfoPage extends State<SetInfoPage> {
  Map<String, dynamic> userInfo=Map<String, dynamic>();

  _SetInfoPage(this.userInfo);

  List<Map<String,String>> _menuList = List<Map<String,String>>();
  WidgetsUtils widgetsUtils;
  TextStyle leftMenuStyle = new TextStyle(fontSize: 16.0, color: Colors.black);
  var _nickNameController = new TextEditingController();
  String nickname = '';
  @override
  void initState() {
    super.initState();
    if(userInfo.length == 0){
      TsUtils.showShort("邀请码已复制至剪切板");
      Navigator.of(context).pop();
      return;
    }
    nickname = userInfo["balance"]["user"]["nickname"];
    String mobile = userInfo["balance"]["user"]["mobile"];
    String promo_code = userInfo["balance"]["user"]["promo_code"];
    String sys_id = userInfo["balance"]["user"]["sys_id"];
    _nickNameController.text = nickname;
    _menuList.add({
      'title':'用户名',
      'value':nickname,
    });
    _menuList.add({
      'title':'ID',
      'value':sys_id,
    });
    _menuList.add({
      'title':'手机号',
      'value':mobile,
    });
    _menuList.add({
      'title':'推广码',
      'value':promo_code,
    });
  }

  @override
  Widget build(BuildContext context) {
    widgetsUtils = new WidgetsUtils(context);
    return Scaffold(
      appBar: new AppBar(
        title: widgetsUtils.getAppBar('个人信息'),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new ListView.builder(
        itemBuilder: (context, index) => initItem(index),
        itemCount: _menuList.length,
      ),
    );
  }

  initItem(int index) {
    var item = _menuList[index];
    return new InkWell(
      onTap: () {
        if(index == 0){
          _showDialog();
        }
      },
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Row(
              children: <Widget>[
                new Expanded(
                    child: new Text(
                      item['title'],
                      style: leftMenuStyle,
                    )
                ),
                new Text(
                  index == 0 ? nickname :item['value'],
                  style: leftMenuStyle,
                ),
                index == 0 ? new Padding(padding: EdgeInsets.only(left: 5.0),child: new Icon(Icons.edit,color: Colors.deepOrange,size: 20.0,),) : Text("")
              ],
            ),
            margin: new EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 16.0),
          ),
          new Divider(
            height: 1.0,
          )
        ],
      ),
    );
  }


  _showDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
              title: Center(child: new Text('修改昵称'),),
              content: new Container(
                height: 150.0,
                child:
                new Stack(children: <Widget>[
                  TextField(
                    decoration: new InputDecoration(
                      hintText: '请输入昵称',
                      border: InputBorder.none,
                    ),
                    maxLines: 1,
                    controller: _nickNameController,
                  ),
                  Center(
                    child: Container(
                      width: 200.0,
                      height: 30.0,
//                      margin: EdgeInsets.all(50.0),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                      ),
                      child: FlatButton(onPressed: (){
                        SpUtils.getUserInfo().then((userInfoBean) {
                          if (userInfoBean != null && userInfoBean.id != null) {
                            print(userInfoBean.id);
                            YxHttp.put(
                                YxApi.SAVE_USERINFO + userInfoBean.id+'/',
                                headers: {
                                  'Authorization': 'Token ' + userInfoBean.token
                                },
                                params: {
                                  "nickname": _nickNameController.text.trim(),
                                }).then((res1) {
                              try {
                                Map<String, dynamic> data = res1;
                                if(data['state']){
                                  setState(() {
                                    nickname = _nickNameController.text.trim();
                                  });
                                  Navigator.of(context).pop();
                                }
                                TsUtils.showShort(data["desc"]);
                              } catch (e) {
                                print('错误catch s $e');
                              }
                            });
                          }
                        });
                        print(_nickNameController.text);
                      }, child: Text("修改",style: TextStyle(color: Colors.white),)),
                    ),
                  ),

                ],)
               ,
              ),
            ),
        context: context);
  }
}
