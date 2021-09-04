import '../models/completed_quest.dart';
import '../utils/api_client.dart';
import '../utils/base_repository.dart';


class CompletedQuestRepo extends BaseRestRepository<CompletedQuest> {
  String get baseUrl => '/quests/completed/';

  CompletedQuestRepo({ HttpApiClient client }):
    super(client: client, resultKey: 'results');

  @override
  CompletedQuest parseItemFromList(Map<String, dynamic> item) {
    return CompletedQuest(
      id: item['id'],
      name: item['name'],
      description: item['description'],
      reward: item['reward'],
      createdAt: DateTime.parse(item['created_at']),
      validFrom: item['valid_from'] != null ? DateTime.parse(item['valid_from']) : null,
      validTo: item['valid_from'] != null ? DateTime.parse(item['valid_to']) : null,
      coins: item['coins'],
      completedAt: item['completed_at'] != null ? DateTime.parse(item['completed_at']) : null,
    );
  }

  @override
  CompletedQuest fakeItemForList(int i) {
    return CompletedQuest(
      id: i,
      name: 'задание $i',
      description: 'описание задания $i',
      reward: i * 10,
      createdAt: DateTime.now(),
      validFrom: DateTime.now(),
      validTo: DateTime.now(),
      coins: i * 10,
      completedAt: DateTime.now(),
    );
  }
}
