import 'package:drawing/presentation/viewmodel/draw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridModeToggleButton extends ConsumerWidget {
  const GridModeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridMode =
        ref.watch(drawViewModelProvider.select((value) => value.isGridMode));

    return IconButton(
      icon: Icon(gridMode ? Icons.grid_on : Icons.grid_off),
      onPressed: ref.read(drawViewModelProvider.notifier).onGridMode,
    );
  }
}
