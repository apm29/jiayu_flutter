import 'package:flutter_scaffold/model/BaseResp.dart';
import 'package:flutter_scaffold/api/RemoteUtils.dart';
import 'package:flutter_scaffold/model/Category.dart';
import 'package:flutter_scaffold/model/MallGoods.dart';
import 'package:flutter_scaffold/model/PageData.dart';

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

  static Future<BaseResp<PageDate<MallGoods>>> getGoodsList() {
    return RemoteUtils().post<PageDate<MallGoods>>("/mall/goods/list",
        processor: (s) => PageDate<MallGoods>.fromJson(
            s, (json) => MallGoods.fromJson(json)));
  }
}
