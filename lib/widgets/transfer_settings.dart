import 'package:axeii_loader/widgets/ir_settings.dart';
import 'package:axeii_loader/widgets/preset_settings.dart';
import 'package:flutter/material.dart';
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
      type = context.watch<AxeLoaderViewModel>().fileType;
      switch (type) {
        case null:
          information = Text("File type unknown.");
        case AxeFileType.ir:
          information = Text("IR File Detected.");
          controls = IRSettings();
        case AxeFileType.preset:
          information = Text("Preset File Detected.");
          if (context.read<AxeLoaderViewModel>().sendReason.isNotEmpty) {
            controls = Text(context.watch<AxeLoaderViewModel>().sendReason);
          } else if (mode == SendReceiveMode.receive) {
            controls = GetPresetSettings();
          }
      }
    } else {
      if (mode == SendReceiveMode.send) {
        information = Text("Select a file.");
      } else {
        information = Text("Choose a location.");
      }
    }
    return controls == null
        ? Center(child: information)
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: information),
              controls,
            ],
          );
  }
}
