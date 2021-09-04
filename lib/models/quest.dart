import '../utils/base_model.dart';


class Quest extends BaseModel {
  String name;
  String description;
  int reward;
  DateTime createdAt;
  DateTime validFrom;
  DateTime validTo;

  Quest({
    id,
    this.name,
    this.description,
    this.reward,
    this.createdAt,
    this.validFrom,
    this.validTo,
  }): super(id: id);
}
