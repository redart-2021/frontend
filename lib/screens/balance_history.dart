import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/balance_history.dart';
import '../repos/balance_history.dart';
import '../utils/paginators.dart';
import '../utils/widgets.dart';


class BalanceHistoryPage extends StatefulWidget {
  static const name = 'balance_history_page';

  @override
  BalanceHistoryPageState createState() => BalanceHistoryPageState();
}


class BalanceHistoryPageState extends State<BalanceHistoryPage> {
  LimitOffsetPaginator<BalanceHistory> _paginator;
  final formatter = DateFormat('dd.MM.yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    final repo = context.read<BalanceHistoryRepo>();
    _paginator = LimitOffsetPaginator<BalanceHistory>(repo: repo)
      ..fetchNext(notifyStart: false);
  }


  @override
  Widget build(BuildContext context) {
    return PaginatedListView(_paginator, _buildListItem);
  }

  Widget _buildListItem(BuildContext context, dynamic _item) {
    final item = _item as BalanceHistory;
    final up = Icon(Icons.arrow_upward, color: Colors.green);
    final down = Icon(Icons.arrow_downward, color: Colors.red);

    return ChangeNotifierProvider<BalanceHistory>.value(
      value: item,
      child: Consumer<BalanceHistory>(
        builder: (context, changedItem, child) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    formatter.format(changedItem.createdAt),
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          changedItem.amount.toString(),
                          style: TextStyle(fontSize: 25),
                        ),
                        changedItem.amount > 0 ? up : down,
                        Icon(Icons.attach_money),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          changedItem.amount.toString(),
                          style: TextStyle(fontSize: 25),
                        ),
                        changedItem.amount > 0 ? up : down,
                        Icon(Icons.ac_unit, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
