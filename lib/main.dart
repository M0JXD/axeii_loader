import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(600, 400),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: ShadStoneColorScheme.light(),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: ShadStoneColorScheme.dark(),
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  Text("Preset Chooser"),
                  SizedBox(width: 10),
                  SizedBox(width: 100, child: ShadInput()),
                ],
              ),
              SizedBox(height: 10),
              SendReceiveTabs(),
            ],
          ),
        ),
      ),
    );
  }
}

class SendReceiveTabs extends StatelessWidget {
  const SendReceiveTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTabs<String>(
      value: 'send',
      tabBarConstraints: const BoxConstraints(maxWidth: 400),
      contentConstraints: const BoxConstraints(maxWidth: 400),
      tabs: [
        ShadTab(
          value: 'send',
          content: ShadCard(
            description: const Text("Send files to your Axe-FX II"),
            footer: const ShadButton(child: Text('Send to Axe-FX II')),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                ShadInputFormField(
                  label: const Text('File to Send'),
                  initialValue: 'MyAwesomePreset.syx',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          child: const Text('Send Mode'),
        ),
        ShadTab(
          value: 'receive',
          content: ShadCard(
            description: const Text("Get presets and IR's from your Axe-FX II"),
            footer: const ShadButton(child: Text('Get from Axe-FX II')),
            child: Column(
              children: [
                const SizedBox(height: 16),
                ShadInputFormField(
                  label: const Text('Where to Save'),
                  initialValue: '~/AxeFxII',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          child: const Text('Receive Mode'),
        ),
      ],
    );
  }
}
