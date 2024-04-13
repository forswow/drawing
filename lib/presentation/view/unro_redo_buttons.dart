import 'package:drawing/presentation/widgets/redo_button.dart';
import 'package:drawing/presentation/widgets/undo_button.dart';
import 'package:flutter/material.dart';

class UndoRedoButtons extends StatelessWidget {
  const UndoRedoButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        UndoButton(),
        RedoButton(),
      ],
    );
  }
}
