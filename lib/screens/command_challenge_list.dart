import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/command_challenge.dart';
import '../repos/command_challenge.dart';
import '../utils/paginators.dart';
import '../utils/widgets.dart';


class CommandChallengeListPage extends StatefulWidget {
  static const name = 'command_challenge_list_page';

  @override
  CommandChallengeListPageState createState() => CommandChallengeListPageState();
}


class CommandChallengeListPageState extends State<CommandChallengeListPage> {
  LimitOffsetPaginator<CommandChallenge> _paginator;
  final formatter = DateFormat('dd.MM.yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    final repo = context.read<CommandChallengeRepo>();
    _paginator = LimitOffsetPaginator<CommandChallenge>(repo: repo)
      ..fetchNext(notifyStart: false);
  }


  @override
  Widget build(BuildContext context) {
    return PaginatedListView(_paginator, _buildListItem);
  }

  Widget _buildListItem(BuildContext context, dynamic _item) {
    final item = _item as CommandChallenge;
    var color = Colors.white;
    if (item.answer == 'accepted') color = Colors.green[200];
    else if (item.answer == 'rejected') color = Colors.red[200];

    return ChangeNotifierProvider<CommandChallenge>.value(
      value: item,
      child: Consumer<CommandChallenge>(
        builder: (context, changedItem, child) => Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            leading: Icon(Icons.task),
            title: Text(changedItem.name),
            subtitle: Text(changedItem.description ?? ''),
            trailing: changedItem.isPrivate ? Icon(Icons.lock) : Icon(Icons.lock_open),
            children: [
              ListTile(
                leading: Icon(Icons.task),
                title: Text(changedItem.quest.name),
                subtitle: Text(changedItem.quest.description ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(changedItem.quest.reward.toString()),
                    SizedBox(width: 10),
                    Image.asset('images/coin.png', height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
