import '../models/score_history.dart';
import '../utils/api_client.dart';
import '../utils/base_repository.dart';


class ScoreHistoryRepo extends BaseRestRepository<ScoreHistory> {
  String get baseUrl => '/score/';

  ScoreHistoryRepo({ HttpApiClient client }):
    super(client: client, resultKey: 'results');

  @override
  ScoreHistory parseItemFromList(Map<String, dynamic> item) {
    return ScoreHistory(
      id: item['id'],
      score: item['score'],
      createdAt: DateTime.parse(item['created_at']),
      comment: item['comment'],
    );
  }

  @override
  ScoreHistory fakeItemForList(int i) {
    return ScoreHistory(
      id: i,
      score: i,
      createdAt: DateTime.now(),
      comment: '',
    );
  }
}
