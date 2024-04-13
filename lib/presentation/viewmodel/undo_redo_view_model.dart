import 'dart:ui';

import 'package:drawing/domain/model/points_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'draw_view_model.dart';

part 'undo_redo_view_model.g.dart';

@riverpod
class UndoRedoViewModel extends _$UndoRedoViewModel {
  @override
  PointsModel build() => PointsModel(undoStory: [], redoStory: []);

  void addStory(List<Offset> points) {
    state = state.copyWith(undoStory: [
      ...state.undoStory!,
      [...points]
    ], redoStory: []);
  }

  void undo() {
    if (state.undoStory!.isNotEmpty) {
      final lastStep = state.undoStory!.last;
      state = state.copyWith(
        undoStory: List.from(state.undoStory!)..removeLast(),
        redoStory: [...state.redoStory!, lastStep],
      );
      final pointsToSend =
          state.undoStory!.isEmpty ? <Offset>[] : state.undoStory!.last;

      ref.read(drawViewModelProvider.notifier).updatePoints(pointsToSend);
    }
  }

  void redo() {
    if (state.redoStory!.isNotEmpty) {
      final nextStep = state.redoStory!.last;
      state = state.copyWith(
        undoStory: [...state.undoStory!, nextStep],
        redoStory: List.from(state.redoStory!)..removeLast(),
      );
      ref
          .read(drawViewModelProvider.notifier)
          .updatePoints(state.undoStory!.last);
    }
  }
}
