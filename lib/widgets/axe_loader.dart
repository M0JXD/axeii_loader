import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:axeii_loader/widgets/transfer_settings.dart';
import '../model/model.dart';
import '../model/midi_controller.dart';

class AxeLoaderApp extends StatelessWidget {
  const AxeLoaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexThemeData.light(
        scheme: FlexScheme.greys,
        subThemesData: FlexSubThemesData(
          filledButtonRadius: 10,
          segmentedButtonRadius: 10,
        ),
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.greys,
        subThemesData: FlexSubThemesData(
          filledButtonRadius: 10,
          segmentedButtonRadius: 10,
        ),
      ),
      title: "Axe FX II Loader",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Axe-FX II Loader"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SendReceiveActions(),
            ),
          ],
        ),
        body: AxeLoaderBody(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AxeLoaderBody extends StatelessWidget {
  const AxeLoaderBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConnectionSettings(),
                VerticalDivider(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      LocationChooser(
                        locationType:
                            (context
                                    .watch<AxeLoaderViewModel>()
                                    .sendReceiveMode ==
                                SendReceiveMode.send)
                            ? "Select a file to send:"
                            : "Choose a location to save:",
                      ),
                      Divider(),
                      // Spacer(),
                      Expanded(child: Center(child: TransferSettings())),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          ActionProgress(),
        ],
      ),
    );
  }
}

class SendReceiveActions extends StatelessWidget {
  const SendReceiveActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: SegmentedButton<SendReceiveMode>(
        segments: [
          ButtonSegment<SendReceiveMode>(
            value: SendReceiveMode.send,
            label: Text("Send"),
            icon: Icon(Icons.send_rounded),
          ),
          ButtonSegment<SendReceiveMode>(
            value: SendReceiveMode.receive,
            label: Text("Receive"),
            icon: Icon(Icons.download_rounded),
          ),
        ],
        selected: <SendReceiveMode>{
          context.watch<AxeLoaderViewModel>().sendReceiveMode,
        },
        onSelectionChanged: (Set<SendReceiveMode> newSelection) {
          context.read<AxeLoaderViewModel>().sendReceiveMode =
              newSelection.first;
        },
      ),
    );
  }
}

class ConnectionSettings extends StatefulWidget {
  const ConnectionSettings({super.key});

  @override
  State<ConnectionSettings> createState() => _ConnectionSettingsState();
}

class _ConnectionSettingsState extends State<ConnectionSettings> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 185,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          const Text("Connection Settings:"),
          DropdownMenu(
            width: 185,
            hintText: "Model",
            dropdownMenuEntries: [
              DropdownMenuEntry(
                value: AxeFXType.original,
                label: "Axe-FX II OG/MkII",
              ),
              DropdownMenuEntry(value: AxeFXType.xl, label: "Axe-FX II XL"),
              DropdownMenuEntry(
                value: AxeFXType.xlPlus,
                label: "Axe-FX II XL+",
              ),
            ],
            onSelected: (value) {
              context.read<AxeLoaderViewModel>().axeFXType = value;
            },
            initialSelection: AxeFXType.original,
          ),
          FutureBuilder(
            future: MidiCommand().devices,
            builder: (context, asyncSnapshot) {
              return DropdownMenu(
                width: 185,
                hintText: "MIDI Device",
                dropdownMenuEntries:
                    List<DropdownMenuEntry<MidiDevice?>>.generate(
                      asyncSnapshot.data?.length ?? 0,
                      (int index) {
                        if (asyncSnapshot.hasData) {
                          return DropdownMenuEntry(
                            label: asyncSnapshot.data![index].name,
                            value: asyncSnapshot.data![index],
                          );
                        }
                        return DropdownMenuEntry(value: null, label: "");
                      },
                    ),
                onSelected: (value) {
                  if (value != null) {
                    context.read<AxeLoaderViewModel>().selectedDevice = value;
                  }
                },
                initialSelection: null,
              );
            },
          ),
          SizedBox(
            width: 185,
            child: FilledButton(
              onPressed: () {
                setState(() {
                  // TODO: The list reloads with new devices, but a previously connected device stays?
                  context.read<AxeLoaderViewModel>().selectedDevice = null;
                  // AxeController.devChecker();
                }); // Force to rebuild and get new device list
              },
              child: Text("Reload Device List"),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationChooser extends StatelessWidget {
  final String locationType;
  const LocationChooser({super.key, required this.locationType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locationType),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(
                  text: context.watch<AxeLoaderViewModel>().fileLocation,
                ),
                onSubmitted: (newLocation) {
                  context.read<AxeLoaderViewModel>().fileLocation = newLocation;
                },
                style: TextStyle(fontSize: 10),
                decoration: InputDecoration(
                  hintText: "Browse, or enter a path...",
                ),
              ),
            ),
            FilledButton(
              onPressed: () async {
                if (context.mounted) {
                  if (context.read<AxeLoaderViewModel>().sendReceiveMode ==
                      SendReceiveMode.send) {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                          allowedExtensions: ['syx'],
                          type: FileType.custom,
                          dialogTitle: "Choose file...",
                        );
                    if (result != null && context.mounted) {
                      File file = File(result.files.single.path!);
                      context.read<AxeLoaderViewModel>().fileLocation =
                          file.path;
                    }
                  } else {
                    String? selectedDirectory = await FilePicker.platform
                        .getDirectoryPath(dialogTitle: "Choose Directory...");
                    if (context.mounted && selectedDirectory != null) {
                      context.read<AxeLoaderViewModel>().fileLocation =
                          selectedDirectory;
                    }
                  }
                }
              },
              child: Text("Browse"),
            ),
          ],
        ),
      ],
    );
  }
}

class ActionProgress extends StatelessWidget {
  const ActionProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        FilledButton(
          onPressed: context.watch<AxeLoaderViewModel>().buttonDisable
              ? null
              : () async {
                  context.read<AxeLoaderViewModel>().beginTransfer();
                },
          child: Text("Begin"),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: context.watch<AxeLoaderViewModel>().transactionProgress,
          ),
        ),
      ],
    );
  }
}
