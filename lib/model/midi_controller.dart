// Contains utility functions for MIDI actions on the Axe-FX II
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

enum AxeFXType { original, xl, xlPlus }

class AxeController {
  static List<int> currentSysex = [];
  MidiDevice device;
  AxeFXType axeFXType;
  AxeController({required this.device, this.axeFXType = AxeFXType.original});

  //----- Methods -----//
  recalcSysex(Uint8List sysex) {
    int checksumByte = 0xF0;
    int len = sysex.length;
    switch (axeFXType) {
        case AxeFXType.xl:
            sysex[4] = 0x06;
        break;

        case AxeFXType.xlPlus:
            sysex[4] = 0x07;
        break;

        default:
            sysex[4] = 0x03;
        break;
    }

    /* Add checksum and sysex end byte */
    /* NB: gcc O2 optimisations ruin this calculation */
    for (int i = 1; i < (len - 2); i++) {
        checksumByte ^= sysex[i];
    }
    checksumByte &= 0x7F;
    sysex[len - 2] = checksumByte;
    sysex[len - 1] = 0xF7;
    
  }

  AxeFXType fileUnitType(String fileName) {
    return AxeFXType.original;
  }

  Stream<double> uploadPreset(String pathToPreset) async* {
    var fileToSend = await File(pathToPreset).readAsBytes();
    MidiCommand().connectToDevice(device);

    // TODO: Try breaking the file down to each sysex, then send...

    yield 0.1;
    MidiCommand().sendData(fileToSend);
    MidiCommand().disconnectDevice(device);

  }

  Stream<double> downloadPreset(String pathToSave) async* {
    Uint8List fileData = Uint8List(0);
    MidiCommand().connectToDevice(device);
    await for (final value in MidiCommand().onMidiDataReceived!) {
      fileData.addAll(value.data);
      // Check that this is the end of the file...
    }
    MidiCommand().disconnectDevice(device);

    var file = File(pathToSave);
    file.create();
  }

  Stream<double> uploadCab(String pathToCab, int location) async* {}

  Stream<double> downloadCab(String pathToSave, int location) async* {}

  //----- Utility -----//

  static void devChecker() async {
    print("Checking MIDI devices...");
    var devices = await MidiCommand().devices;
    if (devices == null) {
      print("Was null :(");
    } else if (devices.isEmpty) {
      print("Length was zero");
    } else {
      for (var i in devices) {
        print(i.id);
      }
    }
  }
}
