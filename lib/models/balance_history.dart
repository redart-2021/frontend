import '../utils/base_model.dart';


class BalanceHistory extends BaseModel {
  int balanceId;
  int amount;
  int frozen;
  DateTime createdAt;
  String comment;

  BalanceHistory({
    id,
    this.balanceId,
    this.amount,
    this.frozen,
    this.createdAt,
    this.comment,
  }): super(id: id);
}
