import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/score_history.dart';
import '../repos/score_history.dart';
import '../utils/paginators.dart';
import '../utils/widgets.dart';


class ScoreHistoryPage extends StatefulWidget {
  static const name = 'score_history_page';

  @override
  ScoreHistoryPageState createState() => ScoreHistoryPageState();
}


class ScoreHistoryPageState extends State<ScoreHistoryPage> {
  LimitOffsetPaginator<ScoreHistory> _paginator;
  final formatter = DateFormat('dd.MM.yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    final repo = context.read<ScoreHistoryRepo>();
    _paginator = LimitOffsetPaginator<ScoreHistory>(repo: repo)
      ..fetchNext(notifyStart: false);
  }


  @override
  Widget build(BuildContext context) {
    return PaginatedListView(_paginator, _buildListItem);
  }

  Widget _buildListItem(BuildContext context, dynamic _item) {
    final item = _item as ScoreHistory;
    final up = Icon(Icons.arrow_upward, color: Colors.green);
    final down = Icon(Icons.arrow_downward, color: Colors.red);

    return ChangeNotifierProvider<ScoreHistory>.value(
      value: item,
      child: Consumer<ScoreHistory>(
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
                          changedItem.score.toString(),
                          style: TextStyle(fontSize: 25),
                        ),
                        changedItem.score > 0 ? up : down,
                        Icon(Icons.star, color: Colors.yellow),
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
