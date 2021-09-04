import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repos/achievement.dart';
import 'repos/balance_history.dart';
import 'repos/command_challenge.dart';
import 'repos/completed_quest.dart';
import 'repos/individual_challenge.dart';
import 'repos/quest.dart';
import 'repos/score_history.dart';
import 'repos/user.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/settings.dart';
import 'utils/api_client.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balance Platform',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.light(
          primary: Colors.orange,
          secondary: Colors.orangeAccent[700]
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.light,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/settings': (context) => SettingsPage(),
        '/home': (context) => HomePageWrapper(),
      },
    );
  }
}


void main() {
  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => HttpApiClient()),
      ChangeNotifierProxyProvider<HttpApiClient, UserRepo>(
        create: (context) => UserRepo(),
        update: (context, client, repo) => repo..client = client,
      ),
      ProxyProvider<HttpApiClient, QuestRepo>(
        create: (context) => QuestRepo(),
        update: (context, client, repo) => repo..client = client,
      ),
      ProxyProvider<HttpApiClient, AchievementRepo>(
        create: (context) => AchievementRepo(),
        update: (context, client, repo) => repo..client = client,
      ),
      ProxyProvider<HttpApiClient, BalanceHistoryRepo>(
        create: (context) => BalanceHistoryRepo(),
        update: (context, client, repo) => repo..client = client,
      ),
      ProxyProvider<HttpApiClient, ScoreHistoryRepo>(
        create: (context) => ScoreHistoryRepo(),
        update: (context, client, repo) => repo..client = client,
      ),
      ProxyProvider<HttpApiClient, CompletedQuestRepo>(
        create: (context) => CompletedQuestRepo(),
        update: (context, client, repo) => repo..client = client,
      ),
      ProxyProvider<HttpApiClient, IndividualChallengeRepo>(
        create: (context) => IndividualChallengeRepo(),
        update: (context, client, repo) => repo..client = client,
      ),
      ProxyProvider<HttpApiClient, CommandChallengeRepo>(
        create: (context) => CommandChallengeRepo(),
        update: (context, client, repo) => repo..client = client,
      ),
    ],
    child: App(),
  ));
}
