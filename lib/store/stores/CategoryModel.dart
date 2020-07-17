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
/// author : ciih
/// date : 2020/7/15 2:02 PM
/// description : 
///
class CategoryModel {
  List<Category> categoryList = [];
  List<MallGoods> goodsList = [];
  bool hasMore = true;
  bool loading = false;
  int _total = 0;
  int _page = 1;
  int _rows = 20;

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

  CategoryModel();

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