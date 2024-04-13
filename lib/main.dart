import 'package:drawing/presentation/widgets/grid_mode_button.dart';
import 'package:drawing/presentation/view/unro_redo_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/view/drawing_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
          backgroundColor: const Color(0xffE3E3E3),
          appBar: AppBar(
            title: const Text('Drawing'),
            actions: const [
              UndoRedoButtons(),
              GridModeToggleButton(),
            ],
          ),
          body: const DrawingView()),
    );
  }
}
