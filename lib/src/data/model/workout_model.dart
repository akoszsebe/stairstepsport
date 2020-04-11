import 'package:floor/floor.dart';

@entity
class WorkOut {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final int steps;
  final double cal;
  final int duration;
  final int when;

  WorkOut(this.id, this.steps, this.cal, this.duration, this.when);
}