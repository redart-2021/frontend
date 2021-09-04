import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/completed_quest.dart';
import '../repos/completed_quest.dart';
import '../utils/paginators.dart';
import '../utils/widgets.dart';


class CompletedQuestListPage extends StatefulWidget {
  static const name = 'completed_quest_list_page';

  @override
  CompletedQuestListPageState createState() => CompletedQuestListPageState();
}


class CompletedQuestListPageState extends State<CompletedQuestListPage> {
  LimitOffsetPaginator<CompletedQuest> _paginator;
  final formatter = DateFormat('dd.MM.yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    final repo = context.read<CompletedQuestRepo>();
    _paginator = LimitOffsetPaginator<CompletedQuest>(repo: repo)
      ..fetchNext(notifyStart: false);
  }


  @override
  Widget build(BuildContext context) {
    return PaginatedListView(_paginator, _buildListItem);
  }

  Widget _buildListItem(BuildContext context, dynamic _item) {
    final item = _item as CompletedQuest;

    return ChangeNotifierProvider<CompletedQuest>.value(
      value: item,
      child: Consumer<CompletedQuest>(
        builder: (context, changedItem, child) => Card(
          color: Colors.lightGreen[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Icon(Icons.task),
            title: Text(changedItem.name),
            subtitle: Row(
              children: [
                Expanded(child: Text(changedItem.description ?? '')),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Сдан:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatter.format(changedItem.completedAt),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                  ],
                )
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(changedItem.coins.toString()),
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
