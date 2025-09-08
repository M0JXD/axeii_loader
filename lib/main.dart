import 'package:flutter/material.dart';
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
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
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

enum CabinetLocation { userLocation, scratchpadLocation }

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
            SizedBox(
              width: 300,
              height: 100,
              child: RadioGroup(
                onChanged: (value) {},
                child: Column(
                  children: [
                    RadioListTile<CabinetLocation>(
                      value: CabinetLocation.userLocation,
                      title: Text("User Location"),
                    ),
                    RadioListTile<CabinetLocation>(
                      value: CabinetLocation.userLocation,
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
      child: SizedBox(
        height: 200,
        width: 580,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabBar(
              tabs: [
                Tab(child: Text("Send")),
                Tab(child: Text("Receive")),
              ],
            ),
            SizedBox(
              height: 150,
              child: TabBarView(
                children: [
                  Card(
                    child: Column(
                      children: [
                        Text("Send files to your Axe-FX II"),
                        TextField(),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Send to Axe-FX II'),
                        ),
                      ],
                    ),
                  ),
                  Card(                    child: Column(
                      children: [
                        Text("Get files from your Axe-FX II"),
                        TextField(),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Get from Axe-FX II'),
                        ),
                      ],
                    ),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
