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
  AxeFXType fileUnit;
  String location;
  int number;

  AxeController({
    required this.device,
    required this.location,
    required this.fileUnit,
    required this.number,
    this.axeFXType = AxeFXType.original,
  });

  //----- Methods -----//
  Uint8List recalcSysex(Uint8List sysex) {
    int checksumByte = 0xF0;
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

    // Add checksum and sysex end byte
    for (int i = 1; i < (sysex.length - 2); i++) {
      checksumByte ^= sysex[i];
    }
    checksumByte &= 0x7F;
    sysex[sysex.length - 2] = checksumByte;
    sysex[sysex.length - 1] = 0xF7;
    return sysex;
  }

  Stream<double> uploadPreset() async* {
    final dataPackets = axeFXType == AxeFXType.original ? 32 : 64;
    var fileToSend = (await File(location).readAsBytes());
    final fileBytes = fileToSend.length;
    await MidiCommand().connectToDevice(device);

    Uint8List startSysex = fileToSend.sublist(0, 12);
    startSysex = recalcSysex(startSysex);
    MidiCommand().sendData(startSysex);
    yield (1.0 / dataPackets + 2);
    await Future.delayed(const Duration(milliseconds: 5));

    for (var i = 0; i < dataPackets; i++) {
      Uint8List sysexToSend = fileToSend.sublist(
        12 + (202 * i),
        12 + (202 * (i + 1)),
      );
      sysexToSend = recalcSysex(sysexToSend);
      MidiCommand().sendData(sysexToSend);
      yield (i + 1) / (dataPackets + 2);
      await Future.delayed(const Duration(milliseconds: 5));
    }

    Uint8List endSysex = fileToSend.sublist(fileBytes - 11);
    endSysex = recalcSysex(endSysex);
    MidiCommand().sendData(endSysex);

    yield 1.0;
    MidiCommand().disconnectDevice(device);
  }

  Stream<double> downloadPreset() async* {
    Uint8List fileData = Uint8List(12951);
    MidiCommand().connectToDevice(device);

    var i = 0;
    await for (final value in MidiCommand().onMidiDataReceived!) {
      // Check that this is the end of the file...
      fileData.replaceRange(i, value.data.length, value.data);
      if (i % 100 == 0) {
        yield 1.0 / 66 * i;
      }
      i++;
    }
    yield 1;
    MidiCommand().disconnectDevice(device);

    var file = File(location);
    file.create();
  }

  Stream<double> uploadCab() async* {
    var fileToSend = (await File(location).readAsBytes());
    var fileBytes = fileToSend.length;
    final dataStartAdd = fileUnit == AxeFXType.original ? 11 : 12;
    await MidiCommand().connectToDevice(device);

    Uint8List startSysex = fileToSend.sublist(0, 12);
    startSysex = recalcSysex(startSysex);
    MidiCommand().sendData(startSysex);
    yield (1.0 / 64 + 2);
    await Future.delayed(const Duration(milliseconds: 5));

    for (var i = 0; i < 64; i++) {
      Uint8List sysexToSend = fileToSend.sublist(
        dataStartAdd + (170 * i),
        dataStartAdd + (170 * (i + 1)),
      );
      sysexToSend = recalcSysex(sysexToSend);
      MidiCommand().sendData(sysexToSend);
      yield (i + 1) / (64 + 2);
      await Future.delayed(const Duration(milliseconds: 5));
    }

    Uint8List endSysex = fileToSend.sublist(fileBytes - 13);
    endSysex = recalcSysex(endSysex);
    MidiCommand().sendData(endSysex);
    yield 1.0;

    MidiCommand().disconnectDevice(device);
  }

  Stream<double> downloadCab() async* {}

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
        print(i.name);
      }
    }
  }
}
