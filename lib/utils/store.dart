import 'package:flutter/foundation.dart';

import 'base_model.dart';
import 'paginators.dart';


class ItemWithPaginator {
  final LimitOffsetPaginator paginator;
  final BaseModel item;
  final bool shouldFetch;

  ItemWithPaginator({this.paginator, this.item, this.shouldFetch = true});
}


class SelectedPageStore extends ChangeNotifier {
  String _page;

  SelectedPageStore(this._page);

  String get page => _page;
  set page(String val) {
    if (_page == val) {
      return;
    }
    _page = val;
    notifyListeners();
  }
}
