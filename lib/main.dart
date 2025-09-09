import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
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
    return MaterialApp(
      theme: FlexThemeData.light(
        scheme: FlexScheme.shadZinc,
        subThemesData: FlexSubThemesData(filledButtonRadius: 10),
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.shadZinc,
        subThemesData: FlexSubThemesData(filledButtonRadius: 10),
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Connection Settings (Device type, MIDI Ports...)"),
              PresetSettings(),
              IRSettings(),
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
            SizedBox(width: 85, height: 40, child: TextField()),
            Column(
              spacing: 2,
              children: [
                FilledButton(
                  child: Icon(Icons.arrow_upward_rounded),
                  onPressed: () {},
                ),
                FilledButton(
                  child: Icon(Icons.arrow_downward_rounded),
                  onPressed: () {},
                ),
              ],
            ),
            FilledButton(onPressed: () {}, child: Text("Change Preset")),
          ],
        ),
      ],
    );
  }
}

class IRSettings extends StatefulWidget {
  const IRSettings({super.key});

  @override
  State<IRSettings> createState() => _IRSettingsState();
}

class _IRSettingsState extends State<IRSettings> {
  int? _cabLocation; // Enum refused to work?

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("IR Settings, User Location # or Scratchpad"),
        Row(
          children: [
            RadioGroup<int>(
              groupValue: _cabLocation,
              onChanged: (int? value) {
                setState(() {
                  _cabLocation = value;
                });
              },
              child: SizedBox(
                width: 300,
                height: 96,
                child: const Column(
                  children: <Widget>[
                    RadioListTile<int>(value: 0, title: Text("User Location")),
                    RadioListTile<int>(
                      value: 1,
                      title: Text("Scratchpad Location"),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                FilledButton(onPressed: () {}, child: Text("UserLoc")),
                FilledButton(onPressed: () {}, child: Text("ScratchLoc")),
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
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabBar(
            tabs: [
              Tab(child: Text("Send Mode")),
              Tab(child: Text("Receive Mode")),
            ],
          ),
          SizedBox(
            height: 308,
            child: TabBarView(
              children: [
                Card(
                  child: Column(
                    children: [
                      Text("Send files to your Axe-FX II"),
                      TextField(),
                      FilledButton(
                        onPressed: () {},
                        child: Text('Send to Axe-FX II'),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Text("Get files from your Axe-FX II"),
                      TextField(),
                      FilledButton(
                        onPressed: () {},
                        child: Text('Get from Axe-FX II'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
