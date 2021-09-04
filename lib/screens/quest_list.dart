import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quest.dart';
import '../repos/quest.dart';
import '../utils/paginators.dart';
import '../utils/widgets.dart';


class QuestListPage extends StatefulWidget {
  static const name = 'quest_list_page';

  @override
  QuestListPageState createState() => QuestListPageState();
}


class QuestListPageState extends State<QuestListPage> {
  LimitOffsetPaginator<Quest> _paginator;

  @override
  void initState() {
    super.initState();
    final repo = context.read<QuestRepo>();
    _paginator = LimitOffsetPaginator<Quest>(repo: repo)
      ..fetchNext(notifyStart: false);
  }


  @override
  Widget build(BuildContext context) {
    return PaginatedListView(_paginator, _buildListItem);
  }

  Widget _buildListItem(BuildContext context, dynamic _item) {
    final item = _item as Quest;

    return ChangeNotifierProvider<Quest>.value(
      value: item,
      child: Consumer<Quest>(
        builder: (context, changedItem, child) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Icon(Icons.task),
            title: Text(changedItem.name),
            subtitle: Text(changedItem.description ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(changedItem.reward.toString()),
                SizedBox(width: 10),
                Image.asset('images/coin.png', height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
