import 'package:jiayu_flutter/model/BaseResp.dart';
import 'package:jiayu_flutter/api/RemoteUtils.dart';
import 'package:jiayu_flutter/model/Category.dart';
import 'package:jiayu_flutter/model/MallGoods.dart';
import 'package:jiayu_flutter/model/PageData.dart';

List asList(dynamic value) {
  if (value == null || value is! List) {
    return [];
  } else {
    return value;
  }
}

class Api {
  static Future<BaseResp<List<Category>>> getCategory() {
    return RemoteUtils().post<List<Category>>("/mall/category",
        processor: (s) => asList(s).map((e) => Category.fromJson(e)).toList());
  }

  static Future<BaseResp<PageData<MallGoods>>> getGoodsList(data) {
    return RemoteUtils().post<PageData<MallGoods>>(
      "/mall/goods/list",
      processor: (s) =>
          PageData<MallGoods>.fromJson(s, (json) => MallGoods.fromJson(json)),
      jsonData: data
    );
  }
}
