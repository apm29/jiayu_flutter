import 'package:flutter/cupertino.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux/redux.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jiayu_flutter/api/Api.dart';
import 'package:jiayu_flutter/model/BaseResp.dart';
import 'package:jiayu_flutter/model/Category.dart';
import 'package:jiayu_flutter/model/MallGoods.dart';
import 'package:jiayu_flutter/model/PageData.dart';
import 'package:jiayu_flutter/store/stores.dart';
import 'package:jiayu_flutter/store/actions.dart';
///
/// author : apm29
/// date : 2020/7/17 2:01 PM
/// description : 
///
final DevToolsStore<IndexStore> indexStore = DevToolsStore<IndexStore>(
  indexReducer,
  initialState: IndexStore(),
  middleware: createAppMiddleware(),
);

class IndexStore {
  List<int> category = [0,0];
  List<Category> categoryList = [];
  List<MallGoods> goodsList = [];
  List<GlobalKey> keyList = [];
  List<double> itemHeightList = [];
  bool hasMore = true;
  bool loading = false;
  int _total = 0;
  int _page = 1;
  int _rows = 20;
  ScrollController controller = ScrollController();

  ListState get listState => getListState(hasMore, loading);

  getListState(bool hasMore, bool loading) {
    if (loading) {
      return ListState.Loading;
    } else if (hasMore) {
      return ListState.HasMore;
    } else {
      return ListState.NoMore;
    }
  }


  Future<void> loadCategoryData(BuildContext context)async{
    BaseResp<List<Category>> resp = await Api.getCategory();
    this.categoryList = resp.data;
    await loadPagedData(true, context);
  }

  Future<void> loadPagedData(bool refresh,BuildContext context) async {
    if (refresh) {
      this.hasMore = true;
      this.loading = false;
      this._total = 0;
      this._page = 1;
    }
    if (!this.loading && this.hasMore) {
      try {
        StoreProvider.of<JiaYuState>(context).dispatch(LoadingAction(true));
        this.loading = true;
        BaseResp<PageData<MallGoods>> resp = await Api.getGoodsList({
          "pageNo": this._page,
          "pageSize": this._rows,
          "sort":"categoryId",
          "order":"asc"
        });
        if (resp.success) {
          if(refresh){
            this.goodsList.clear();
          }
          this.goodsList.addAll(resp.data.records);
          keyList = this.goodsList.map((e) => GlobalObjectKey(e)).toList();
          itemHeightList = List(keyList.length)..fillRange(0, keyList.length,0);
          if(this.goodsList.length>0) {
            category = this.goodsList[0].categoryId;
          }else{
            category = [0,0];
          }
          this._total = resp.data.total;
          this.hasMore = this._total > this.goodsList.length;
          this._page += 1;
        }
        await Future.delayed(Duration(seconds: 3));
      } catch (e) {
        print(e);
      } finally {
        this.loading = false;
        StoreProvider.of<JiaYuState>(context).dispatch(LoadingAction(false));
      }
    }
  }
}
IndexStore indexReducer(IndexStore state, action) {
  return appStateReducer(state, action);
}

final appStateReducer = combineReducers<IndexStore>(
  [
    TypedReducer<IndexStore, CategoryPageLoadAction>((state, action) {
      return state;
    }),
    TypedReducer<IndexStore, CategoryChangeAction>((state, action) {
      return state;
    }),
  ],
);

List<Middleware<IndexStore>> createAppMiddleware() {
  return [
    TypedMiddleware<IndexStore, CategoryChangeAction>(onCategoryChange),
    TypedMiddleware<IndexStore, CategoryPageLoadAction>(loadCategoryPage),
  ];
}
class CategoryChangeAction{
  final List<int> category;
  CategoryChangeAction(this.category);
}
onCategoryChange(Store<IndexStore> store,CategoryChangeAction action, NextDispatcher next) {
  if(!arrayEqual(store.state.category, action.category)){
    //next(action);
    store.state.category = action.category;
    next(action);
  }
}
loadCategoryPage(
    Store<IndexStore> store, CategoryPageLoadAction action, NextDispatcher next) {
  return () async {
    if(action.refresh) {
      await store.state.loadCategoryData(action.context);
    }else{
      await store.state.loadPagedData(false, action.context);
    }
    next(action);
  }();
}

bool arrayEqual(List<int> one, List<int> other) {
  if(one.length != other.length){
    return false;
  }
  bool equal = true;
  for(int element in one){
    if(element!=other[one.indexOf(element)]){
      equal = false;
    }
  }
  return equal;
}
