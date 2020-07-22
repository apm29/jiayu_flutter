import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jiayu_flutter/api/Api.dart';
import 'package:jiayu_flutter/model/BaseResp.dart';
import 'package:jiayu_flutter/model/GoodsDetail.dart';
import 'package:jiayu_flutter/store/actions.dart';
import 'package:jiayu_flutter/store/stores.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux/redux.dart';

///
/// author : apm29
/// date : 2020/7/17 2:01 PM
/// description :
///
final goodsStore = DevToolsStore<GoodsStore>(
  indexReducer,
  initialState: GoodsStore(),
  middleware: createAppMiddleware(),
);

class GoodsStore {
  GoodsDetail goodsDetail;
  PageController pageController = PageController();
  Products currentProducts;
  List<String> currentSpecification = [];

  GoodsStore();

  Future<void> getGoodsDetail(BuildContext context, goodsId) async {
    try {
      StoreProvider.of<JiaYuState>(context).dispatch(LoadingAction(true));
      BaseResp<GoodsDetail> resp = await Api.getGoodsDetail(goodsId);
      if (resp.success) {
        goodsDetail = resp.data;
        currentProducts = goodsDetail.products?.first;
        currentSpecification = List.from(currentProducts?.specifications ?? []);
      }
    } catch (e) {
      print(e);
    } finally {
      StoreProvider.of<JiaYuState>(context).dispatch(LoadingAction(false));
    }
  }

  Map<String, List<Specifications>> get specificationsMap {
    List<Specifications> array = goodsDetail?.specifications ?? [];
    Map<String, List<Specifications>> map = Map();
    array.forEach((element) {
      if (map[element.specification] == null) {
        map[element.specification] = [];
      }
      map[element.specification].add(element);
    });
    return map;
  }

  bool productMatch(Products currentProducts, List<String> specification) {
    if (currentProducts == null) {
      return false;
    }
    return arrayEqual(currentProducts.specifications, specification);
  }

  bool specificationMatch(Specifications specification) {
    int keyIndex = specificationsMap.keys.toList().indexOf(specification
        .specification);
    if (currentProducts == null) {
      return false;
    }
    return currentProducts.specifications[keyIndex] == specification.value;
  }

  bool arrayEqual(List<String> one, List<String> other) {
    if (one.length != other.length) {
      return false;
    }
    bool equal = true;
    for (String element in one) {
      if (element != other[one.indexOf(element)]) {
        equal = false;
      }
    }
    return equal;
  }

  void changeSpecification(Specifications e) {
    int index = specificationsMap.keys.toList().indexOf(e.specification);
    currentSpecification[index] = e.value;
    currentProducts = goodsDetail.products
        .firstWhere((element) => productMatch(element, currentSpecification));
  }
}

GoodsStore indexReducer(GoodsStore state, action) {
  return appStateReducer(state, action);
}

class GoodsDetailLoadAction {
  final BuildContext context;
  final dynamic goodsId;

  GoodsDetailLoadAction(this.context, this.goodsId);
}

class ChangeSpecificationAction {
  final Specifications specifications;

  ChangeSpecificationAction(this.specifications);
}

final appStateReducer = combineReducers<GoodsStore>(
  [
    TypedReducer<GoodsStore, GoodsDetailLoadAction>((state, action) {
      return state;
    }),
    TypedReducer<GoodsStore, ChangeSpecificationAction>((state, action) {
      state.changeSpecification(action.specifications);
      return state;
    }),
  ],
);

List<Middleware<GoodsStore>> createAppMiddleware() {
  return [
    TypedMiddleware<GoodsStore, GoodsDetailLoadAction>(onLoadGoods),
  ];
}

onLoadGoods(Store<GoodsStore> store, GoodsDetailLoadAction action,
    NextDispatcher next) {
  () async {
    await store.state.getGoodsDetail(action.context, action.goodsId);
    next(action);
  }();
}
