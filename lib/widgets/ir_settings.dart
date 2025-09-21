import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:axeii_loader/model/model.dart';

class IRSettings extends StatelessWidget {
  const IRSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("IR Settings:"),
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
      ],
    );
  }
}

class SendIRSettings extends StatelessWidget {
  const SendIRSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class GetIRSettings extends StatelessWidget {
  const GetIRSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}