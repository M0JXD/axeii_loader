import 'package:axeii_loader/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:provider/provider.dart';

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
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConnectionSettings(),
              SizedBox(height: 220, child: VerticalDivider()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    SelectorArea(),
                    Divider(),
                    LocationChooser(locationType: "Location"),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          Expanded(child: SizedBox()),
          ActionProgress(),
          // SendReceiveTabs(),
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
          context.watch<AxeLoaderModel>().sendReceiveMode,
        },
        onSelectionChanged: (Set<SendReceiveMode> newSelection) {
          context.read<AxeLoaderModel>().changeSendReceiveMode(
            newSelection.first,
          );
        },
      ),
    );
  }
}

class ConnectionSettings extends StatelessWidget {
  const ConnectionSettings({super.key});

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<String>> midiInPorts = [];
    List<DropdownMenuEntry<String>> midiOutPorts = [];

    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          const Text("Connection Settings:"),
          DropdownMenu(
            width: 180,
            hintText: "Model",
            dropdownMenuEntries: [
              DropdownMenuEntry(
                value: AxeFXType.original,
                label: "Axe-FX II MK I/II",
              ),
              DropdownMenuEntry(value: AxeFXType.xl, label: "Axe-FX II XL"),
              DropdownMenuEntry(
                value: AxeFXType.xlPlus,
                label: "Axe-FX II XL+ ",
              ),
            ],
            onSelected: (value) {
              context.read<AxeLoaderModel>().changeUnitType(value!);
            },
          ),
          DropdownMenu(
            width: 180,
            hintText: "MIDI Input Port",
            dropdownMenuEntries: midiInPorts,
          ),
          DropdownMenu(
            width: 180,
            hintText: "MIDI Output Port",
            dropdownMenuEntries: midiOutPorts,
          ),
        ],
      ),
    );
  }
}

class SelectorArea extends StatelessWidget {
  const SelectorArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        PresetSettings(),
        SizedBox(height: 110, child: VerticalDivider()),
        IRSettings(),
      ],
    );
  }
}

class PresetSettings extends StatelessWidget {
  const PresetSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Preset Selector:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                SizedBox(width: 40, child: TextField()),
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
              ],
            ),
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
        Text("IR Settings:"),
        RadioGroup<CabLocation>(
          groupValue: context.watch<AxeLoaderModel>().cabLocation,
          onChanged: (CabLocation? value) {
            context.read<AxeLoaderModel>().changeCabLocation(value!);
          },
          child: SizedBox(
            width: 170,
            child: const Column(
              children: <Widget>[
                RadioListTile<CabLocation>(
                  value: CabLocation.user,
                  title: Text("User"),
                ),
                RadioListTile<CabLocation>(
                  value: CabLocation.scratchpad,
                  title: Text("Scratchpad"),
                ),
              ],
            ),
          ),
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
          onPressed: () {
            var axeType = context.read<AxeLoaderModel>().axeFXType;
            var mode = context.read<AxeLoaderModel>().sendReceiveMode;

            MidiCommand midiCommand = MidiCommand();

            // midiCommand.connectToDevice();
          },
          child: Text("Begin"),
        ),
        Expanded(child: LinearProgressIndicator(value: 0.0)),
      ],
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
            Expanded(child: TextField()),
            FilledButton(onPressed: () {}, child: Text("Browse")),
          ],
        ),
      ],
    );
  }
}
