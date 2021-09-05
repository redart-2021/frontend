import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/achievement.dart';
import '../repos/achievement.dart';
import '../utils/paginators.dart';
import '../utils/widgets.dart';


class AchievementListPage extends StatefulWidget {
  static const name = 'achievement_list_page';

  @override
  AchievementListPageState createState() => AchievementListPageState();
}


class AchievementListPageState extends State<AchievementListPage> {
  LimitOffsetPaginator<Achievement> _paginator;
  final formatter = DateFormat('dd.MM.yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    final repo = context.read<AchievementRepo>();
    _paginator = LimitOffsetPaginator<Achievement>(repo: repo)
      ..fetchNext(notifyStart: false);
  }


  @override
  Widget build(BuildContext context) {
    return PaginatedGridView(_paginator, _buildListItem, null, 5);
  }

  Widget _buildListItem(BuildContext context, dynamic _item) {
    final item = _item as Achievement;

    return ChangeNotifierProvider<Achievement>.value(
      value: item,
      child: Consumer<Achievement>(
        builder: (context, changedItem, child) => Card(
          color: changedItem.assignedAt == null ? null : Colors.lightGreen[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              constraints: BoxConstraints(maxWidth: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: changedItem.image != null
                      ? Image.network(changedItem.image, width: 150)
                      : SizedBox(width: 150, height: 150),
                  ),
                  Text(changedItem.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(changedItem.description ?? ''),
                  if (changedItem.assignedAt != null)
                    Text('Получена: ${formatter.format(changedItem.assignedAt)}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
