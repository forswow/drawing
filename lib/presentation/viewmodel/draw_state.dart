import 'package:flutter/material.dart';

typedef Points = List<Offset>;

class DrawState {
  final Points? points;
  final Offset startPoint;
  final Offset endPoint;
  final int? selectedPointIndex;
  final bool isEditMode;
  final bool isGridMode;
  DrawState({
    this.points,
    required this.startPoint,
    required this.endPoint,
    this.selectedPointIndex,
    required this.isEditMode,
    required this.isGridMode,
  });

  DrawState copyWith({
    Points? points,
    Offset? startPoint,
    Offset? endPoint,
    int? selectedPointIndex,
    bool? isEditMode,
    bool? isGridMode,
  }) => DrawState(
      points: points ?? this.points,
      startPoint: startPoint ?? this.startPoint,
      endPoint: endPoint ?? this.endPoint,
      selectedPointIndex: selectedPointIndex == -1
          ? null
          : selectedPointIndex ?? this.selectedPointIndex,
      isEditMode: isEditMode ?? this.isEditMode,
      isGridMode: isGridMode ?? this.isGridMode,
    );
}
