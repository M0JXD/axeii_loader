// Contains utility functions for MIDI actions on the Axe-FX II

import 'dart:io';

import 'package:axeii_loader/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:provider/provider.dart';

Future<AxeFileType?> typeDetector(String pathToFile) async {
  AxeFileType? type;
  var file = File(pathToFile);
  var fileAsBytes = await file.readAsBytes();
  // A preset file's 6th byte should be 0x77
  if (fileAsBytes[5] == 0x77) {
    type = AxeFileType.preset;
  }
  // An IR file's 6th byte should be 0x7A
  if (fileAsBytes[5] == 0x7A) {
    type = AxeFileType.ir;
  }
  return type;
}

class AxeController {
  MidiCommand _midiDevice;
  BuildContext context;

  AxeController(this._midiDevice, this.context);

  void changePreset(int presetNumber) {}

  void uploadPreset(String pathToPreset) async {
    context.read<AxeLoaderModel>().transactionProgress = 0;
    if (context.mounted) {
      for (
        ;
        context.read<AxeLoaderModel>().transactionProgress <= 1;
        context.read<AxeLoaderModel>().transactionProgress += 0.01
      ) {
        await Future.delayed(Durations.short2);
      }
    }
  }

  void downloadPreset(String pathToSave) {}

  void uploadCab(String pathToCab, int location, bool scratchpad) {}

  void downloadCab(String pathToSave, int location) {}
}

// AxeController axeConnection = AxeController();
