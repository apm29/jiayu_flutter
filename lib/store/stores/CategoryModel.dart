import 'package:flutter/widgets.dart';
import 'package:flutter_scaffold/api/Api.dart';
import 'package:flutter_scaffold/components/modal/TaskModal.dart';
import 'package:flutter_scaffold/model/BaseResp.dart';
import 'package:flutter_scaffold/model/Category.dart';
import 'package:flutter_scaffold/model/MallGoods.dart';
import 'package:flutter_scaffold/model/PageData.dart';
import 'package:flutter_scaffold/store/stores.dart';

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
      this.goodsList = [];
      this.hasMore = true;
      this.loading = false;
      this._total = 0;
      this._page = 1;
    }
    if (!this.loading && this.hasMore) {
      await TaskModal.runTask(context, () async {
        try {
          this.loading = true;
          BaseResp<PageData<MallGoods>> resp = await Api.getGoodsList({
            "pageNo": this._page,
            "pageSize": this._rows,
            "sort":"categoryId",
            "order":"asc"
          });
          if (resp.success) {
            this.goodsList.addAll(resp.data.records);
            this._total = resp.data.total;
            this.hasMore = this._total > this.goodsList.length;
            this._page += 1;
          }
        } catch (e) {
          print(e);
        } finally {
          this.loading = false;
        }
      },tag: 'category');
    }
  }
}