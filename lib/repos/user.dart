import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../utils/api_client.dart';


class UserRepo extends ChangeNotifier {
  HttpApiClient _client;
  User currentUser;

  UserRepo();

  set client(HttpApiClient value) => _client = value;

  Future<User> authenticate(String username, String password) async {
    if (_client.fake) {
      if (_client.netDelay != 0) {
        await Future.delayed(Duration(seconds: _client.netDelay));
      }
      currentUser = User(
        username: username,
        firstName: 'Иван',
        lastName: 'Иванов',
        middleName: 'Иванович',
        score: 42,
        scorePosition: 15,
        usersCount: 123,
        balance: 150,
      );
    } else {
      var authData = {'username': username, 'password': password};
      await _client.authenticate(authData);
      final userData = await _client.get('/profile/');
      currentUser = User(
        username: username,
        firstName: userData['first_name'],
        lastName: userData['last_name'],
        middleName: userData['middle_name'],
        score: userData['score'],
        scorePosition: userData['score_position'],
        usersCount: userData['users_count'],
        balance: userData['balance'],
      );
    }

    notifyListeners();
    return currentUser;
  }

  void logout() {
    currentUser = null;
    _client.logout();
  }
}
