import 'package:drawing/presentation/viewmodel/undo_redo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UndoButton extends ConsumerWidget {
  const UndoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final undoStory =
        ref.watch(undoRedoViewModelProvider.select((state) => state.undoStory));
    return IconButton(
      icon: const Icon(Icons.undo),
      onPressed: undoStory!.isNotEmpty
          ? () => ref.read(undoRedoViewModelProvider.notifier).undo()
          : null,
    );
  }
}
