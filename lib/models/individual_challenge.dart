import '../utils/base_model.dart';
import 'quest.dart';


class IndividualChallenge extends BaseModel {
  String name;
  String description;
  String answer;
  DateTime startAt;
  DateTime finishAt;
  bool isPrivate;
  int creatorId;
  int questId;
  Quest quest;

  IndividualChallenge({
    id,
    this.name,
    this.description,
    this.answer,
    this.startAt,
    this.finishAt,
    this.isPrivate,
    this.creatorId,
    this.questId,
    this.quest,
  }): super(id: id);
}
