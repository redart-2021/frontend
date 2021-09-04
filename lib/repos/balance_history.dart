import '../models/balance_history.dart';
import '../utils/api_client.dart';
import '../utils/base_repository.dart';


class BalanceHistoryRepo extends BaseRestRepository<BalanceHistory> {
  String get baseUrl => '/balance/';

  BalanceHistoryRepo({ HttpApiClient client }):
    super(client: client, resultKey: 'results');

  @override
  BalanceHistory parseItemFromList(Map<String, dynamic> item) {
    return BalanceHistory(
      id: item['id'],
      balanceId: item['balance'],
      amount: item['amount'],
      frozen: item['frozen'],
      createdAt: DateTime.parse(item['created_at']),
      comment: item['comment'],
    );
  }

  @override
  BalanceHistory fakeItemForList(int i) {
    return BalanceHistory(
      id: i,
      balanceId: i,
      amount: i,
      frozen: -i,
      createdAt: DateTime.now(),
      comment: '',
    );
  }
}
