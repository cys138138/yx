class YxApi {
  // baseUrl
  static final BASE_URL = "http://api.yuexiang020.com/";

//  获取用户信息
  static final String USER_INFO = BASE_URL + "/action/openapi/user";

//  更新头像
  static final String UPDATE_AVATAR =
      BASE_URL + "/action/openapi/portrait_update";

// 获取动弹列表
  static final String TWEET_LIST = BASE_URL + '/action/openapi/tweet_list';

//  回调地址
  static final String REDIRECT_URL = "http://yubo725.top/osc/osc.php";

//首页地址  根据网上博客资源
  static const NEWS_LIST_BASE_URL = "http://osc.yubo725.top/news/list";

//  登录接口
  static final String LOGIN_URL =
      "https://www.oschina.net/action/oauth2/authorize?client_id=4rWcDXCNTV5gMWxtagxI&response_type=code&redirect_uri=" +
          REDIRECT_URL;

// 用户注册接口
  static final String USER_REGISTER = 'api/user/register/';

//  用户登录接口
  static final String USER_LOGIN = 'api/user/auth/';

  //获取验证码接口
  static final String GET_SMS = 'api/user/sms/?mobile=';


  static final String GET_MY_HOME_DATA = 'api/user/myhome/';

  static final String GET_PRODUCT_LIST = 'api/product/productlist/';

  //消费记录/api/user/85/orderlist/
  static final String GET_ORDER_LIST = 'api/user/';

  //推广列表 /api/user/85/orderlist/
  static final String GET_PTOMOTE_LIST = 'api/user/';

  //推广列表 /api/user/85/balance/transactions/
  static final String GET_WATER_LIST = 'api/user/';

  //购买套餐
  // /api/user/85/promotelist/
  static final String BUY_PRODUCT = 'api/user/';

  //绑定银行卡
  //post /api/user/85/bindcard/
//  {"name":"测试","card_no":"666666","sms_code":"3333","bank":"中国工商银行","bank_addr":"广州支行"}
//  {"state":false,"desc":"非法请求","content":{},"errors":{"bank":["该字段不能为空。"]}}

  static final String BIND_BANK_CARD = 'api/user/';

  //获取银行卡列表
  // /api/user/85/bankcardlist/

  //获取转赠列表
  ///api/user/85/balance/transferlist/
  ///{"state":true,"desc":"返回可转赠列表","content":{"transfer_list":[{"user_id":"1","mobile":"00000001","nickname":"公司(主节点)","promo_code":"OZ49QPPEI573","sys_id":"W000001","date_join":"2018-10-17 17:02:48+08:00"},{"user_id":"107","mobile":"15815805621","nickname":"anniego218","promo_code":"WX64WKL8DZZB","sys_id":"W000033","date_join":"2018-11-11 16:11:12+08:00"},{"user_id":"108","mobile":"13610293563","nickname":"陆少芬","promo_code":"LM08LEUJSH6P","sys_id":"W000034","date_join":"2018-11-11 18:32:44+08:00"},{"user_id":"140","mobile":"18664865121","nickname":"张冬","promo_code":"DD312LUPMDJO","sys_id":"W000063","date_join":"2018-12-02 14:56:55+08:00"},{"user_id":"164","mobile":"18664773121","nickname":"三师兄","promo_code":"EA67BR8AUSKA","sys_id":"W000087","date_join":"2018-12-05 09:22:00+08:00"},{"user_id":"210","mobile":"18529197998","nickname":"顶呱呱","promo_code":"GN015HG31Z08","sys_id":"W000133","date_join":"2018-12-18 20:27:32+08:00"},{"user_id":"169","mobile":"18529197998","nickname":"冬","promo_code":"ZQ29F9ABNI61","sys_id":"W000092","date_join":"2018-12-05 14:25:37+08:00"},{"user_id":"218","mobile":"18670059321","nickname":"陈晨","promo_code":"TT52RAIRIF02","sys_id":"W000141","date_join":"2018-12-25 14:33:48+08:00"},{"user_id":"221","mobile":"13252033404","nickname":"","promo_code":"RG318S7N3PZ3","sys_id":"W000144","date_join":"2018-12-26 18:37:46+08:00"},{"user_id":"222","mobile":"13252033405","nickname":"","promo_code":"UV81FMFM0E6J","sys_id":"W000145","date_join":"2018-12-26 18:39:27+08:00"},{"user_id":"223","mobile":"15807657231","nickname":"叭叭","promo_code":"DI436YITI620","sys_id":"W000146","date_join":"2018-12-26 18:44:06+08:00"},{"user_id":"224","mobile":"15807657233","nickname":"","promo_code":"PT59G67SVK9G","sys_id":"W000147","date_join":"2018-12-26 18:49:18+08:00"},{"user_id":"225","mobile":"15807657230","nickname":"","promo_code":"FL156NBSUYVW","sys_id":"W000148","date_join":"2018-12-26 18:51:07+08:00"}]},"errors":{}}
  static final String GET_TRANSGER_LIST = 'api/user/';
  static final String GET_FORGOTPASSWORD_SMS_CODE = '/api/user/forgotpassword/send_sms/?mobile=';

//提交转赠
  ///api/user/85/balance/transfer/
  ///参数
//  {"sms_code":"1111","amount":"1","transfer_to_id":"225"}
//返回 {"state":false,"desc":"验证码错误","content":{},"errors":{}}
  static final String POST_TRANSGER = 'api/user/';

//  banner接口
  static final String HOME_BANNER = 'api/news/banners/';

//  首页文章列表
  static final String HOME_ARTICLE = 'api/news/list/';

  static final String NEWS_DETAIL = 'api/news/';

  static final String STAR_TYPE_LIST = 'api/star/startypelist/';

  static final String STAR_ALL_LIST = 'api/star/alllist/';


  static final String STAR_DETAIL = 'api/star/detail/';

  ///api/star/20/purchase/
  static final String BUY_STAR_TIME = '/api/star/';



//  体系
  static final String HOME_SYSTEM = 'tree/json';

// 体系下的文章
  static final String HOME_SYSTEM_CHILD = 'article/list/';
}
