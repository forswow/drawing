import 'package:drawing/presentation/viewmodel/undo_redo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RedoButton extends ConsumerWidget {
  const RedoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final redoStory =
        ref.watch(undoRedoViewModelProvider.select((state) => state.redoStory));
    return IconButton(
      icon: const Icon(Icons.redo),
      onPressed: redoStory!.isNotEmpty
          ? () => ref.read(undoRedoViewModelProvider.notifier).redo()
          : null,
    );
  }
}
