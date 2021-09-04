import '../models/quest.dart';
import '../utils/api_client.dart';
import '../utils/base_repository.dart';


class QuestRepo extends BaseRestRepository<Quest> {
  String get baseUrl => '/quests/';

  QuestRepo({ HttpApiClient client }):
    super(client: client, resultKey: 'results');

  @override
  Quest parseItemFromList(Map<String, dynamic> item) {
    return Quest(
      id: item['id'],
      name: item['name'],
      description: item['description'],
      reward: item['reward'],
      createdAt: DateTime.parse(item['created_at']),
      validFrom: item['valid_from'] != null ? DateTime.parse(item['valid_from']) : null,
      validTo: item['valid_from'] != null ? DateTime.parse(item['valid_to']) : null,
    );
  }

  @override
  Quest fakeItemForList(int i) {
    return Quest(
      id: i,
      name: 'задание $i',
      description: 'описание задания $i',
      reward: i * 10,
      createdAt: DateTime.now(),
      validFrom: DateTime.now(),
      validTo: DateTime.now(),
    );
  }
}
