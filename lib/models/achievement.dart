import '../utils/base_model.dart';


class Achievement extends BaseModel {
  String name;
  String description;
  DateTime createdAt;
  DateTime assignedAt;

  Achievement({
    id,
    this.name,
    this.description,
    this.createdAt,
    this.assignedAt,
  }): super(id: id);
}
