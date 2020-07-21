///
/// author : ciih
/// date : 2020/7/21 3:48 PM
/// description : 
///
import 'dart:convert' show json;
import 'package:flutter/foundation.dart';
import 'package:jiayu_flutter/model/MallGoods.dart';

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

class GoodsDetail {
  GoodsDetail({
    this.attributes,
    this.goods,
    this.products,
    this.specifications,
  });

  factory GoodsDetail.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<Attributes> attributes =
    jsonRes['attributes'] is List ? <Attributes>[] : null;
    if (attributes != null) {
      for (final dynamic item in jsonRes['attributes']) {
        if (item != null) {
          tryCatch(() {
            attributes
                .add(Attributes.fromJson(asT<Map<String, dynamic>>(item)));
          });
        }
      }
    }

    final List<Products> products =
    jsonRes['products'] is List ? <Products>[] : null;
    if (products != null) {
      for (final dynamic item in jsonRes['products']) {
        if (item != null) {
          tryCatch(() {
            products.add(Products.fromJson(asT<Map<String, dynamic>>(item)));
          });
        }
      }
    }

    final List<Specifications> specifications =
    jsonRes['specifications'] is List ? <Specifications>[] : null;
    if (specifications != null) {
      for (final dynamic item in jsonRes['specifications']) {
        if (item != null) {
          tryCatch(() {
            specifications
                .add(Specifications.fromJson(asT<Map<String, dynamic>>(item)));
          });
        }
      }
    }
    return GoodsDetail(
      attributes: attributes,
      goods: MallGoods.fromJson(asT<Map<String, dynamic>>(jsonRes['goods'])),
      products: products,
      specifications: specifications,
    );
  }

  List<Attributes> attributes;
  MallGoods goods;
  List<Products> products;
  List<Specifications> specifications;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'attributes': attributes,
    'goods': goods,
    'products': products,
    'specifications': specifications,
  };
  @override
  String toString() {
    return json.encode(this);
  }

}

class Attributes {
  Attributes({
    this.addTime,
    this.attribute,
    this.deleted,
    this.goodsId,
    this.id,
    this.updateTime,
    this.value,
  });

  factory Attributes.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Attributes(
    addTime: asT<String>(jsonRes['addTime']),
    attribute: asT<String>(jsonRes['attribute']),
    deleted: asT<int>(jsonRes['deleted']),
    goodsId: asT<int>(jsonRes['goodsId']),
    id: asT<int>(jsonRes['id']),
    updateTime: asT<String>(jsonRes['updateTime']),
    value: asT<String>(jsonRes['value']),
  );

  String addTime;
  String attribute;
  int deleted;
  int goodsId;
  int id;
  String updateTime;
  String value;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'addTime': addTime,
    'attribute': attribute,
    'deleted': deleted,
    'goodsId': goodsId,
    'id': id,
    'updateTime': updateTime,
    'value': value,
  };
  @override
  String toString() {
    return json.encode(this);
  }
}


class Products {
  Products({
    this.addTime,
    this.deleted,
    this.goodsId,
    this.id,
    this.number,
    this.price,
    this.specifications,
    this.updateTime,
    this.url,
  });

  factory Products.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<String> specifications =
    jsonRes['specifications'] is List ? <String>[] : null;
    if (specifications != null) {
      for (final dynamic item in jsonRes['specifications']) {
        if (item != null) {
          tryCatch(() {
            specifications.add(asT<String>(item));
          });
        }
      }
    }
    return Products(
      addTime: asT<String>(jsonRes['addTime']),
      deleted: asT<int>(jsonRes['deleted']),
      goodsId: asT<int>(jsonRes['goodsId']),
      id: asT<int>(jsonRes['id']),
      number: asT<int>(jsonRes['number']),
      price: asT<int>(jsonRes['price']),
      specifications: specifications,
      updateTime: asT<String>(jsonRes['updateTime']),
      url: asT<String>(jsonRes['url']),
    );
  }

  String addTime;
  int deleted;
  int goodsId;
  int id;
  int number;
  int price;
  List<String> specifications;
  String updateTime;
  String url;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'addTime': addTime,
    'deleted': deleted,
    'goodsId': goodsId,
    'id': id,
    'number': number,
    'price': price,
    'specifications': specifications,
    'updateTime': updateTime,
    'url': url,
  };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Specifications {
  Specifications({
    this.addTime,
    this.deleted,
    this.goodsId,
    this.id,
    this.specification,
    this.updateTime,
    this.url,
    this.value,
  });

  factory Specifications.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : Specifications(
        addTime: asT<String>(jsonRes['addTime']),
        deleted: asT<int>(jsonRes['deleted']),
        goodsId: asT<int>(jsonRes['goodsId']),
        id: asT<int>(jsonRes['id']),
        specification: asT<String>(jsonRes['specification']),
        updateTime: asT<String>(jsonRes['updateTime']),
        url: asT<String>(jsonRes['url']),
        value: asT<String>(jsonRes['value']),
      );

  String addTime;
  int deleted;
  int goodsId;
  int id;
  String specification;
  String updateTime;
  String url;
  String value;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'addTime': addTime,
    'deleted': deleted,
    'goodsId': goodsId,
    'id': id,
    'specification': specification,
    'updateTime': updateTime,
    'url': url,
    'value': value,
  };
  @override
  String toString() {
    return json.encode(this);
  }
}
