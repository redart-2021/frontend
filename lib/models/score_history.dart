import '../utils/base_model.dart';


class ScoreHistory extends BaseModel {
  int score;
  DateTime createdAt;
  String comment;

  ScoreHistory({
    id,
    this.score,
    this.createdAt,
    this.comment,
  }): super(id: id);
}
