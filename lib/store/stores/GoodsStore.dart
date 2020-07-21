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
/// author : ciih
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
  GoodsStore();

  Future<void> getGoodsDetail(BuildContext context,goodsId) async {
    try {
      StoreProvider.of<JiaYuState>(context).dispatch(LoadingAction(true));
      BaseResp<GoodsDetail> resp = await Api.getGoodsDetail(goodsId);
      if(resp.success){
        goodsDetail = resp.data;
      }
    } catch (e) {
      print(e);
    } finally {
      StoreProvider.of<JiaYuState>(context).dispatch(LoadingAction(false));
    }
  }

  Map<String,List<Specifications>>  get specificationsMap {
    List<Specifications> array = goodsDetail?.specifications??[];
    Map<String,List<Specifications>> map = Map();
    array.forEach((element) {
      if(map[element.specification]==null){
        map[element.specification] = [];
      }
      map[element.specification].add(element);
    });
    return map;
  }
}

GoodsStore indexReducer(GoodsStore state, action) {
  return appStateReducer(state, action);
}

class GoodsDetailLoadAction {
  final BuildContext context;
  final dynamic goodsId;
  GoodsDetailLoadAction(this.context,this.goodsId);
}

final appStateReducer = combineReducers<GoodsStore>(
  [
    TypedReducer<GoodsStore, GoodsDetailLoadAction>((state, action) {
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
  ()async{
    await store.state.getGoodsDetail(action.context,action.goodsId);
    next(action);
  }();

}
