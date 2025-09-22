import 'package:axeii_loader/model/midi_controller.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:provider/provider.dart';
import 'package:axeii_loader/model/model.dart';

class TransferSettings extends StatelessWidget {
  const TransferSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Widget information;
    Widget? controls;
    AxeFileType? type;
    var mode = context.watch<AxeLoaderViewModel>().sendReceiveMode;
    if (context.watch<AxeLoaderViewModel>().fileLocation != null) {
      if (mode == SendReceiveMode.send) {
        type = context.watch<AxeLoaderViewModel>().fileType;
        switch (type) {
          case null:
            information = const Text("File type unknown.");
          case AxeFileType.ir:
            information = const Text("IR File Detected. Choose where to send to:");
            controls = const IRSettings();
          case AxeFileType.preset:
            information = const Text("Preset File Detected.");
            if (context.read<AxeLoaderViewModel>().sendReason.isNotEmpty) {
              information = Text(
                "Preset File Detected.\n${context.read<AxeLoaderViewModel>().sendReason}",
              );
            }
        }
      } else {
        information = const Text("Choose type and location to receive:");
        controls = const GetterSettings();
      }
    } else {
      if (mode == SendReceiveMode.send) {
        information = const Text("Select a file.");
      } else {
        information = const Text("Choose a file directory.");
      }
    }
    return controls == null
        ? Center(child: information)
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Center(child: information),
              controls,
            ],
          );
  }
}

class GetterSettings extends StatefulWidget {
  const GetterSettings({super.key});

  @override
  State<GetterSettings> createState() => _GetterSettingsState();
}

class _GetterSettingsState extends State<GetterSettings> {
  AxeFileType fileType = AxeFileType.preset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 10,
        children: [
          RadioGroup<AxeFileType>(
            groupValue: fileType,
            onChanged: (AxeFileType? value) {
              setState(() {
                fileType = value!;
                context.read<AxeLoaderViewModel>().receivePlace = value;
              });
            },
            child: const SizedBox(
              width: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RadioListTile<AxeFileType>(
                    value: AxeFileType.preset,
                    title: Text("Preset"),
                    toggleable: false,
                  ),
                  RadioListTile<AxeFileType>(
                    value: AxeFileType.ir,
                    title: Text("Cabinet"),
                    toggleable: false,
                  ),
                ],
              ),
            ),
          ),
          InputQty.int(
            decoration: QtyDecorationProps(
              qtyStyle: QtyStyle.btnOnRight,
              btnColor: Theme.of(context).primaryColorDark,
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColorLight,
                  width: 0.5,
                ),
              ),
            ),
            maxVal: fileType == AxeFileType.preset
                ? context.watch<AxeLoaderViewModel>().axeFXType ==
                          AxeFXType.original
                      ? 383
                      : 768
                : context.watch<AxeLoaderViewModel>().axeFXType ==
                      AxeFXType.original
                ? 100
                : 500,
            minVal: fileType == AxeFileType.preset ? 0 : 1,
            onQtyChanged: (value) {
              context.read<AxeLoaderViewModel>().number = value;
            },
          ),
        ],
      ),
    );
  }
}

enum CabLocation { user, scratchpad }

class IRSettings extends StatefulWidget {
  const IRSettings({super.key});

  @override
  State<IRSettings> createState() => _IRSettingsState();
}

class _IRSettingsState extends State<IRSettings> {
  CabLocation cabLocation = CabLocation.user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 10,
        children: [
          RadioGroup<CabLocation>(
            groupValue: cabLocation,
            onChanged: (CabLocation? value) {
              setState(() => cabLocation = value!);
            },
            child: const SizedBox(
              width: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
          InputQty.int(
            decoration: QtyDecorationProps(
              qtyStyle: QtyStyle.btnOnRight,
              btnColor: Theme.of(context).primaryColorDark,
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColorLight,
                  width: 0.5,
                ),
              ),
            ),
            initVal: 1,
            maxVal: cabLocation == CabLocation.user
                ? context.watch<AxeLoaderViewModel>().axeFXType ==
                          AxeFXType.original
                      ? 100
                      : 500
                : 4,
            minVal: 1,
            onQtyChanged: (value) {
              if (cabLocation == CabLocation.scratchpad) {
                // TODO: This likely needs changed for handling XL units
                context.read<AxeLoaderViewModel>().number = (value + 100);
              } else {
                context.read<AxeLoaderViewModel>().number = value;
              }
            },
          ),
        ],
      ),
    );
  }
}
