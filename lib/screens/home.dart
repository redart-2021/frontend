import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repos/user.dart';
import '../utils/dialogs.dart';
import '../utils/store.dart';
import 'achievement_list.dart';
import 'balance_history.dart';
import 'command_challenge_list.dart';
import 'completed_quest_list.dart';
import 'individual_challenge_list.dart';
import 'quest_list.dart';
import 'score_history.dart';


class HomePageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _exit(context),
      child: ChangeNotifierProvider<SelectedPageStore>(
        create: (context) => SelectedPageStore(QuestListPage.name),
        child: HomePage(),
      ),
    );
  }

  _exit(BuildContext context) async {
    return await showConfirmDialog(context, 'Выйти?', null);
  }
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final page = context.watch<SelectedPageStore>().page;
    final user = context.read<UserRepo>().currentUser;
    final scorePosition = user.usersCount == user.scorePosition ? 0
        : ((user.usersCount - user.scorePosition) / user.usersCount * 100).ceil();

    Widget body;
    switch (page) {
      case QuestListPage.name:
        body = QuestListPage();
        break;
      case AchievementListPage.name:
        body = AchievementListPage();
        break;
      case BalanceHistoryPage.name:
        body = BalanceHistoryPage();
        break;
      case ScoreHistoryPage.name:
        body = ScoreHistoryPage();
        break;
      case CompletedQuestListPage.name:
        body = CompletedQuestListPage();
        break;
      case IndividualChallengeListPage.name:
        body = IndividualChallengeListPage();
        break;
      case CommandChallengeListPage.name:
        body = CommandChallengeListPage();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Balance Platform'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, right: 10),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
                ),
                //height: MediaQuery.of(context).size.height,
                child: LeftMenu(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 20),
                child: body,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Container(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'images/logo.png',
                          width: 200,
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Мое место в рейтинге:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            user.scorePosition.toString(),
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                          Text(
                            'Вы обошли $scorePosition% сотрудников',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 50),
                          Text(
                            'Количество коинов:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset('images/coin.png', width: 70),
                              SizedBox(width: 10),
                              Text(
                                user.balance.toString(),
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'images/hamster.png',
                          width: 150,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LeftMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var store = context.watch<SelectedPageStore>();
    return ListView(
      children: [
        ListTile(
          selected: store.page == QuestListPage.name,
          leading: const Icon(Icons.archive_outlined, color: Colors.orange),
          title: const Text('Список задач'),
          onTap: () {
            store.page = QuestListPage.name;
          },
        ),
        ListTile(
          selected: store.page == CompletedQuestListPage.name,
          leading: const Icon(Icons.all_inbox, color: Colors.orange),
          title: const Text('Выполненные задачи'),
          onTap: () {
            store.page = CompletedQuestListPage.name;
          },
        ),
        ListTile(
          selected: store.page == IndividualChallengeListPage.name,
          leading: const Icon(Icons.gamepad, color: Colors.orange),
          title: const Text('Индивидуальные соревнования'),
          onTap: () {
            store.page = IndividualChallengeListPage.name;
          },
        ),
        ListTile(
          selected: store.page == CommandChallengeListPage.name,
          leading: const Icon(Icons.gamepad, color: Colors.orange),
          title: const Text('Командные соревнования'),
          onTap: () {
            store.page = CommandChallengeListPage.name;
          },
        ),
        ListTile(
          selected: store.page == AchievementListPage.name,
          leading: const Icon(Icons.assignment_outlined, color: Colors.orange),
          title: const Text('Мои награды'),
          onTap: () {
            store.page = AchievementListPage.name;
          },
        ),
        ListTile(
          selected: store.page == BalanceHistoryPage.name,
          leading: const Icon(Icons.attach_money, color: Colors.orange),
          title: const Text('Мой кошелек'),
          onTap: () {
            store.page = BalanceHistoryPage.name;
          },
        ),
        ListTile(
          enabled: false,
          leading: const Icon(Icons.calendar_today, color: Colors.orange),
          title: const Text('Общий рейтинг'),
          onTap: () {},
        ),
        ListTile(
          enabled: false,
          selected: false,
          leading: const Icon(Icons.group, color: Colors.orange),
          title: const Text('Моя команда'),
          onTap: () {},
        ),
        ListTile(
          enabled: false,
          selected: false,
          leading: const Icon(Icons.label, color: Colors.orange),
          title: const Text('Рейтинг команд'),
          onTap: () {},
        ),
        ListTile(
          enabled: false,
          selected: false,
          leading: const Icon(Icons.label, color: Colors.orange),
          title: const Text('Ставки'),
          onTap: () {},
        ),
        ListTile(
          selected: store.page == ScoreHistoryPage.name,
          leading: const Icon(Icons.show_chart, color: Colors.orange),
          title: const Text('Рейтинг'),
          onTap: () {
            store.page = ScoreHistoryPage.name;
          },
        ),
        const Divider(height: 50),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.orange),
          title: const Text('Выход'),
          onTap: () => _logout(context),
        ),
      ],
    );
  }

  _logout(BuildContext context) async {
    await SharedPreferences.getInstance()
      ..remove('auth:login')
      ..remove('auth:password')
      ..remove('auth:autoLogin');
    context.read<UserRepo>().logout();
    await Navigator.of(context).pushReplacementNamed('/login');
  }
}
