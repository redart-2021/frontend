import '../utils/base_model.dart';


class CompletedQuest extends BaseModel {
  String name;
  String description;
  int reward;
  DateTime createdAt;
  DateTime validFrom;
  DateTime validTo;
  int coins;
  DateTime completedAt;

  CompletedQuest({
    id,
    this.name,
    this.description,
    this.reward,
    this.createdAt,
    this.validFrom,
    this.validTo,
    this.coins,
    this.completedAt,
  }): super(id: id);
}
