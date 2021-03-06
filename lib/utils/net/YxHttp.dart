import 'dart:convert';

import 'package:yx/app/OsApplication.dart';
import 'package:yx/utils/net/Api.dart';
import 'package:http/http.dart' as http;
import 'package:yx/utils/net/YxApi.dart';
import 'dart:async';
import 'package:yx/utils/toast/TsUtils.dart';
import 'package:yx/utils/cache/SpUtils.dart';

class YxHttp {
//  get 请求
  static Future<dynamic> get(String url,
      {Map<String, String> params, bool saveCookie = false,Map<String, String> headers}) async {
    if (params == null) {
      params = new Map();
    }
    if (headers == null) {
      headers = new Map();
    }
    String _url = YxApi.BASE_URL + url;
    if (params != null && params.isNotEmpty) {
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=$value" + "&");
      });
      String paramStr = sb.toString();
      print('参数是$params');
      paramStr = paramStr.substring(0, paramStr.length - 1);
      _url += paramStr;
    }
    print('url是$url');
    print('完整url是$_url');
    http.Response res = await http.get(_url,headers: headers);
    if (res.statusCode == 200) {
      var cookie = res.headers['set-cookie'];
      if (saveCookie) {
        SpUtils.saveCookie(cookie);
        OsApplication.cookie = cookie;
      }
      Utf8Decoder decode = new Utf8Decoder();
      String body = decode.convert(res.bodyBytes);
      var jsonStr = json.decode(body);
      dynamic data = jsonStr;
      print('the data of method is $data');
      return body;
    }else if(res.statusCode == 401){
      SpUtils.cleanUserInfo();
      TsUtils.showShort('登录失效请重新登录');
    }

    else {
      TsUtils.showShort('您的网络好像不太好哟~~~///(^v^)\\\~~~');
    }
  }

//  post请求
  static Future<Map> post(String url,
      {Map<String, String> params, bool saveCookie = false,Map<String, String> headers}) async {
    if (params == null) {
      params = new Map();
    }
    if (headers == null) {
      headers = new Map();
    }
    String _url = YxApi.BASE_URL + url;
    if (OsApplication.cookie != null) {
      params['Cookie'] = OsApplication.cookie;
    }
    print("post data");
    print(params);
    http.Response res = await http.post(_url, body: params,headers: headers);
    print(res.body);
    return _dealWithRes(res, saveCookie: saveCookie);
  }

  //  post请求
  static Future<Map> put(String url,
      {Map<String, String> params, bool saveCookie = false,Map<String, String> headers}) async {
    if (params == null) {
      params = new Map();
    }
    if (headers == null) {
      headers = new Map();
    }
    String _url = YxApi.BASE_URL + url;
    if (OsApplication.cookie != null) {
      params['Cookie'] = OsApplication.cookie;
    }
    print("post data");
    print(params);
    http.Response res = await http.put(_url, body: params,headers: headers);
    print(res.body);
    return _dealWithRes(res, saveCookie: saveCookie);
  }

  static Map<String, dynamic> _dealWithRes(var res, {bool saveCookie}) {
    if (res.statusCode == 200 || res.statusCode == 201) {
      var cookie = res.headers['set-cookie'];
      if (saveCookie) {
        SpUtils.saveCookie(cookie);
        OsApplication.cookie = cookie;
      }


      Utf8Decoder decode = new Utf8Decoder();
      String body = decode.convert(res.bodyBytes);
      var jsonStr = json.decode(body);
      dynamic data = jsonStr;

      print('the jsonStr is $jsonStr');
      return data;
    } else {
      TsUtils.showShort('您的网络好像不太好哟~~~///(^v^)\\\~~~');
      return null;
    }
  }
}
