import 'package:drawing/presentation/view/painter/painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/draw_view_model.dart';

class DrawingView extends ConsumerWidget {
  const DrawingView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawPod = ref.read(drawViewModelProvider.notifier);
    final points =
        ref.watch(drawViewModelProvider.select((state) => state.points));
    final startPoint =
        ref.watch(drawViewModelProvider.select((state) => state.startPoint));
    final endPoint =
        ref.watch(drawViewModelProvider.select((state) => state.endPoint));
    final isEditMode =
        ref.watch(drawViewModelProvider.select((state) => state.isEditMode));
    final isGridEnabled =
        ref.watch(drawViewModelProvider.select((state) => state.isGridMode));
    return SafeArea(
      child: SizedBox.expand(
        child: GestureDetector(
          onTapDown:
              isEditMode && points!.length >= 3 ? drawPod.onTanDown : null,
          onPanStart: drawPod.onPanStart,
          onPanUpdate: drawPod.onPanUpdate,
          onPanEnd: drawPod.onPanEnd,
          child: CustomPaint(
            foregroundPainter: CustomTextPainter(points: points!),
            painter: DrawingPainter(
                startPoint: startPoint,
                endPoint: endPoint,
                points,
                isEditMode,
                isGridEnabled: isGridEnabled),
          ),
        ),
      ),
    );
  }
}