import '../models/achievement.dart';
import '../utils/api_client.dart';
import '../utils/base_repository.dart';


class AchievementRepo extends BaseRestRepository<Achievement> {
  String get baseUrl => '/achievements/';

  AchievementRepo({ HttpApiClient client }):
    super(client: client, resultKey: 'results');

  @override
  Achievement parseItemFromList(Map<String, dynamic> item) {
    return Achievement(
      id: item['id'],
      name: item['name'],
      description: item['description'],
      createdAt: DateTime.parse(item['created_at']),
      assignedAt: item['assigned_at'] != null ? DateTime.parse(item['assigned_at']) : null,
    );
  }

  @override
  Achievement fakeItemForList(int i) {
    return Achievement(
      id: i,
      name: 'ачивка $i',
      description: 'описание ачивки $i',
      createdAt: DateTime.now(),
      assignedAt: i % 2 == 1 ? DateTime.now() : null,
    );
  }
}
