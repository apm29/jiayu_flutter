import 'dart:convert' show json;
import 'package:flutter/foundation.dart';

void tryCatch(Function f) {
  try {
    f?.call();
  } catch (e, stack) {
    debugPrint('$e');
    debugPrint('$stack');
  }
}

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  if (value != null) {
    final String valueS = value.toString();
    if (0 is T) {
      return int.tryParse(valueS) as T;
    } else if (0.0 is T) {
      return double.tryParse(valueS) as T;
    } else if ('' is T) {
      return valueS as T;
    } else if (false is T) {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return bool.fromEnvironment(value.toString()) as T;
    }
  }
  return null;
}

class MallGoods {
  MallGoods({
    this.addTime,
    this.brandId,
    this.brief,
    this.categoryId,
    this.deleted,
    this.detail,
    this.gallery,
    this.goodsSn,
    this.id,
    this.isHot,
    this.isNew,
    this.isOnSale,
    this.keywords,
    this.name,
    this.originPrice,
    this.picUrl,
    this.retailPrice,
    this.shareUrl,
    this.sortOrder,
    this.unit,
    this.updateTime,
  });

  factory MallGoods.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<int> categoryId = jsonRes['categoryId'] is List ? <int>[] : null;
    if (categoryId != null) {
      for (final dynamic item in jsonRes['categoryId']) {
        if (item != null) {
          tryCatch(() {
            categoryId.add(asT<int>(item));
          });
        }
      }
    }

    final List<String> gallery = jsonRes['gallery'] is List ? <String>[] : null;
    if (gallery != null) {
      for (final dynamic item in jsonRes['gallery']) {
        if (item != null) {
          tryCatch(() {
            gallery.add(asT<String>(item));
          });
        }
      }
    }

    final List<String> keywords =
    jsonRes['keywords'] is List ? <String>[] : null;
    if (keywords != null) {
      for (final dynamic item in jsonRes['keywords']) {
        if (item != null) {
          tryCatch(() {
            keywords.add(asT<String>(item));
          });
        }
      }
    }
    return MallGoods(
      addTime: asT<String>(jsonRes['addTime']),
      brandId: asT<int>(jsonRes['brandId']),
      brief: asT<String>(jsonRes['brief']),
      categoryId: categoryId,
      deleted: asT<int>(jsonRes['deleted']),
      detail: asT<String>(jsonRes['detail']),
      gallery: gallery,
      goodsSn: asT<String>(jsonRes['goodsSn']),
      id: asT<int>(jsonRes['id']),
      isHot: asT<bool>(jsonRes['isHot']),
      isNew: asT<bool>(jsonRes['isNew']),
      isOnSale: asT<bool>(jsonRes['isOnSale']),
      keywords: keywords,
      name: asT<String>(jsonRes['name']),
      originPrice: asT<double>(jsonRes['originPrice']),
      picUrl: asT<String>(jsonRes['picUrl']),
      retailPrice: asT<double>(jsonRes['retailPrice']),
      shareUrl: asT<String>(jsonRes['shareUrl']),
      sortOrder: asT<int>(jsonRes['sortOrder']),
      unit: asT<String>(jsonRes['unit']),
      updateTime: asT<String>(jsonRes['updateTime']),
    );
  }

  String addTime;
  int brandId;
  String brief;
  List<int> categoryId;
  int deleted;
  String detail;
  List<String> gallery;
  String goodsSn;
  int id;
  bool isHot;
  bool isNew;
  bool isOnSale;
  List<String> keywords;
  String name;
  double originPrice;
  String picUrl;
  double retailPrice;
  String shareUrl;
  int sortOrder;
  String unit;
  String updateTime;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'addTime': addTime,
    'brandId': brandId,
    'brief': brief,
    'categoryId': categoryId,
    'deleted': deleted,
    'detail': detail,
    'gallery': gallery,
    'goodsSn': goodsSn,
    'id': id,
    'isHot': isHot,
    'isNew': isNew,
    'isOnSale': isOnSale,
    'keywords': keywords,
    'name': name,
    'originPrice': originPrice,
    'picUrl': picUrl,
    'retailPrice': retailPrice,
    'shareUrl': shareUrl,
    'sortOrder': sortOrder,
    'unit': unit,
    'updateTime': updateTime,
  };
  @override
  String toString() {
    return json.encode(this);
  }
}
