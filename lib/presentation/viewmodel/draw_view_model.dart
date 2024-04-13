import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'draw_state.dart';
import 'undo_redo_view_model.dart';

part 'draw_view_model.g.dart';

@riverpod
class DrawViewModel extends _$DrawViewModel {
  @override
  DrawState build() => DrawState(
      isEditMode: false,
      isGridMode: false,
      points: [],
      startPoint: Offset.zero,
      endPoint: Offset.zero);

  void updatePoints(List<Offset> points) {
    state = state.copyWith(points: points);
  }

  void onPanStart(DragStartDetails details) {
    if (!state.isEditMode) {
      if (state.points != null && state.points!.isNotEmpty) {
        state = state.copyWith(startPoint: state.points?.last);
      } else {
        if (state.isGridMode) {
          state =
              state.copyWith(startPoint: _alignToGrid(details.localPosition));
        } else {
          state = state.copyWith(startPoint: details.localPosition);
        }
      }
      _updateEndPoint(details.localPosition);
    } else {
      _updateSelected(details.localPosition);
    }
  }

  void onPanUpdate(DragUpdateDetails details) => !state.isEditMode
      ? _updateEndPoint(details.localPosition)
      : _updateSelected(details.localPosition);

  void _updateEndPoint(Offset offset) {
    if (state.isGridMode) {
      state = state.copyWith(endPoint: _alignToGrid(offset));
    } else {
      state = state.copyWith(endPoint: offset);
    }
  }

  void _updateSelected(Offset offset) {
    if (state.selectedPointIndex != null) {
      final updatedPoints = List.of(state.points!);
      updatedPoints[state.selectedPointIndex!] = offset;
      state = state.copyWith(points: updatedPoints);
      return;
    }
  }

  void onPanEnd(DragEndDetails details) {
    final points = state.points;
    if (!state.isEditMode) {
      final updatePoints = state.points;
      final startPoint = state.startPoint;
      final endPoint = state.endPoint;

      if (points!.isEmpty) {
        updatePoints!.add(startPoint);
      }
      if (points.length > 2) {
        final firstPoint = points.first;
        final lastPoint = points.last;

        final distance = math.sqrt(
          math.pow(firstPoint.dx - lastPoint.dx, 2) +
              math.pow(firstPoint.dy - lastPoint.dy, 2),
        );
        if (distance < 200.0 && points.contains(updatePoints!.last)) {
          updatePoints.add(endPoint);
          state = state.copyWith(isEditMode: true, points: updatePoints);

          return;
        }
      }

      if (!_doesLineIntersectWithExistingLines(
          startPoint, endPoint, updatePoints!)) {
        updatePoints.add(endPoint);
      }
      state = state.copyWith(points: updatePoints);
    }

    state = state.copyWith(
        startPoint: Offset.zero, endPoint: Offset.zero, selectedPointIndex: -1);
    ref.read(undoRedoViewModelProvider.notifier).addStory(state.points!);
  }

  void onTanDown(TapDownDetails details) {
    final points = state.points!;

    final offset = details.localPosition;

    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final distance = math.sqrt(math.pow(point.dx - offset.dx, 2) +
          math.pow(point.dy - offset.dy, 2));
      if (distance < 10.0) {
        state = state.copyWith(selectedPointIndex: i);
        break;
      }
    }
  }

  void onGridMode() {
    state = state.copyWith(isGridMode: !state.isGridMode);
    if (state.isEditMode) {
      final updatedPoints = state.points?.map((point) {
        return _alignToGrid(point);
      }).toList();
      state = state.copyWith(points: updatedPoints);
    }
  }

  Offset _alignToGrid(Offset point) {
    const double step = 50.0;
    final double x = (point.dx / step).round() * step;
    final double y = (point.dy / step).round() * step;
    return Offset(x, y);
  }

  bool _doLineSegmentsIntersect(Offset p1, Offset p2, Offset q1, Offset q2) {
    double ccw(Offset p0, Offset p1, Offset p2) =>
        (p2.dy - p0.dy) * (p1.dx - p0.dx) - (p1.dy - p0.dy) * (p2.dx - p0.dx);

    return ccw(q2, q1, p1) * ccw(q2, q1, p2) < 0 &&
        ccw(p2, p1, q1) * ccw(p2, p1, q2) < 0;
  }

  bool _doesLineIntersectWithExistingLines(
      Offset startPoint, Offset endPoint, List<Offset> existingPoints) {
    for (int i = 1; i < existingPoints.length; i++) {
      final existingStart = existingPoints[i - 1];
      final existingEnd = existingPoints[i];
      if (_doLineSegmentsIntersect(
          startPoint, endPoint, existingStart, existingEnd)) {
        return true;
      }
    }
    return false;
  }
}


