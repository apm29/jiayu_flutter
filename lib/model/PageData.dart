///
/// author : apm29
/// date : 2020/7/8 5:01 PM
/// description :
///
import 'dart:convert' show json;
import 'package:flutter/foundation.dart';
import 'package:flutter_scaffold/api/RemoteUtils.dart';

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

class PageData<T> {
  PageData({
    this.total,
    this.size,
    this.current,
    this.orders,
    this.records,
    this.hitCount,
    this.searchCount,
    this.pages,
  });

  factory PageData.fromJson(
      Map<String, dynamic> jsonRes, JsonProcessor<T> processor) {
    if (jsonRes == null) {
      return null;
    }

    final List<String> orders = jsonRes['orders'] is List ? <String>[] : null;
    if (orders != null) {
      for (final dynamic item in jsonRes['orders']) {
        if (item != null) {
          tryCatch(() {
            orders.add(asT<String>(item));
          });
        }
      }
    }

    final List<T> records = jsonRes['records'] is List ? <T>[] : null;
    if (records != null) {
      for (final dynamic item in jsonRes['records']) {
        if (item != null) {
          tryCatch(() {
            records.add(processor(item));
          });
        }
      }
    }
    return PageData(
      total: asT<int>(jsonRes['total']),
      size: asT<int>(jsonRes['size']),
      current: asT<int>(jsonRes['current']),
      orders: orders,
      records: records,
      hitCount: asT<bool>(jsonRes['hitCount']),
      searchCount: asT<bool>(jsonRes['searchCount']),
      pages: asT<int>(jsonRes['pages']),
    );
  }

  int total;
  int size;
  int current;
  List<String> orders;
  List<T> records;
  bool hitCount;
  bool searchCount;
  int pages;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'total': total,
        'size': size,
        'current': current,
        'orders': orders,
        'records': records,
        'hitCount': hitCount,
        'searchCount': searchCount,
        'pages': pages,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}
