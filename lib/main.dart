import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(600, 400),
    minimumSize: Size(600, 400),
    maximumSize: Size(600, 400),
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Connection Settings (Device type, MIDI Ports...)"),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  
                  Text("Preset Chooser"),
                  
                  SizedBox(width: 85, height: 40, child: ShadInput()),
                  Column(
                    spacing: 2,
                    children: [
                      ShadButton(height: 30, child: Icon(LucideIcons.arrowUp)),
                      ShadButton(
                        height: 30,
                        child: Icon(LucideIcons.arrowDown),
                      ),
                    ],
                  ),
                  ShadButton(child: Text("Change Preset")),
                ],
              ),
              Text("IR Settings, User Location # or Scratchpad"),
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
      tabs: [
        ShadTab(
          value: 'send',
          content: ShadCard(
            description: const Text("Send files to your Axe-FX II"),
            footer: const ShadButton(child: Text('Send to Axe-FX II')),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  label: const Text('Where to Save and What to get'),
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
