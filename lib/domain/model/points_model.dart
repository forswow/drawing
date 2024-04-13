
import '../../presentation/viewmodel/draw_state.dart';

class PointsModel {
  final List<Points>? undoStory;
  final List<Points>? redoStory;
  PointsModel({
    this.undoStory,
    this.redoStory,
  });

  PointsModel copyWith({
    List<Points>? undoStory,
    List<Points>? redoStory,
  }) =>
      PointsModel(
        undoStory: undoStory ?? this.undoStory,
        redoStory: redoStory ?? this.redoStory,
      );
}
