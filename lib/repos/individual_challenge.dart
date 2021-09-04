import '../models/individual_challenge.dart';
import '../models/quest.dart';
import '../utils/api_client.dart';
import '../utils/base_repository.dart';


class IndividualChallengeRepo extends BaseRestRepository<IndividualChallenge> {
  String get baseUrl => '/challenges/individual/';

  IndividualChallengeRepo({ HttpApiClient client }):
    super(client: client, resultKey: 'results');

  @override
  IndividualChallenge parseItemFromList(Map<String, dynamic> item) {
    final itemQuest = item['quest'];
    return IndividualChallenge(
      id: item['id'],
      name: item['name'],
      description: item['description'],
      startAt: item['start_at'] != null ? DateTime.parse(item['start_at']) : null,
      finishAt: item['finish_at'] != null ? DateTime.parse(item['assigned_at']) : null,
      isPrivate: item['is_private'],
      answer: item['answer'],
      creatorId: item['creator'],
      questId: item['quest_id'],
      quest: Quest(
        id: itemQuest['id'],
        name: itemQuest['name'],
        description: itemQuest['description'],
        reward: itemQuest['reward'],
        createdAt: DateTime.parse(itemQuest['created_at']),
        validFrom: itemQuest['valid_from'] != null ? DateTime.parse(itemQuest['valid_from']) : null,
        validTo: itemQuest['valid_from'] != null ? DateTime.parse(itemQuest['valid_to']) : null,
      ),
    );
  }

  @override
  IndividualChallenge fakeItemForList(int i) {
    final answers = [null, 'accepted', 'rejected'];

    return IndividualChallenge(
      id: i,
      name: 'Соревнование $i',
      description: 'описание соревнования $i',
      answer: answers[i % 3],
      startAt: DateTime.now(),
      finishAt: DateTime.now(),
      isPrivate: i % 2 == 1,
      creatorId: i,
      questId: i,
      quest: Quest(
        id: i,
        name: 'задание $i',
        description: 'описание задания $i',
        reward: i * 10,
        createdAt: DateTime.now(),
        validFrom: DateTime.now(),
        validTo: DateTime.now(),
      ),
    );
  }
}
