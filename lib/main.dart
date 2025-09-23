import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'model/model.dart';
import 'widgets/axe_loader.dart';

void main() async {
  await setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AxeLoaderViewModel(),
      child: const AxeLoaderApp(),
    ),
  );
}

Future<void> setupWindow() async {
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(600, 380),
      minimumSize: Size(600, 380),
      maximumSize: Size(600, 380),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      windowButtonVisibility: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setResizable(false);
    });
  }
}
