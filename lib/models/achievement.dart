import '../utils/base_model.dart';


class Achievement extends BaseModel {
  String name;
  String description;
  DateTime createdAt;
  DateTime assignedAt;
  String image;

  Achievement({
    id,
    this.name,
    this.description,
    this.createdAt,
    this.assignedAt,
    this.image,
  }): super(id: id);
}
