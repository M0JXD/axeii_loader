import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(600, 400),
    minimumSize: Size(600, 600),
    maximumSize: Size(600, 600),
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
        colorScheme: ShadZincColorScheme.light(),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: ShadZincColorScheme.dark(),
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
              PresetSettings(),

              IRSettings(),
              SizedBox(height: 10),
              SendReceiveTabs(),
            ],
          ),
        ),
      ),
    );
  }
}

class PresetSettings extends StatelessWidget {
  const PresetSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Preset Chooser"),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            SizedBox(width: 85, height: 40, child: ShadInput()),
            Column(
              spacing: 2,
              children: [
                ShadButton(height: 30, child: Icon(LucideIcons.arrowUp)),
                ShadButton(height: 30, child: Icon(LucideIcons.arrowDown)),
              ],
            ),
            ShadButton(child: Text("Change Preset")),
          ],
        ),
      ],
    );
  }
}

class IRSettings extends StatelessWidget {
  const IRSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("IR Settings, User Location # or Scratchpad"),
        Row(
          children: [
            ShadRadioGroup<String>(
              items: [
                ShadRadio(label: Text('User Location'), value: 'user'),
                ShadRadio(
                  label: Text('Scratchpad Location'),
                  value: 'scratchpad',
                ),
              ],
            ),
            Column(
              children: [
                ShadButton.secondary(child: Text("UserLoc")),
                ShadButton.secondary(child: Text("ScratchLoc")),
              ],
            ),
          ],
        ),
      ],
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
            footer: const ShadButton(enabled: false,child: Text('Send to Axe-FX II'),),
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
