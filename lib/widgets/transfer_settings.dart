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
            information = Text("File type unknown.");
          case AxeFileType.ir:
            information = Text("IR File Detected.");
            controls = IRSettings();
          case AxeFileType.preset:
            information = Text("Preset File Detected.");
            if (context.read<AxeLoaderViewModel>().sendReason.isNotEmpty) {
              information = Text("Preset File Detected.\n${context.read<AxeLoaderViewModel>().sendReason}");
            }
        }
      } else {
        information = Text("Select what to receive:");
        controls = GetterSettings();
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

class GetterSettings extends StatelessWidget {
  const GetterSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Preset Number to Get:"),
            InputQty(
              decoration: QtyDecorationProps(
                qtyStyle: QtyStyle.btnOnRight,
                btnColor: Colors.grey,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).hintColor),
                ),
              ),
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
        Row(
          children: [
            RadioGroup<CabLocation>(
              groupValue: context.watch<AxeLoaderViewModel>().cabLocation,
              onChanged: (CabLocation? value) {
                context.read<AxeLoaderViewModel>().cabLocation = value!;
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
            InputQty(),
          ],
        ),
      ],
    );
  }
}


