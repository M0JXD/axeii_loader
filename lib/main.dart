import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    minimumSize: Size(400, 400),
    maximumSize: Size(1920, 720),
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
  runApp(const AxeLoaderApp());
}

class AxeLoaderApp extends StatelessWidget {
  const AxeLoaderApp({super.key});

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
      title: "Axe FX II Loader",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Axe-FX II Loader"),
          actions: [Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SendReceiveActions(),
          )],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  ConnectionSettings(),
                  VerticalDivider(),
                  PresetSettings(),
                ],
              ),
              Divider(),
              IRSettings(),
              // SendReceiveTabs(),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum SendReceiveMode { send, receive }

class SendReceiveActions extends StatefulWidget {
  const SendReceiveActions({super.key});

  @override
  State<SendReceiveActions> createState() => _SendReceiveActionsState();
}

class _SendReceiveActionsState extends State<SendReceiveActions> {
  SendReceiveMode sendReceiveMode = SendReceiveMode.send;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: SegmentedButton<SendReceiveMode>(
        segments: [
          ButtonSegment<SendReceiveMode>(
            value: SendReceiveMode.send,
            label: Text("Send"),
            icon: Icon(Icons.send_rounded)
          ),
          ButtonSegment<SendReceiveMode>(
            value: SendReceiveMode.receive,
            label: Text("Receive"),
            icon: Icon(Icons.download_rounded)
          ),
        ],
        selected: <SendReceiveMode>{sendReceiveMode},
        onSelectionChanged: (Set<SendReceiveMode> newSelection) {
          setState(() {
            sendReceiveMode = newSelection.first;
          });
        },
        showSelectedIcon: true,
      ),
    );
  }
}

class ConnectionSettings extends StatelessWidget {
  const ConnectionSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Connection Settings:"),
        DropdownMenu(
          dropdownMenuEntries: [
            DropdownMenuEntry(value: 0, label: "Axe-FX II MK I/II"),
            DropdownMenuEntry(value: 1, label: "Axe-FX II XL"),
            DropdownMenuEntry(value: 2, label: "Axe-FX II XL+ "),
          ],
        ),
        DropdownMenu(
          dropdownMenuEntries: [
            DropdownMenuEntry(value: 0, label: "MIDI IN PORT1"),
            DropdownMenuEntry(value: 1, label: "MIDI IN PORT2"),
            DropdownMenuEntry(value: 2, label: "MIDI IN PORT3"),
          ],
        ),
        DropdownMenu(
          dropdownMenuEntries: [
            DropdownMenuEntry(value: 0, label: "MIDI OUT PORT1"),
            DropdownMenuEntry(value: 1, label: "MIDI OUT PORT2"),
            DropdownMenuEntry(value: 2, label: "MIDI OUT PORT3"),
          ],
        ),
      ],
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
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
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
