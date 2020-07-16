import 'package:flutter_scaffold/store/actions.dart';
import 'package:flutter_scaffold/store/stores/DashBoardModel.dart';
import 'package:redux/redux.dart';
import 'package:flutter_scaffold/store/stores.dart';

///
/// author : apm29
/// date : 2020/7/8 1:42 PM
/// description :
///
JiaYuState appReducer(JiaYuState state, action) {
  return appStateReducer(state, action)
    ..loading = loadingReducer(state.loading, action)
    ..dashboardModel = dashboardModalReducer(state.dashboardModel, action);
}

final appStateReducer = combineReducers<JiaYuState>(
  [
    TypedReducer<JiaYuState, AddAction>((state, action) {
      state.count += 1;
      return state;
    }),
    TypedReducer<JiaYuState, AppInitAction>((state, action) {
      return state;
    }),
    TypedReducer<JiaYuState, HomeIndexSwitchAction>((state, action) {
      return state..homePageIndex = action.index;
    }),
  ],
);
final loadingReducer = combineReducers<int>([
  TypedReducer<int, LoadingAction>((int state, action) {
    state += action.increase ? 1 : -1;
    return state;
  }),
]);

final dashboardModalReducer = combineReducers<DashboardModel>([
  TypedReducer<DashboardModel, DashboardLoadAction>((state, action) {
    return state;
  }),
]);
