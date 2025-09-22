// Contains utility functions for MIDI actions on the Axe-FX II
// ignore_for_file: avoid_print

import 'dart:io';
import 'package:axeii_loader/model/model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

enum AxeFXType { original, xl, xlPlus }

class AxeController {
  static List<int> currentSysex = [];
  MidiDevice device;
  AxeFXType axeFXType;
  AxeFXType? fileUnit;
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

  Uint8List calcReqCommand(AxeFileType type, Uint8List command) {
    /* HEADER BYTES */
    command[0] = 0xF0;
    command[1] = 0x00;
    command[2] = 0x01;
    command[3] = 0x74;

    /* TODO: How does all this work for XL/XL+? */
    if (type == AxeFileType.ir) {
        command[5] = 0x7A;  /* IR Dump Req ID */
        command[6] = number - 1;
        command[7] = 0x0;
        command[8] = 0x10;
    } else if (type == AxeFileType.preset) {
        command[5] = 0x03;  /* Patch Dump Req ID */

        /* Banks and preset number */
        if (number < 128) {
            command[6] = 0x00;
            command[7] = number;
        } else if (number < 256) {
            command[6] = 0x01;
            command[7] = number - 128;
        } else if (number < 384) {
            command[6] = 0x02;
            command[7] = number - 256;
        }
    }
    return recalcSysex(command);
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
    Uint8List fileData = Uint8List(15000);

    Uint8List reqCommand = Uint8List(10);
    reqCommand = calcReqCommand(AxeFileType.preset, reqCommand);

    await MidiCommand().connectToDevice(device);
    MidiCommand().sendData(reqCommand);
    await Future.delayed(const Duration(milliseconds: 5));

    var i = 0;
    var sub = MidiCommand().onMidiDataReceived?.listen((val) {
      print("Does the listen method work?");
    });

    sub?.resume();
    // await for (final value in MidiCommand().onMidiDataReceived!) {
    //   // Check that this is the end of the file...
    //   print("We are getting events right?");
    //   fileData.replaceRange(i, value.data.length, value.data);
    //   i += value.data.length;
    //   yield (1.0 / 6487) * i;
    //   if (i >= 6487) {
    //     break;
    //   }
    // }
    yield 1;
    MidiCommand().disconnectDevice(device);

    List<int> realBytes = fileData.sublist(0, 6487);

    var file = File("$location/preset.syx");
    file = await file.create();
    file = await file.writeAsBytes(realBytes);
  }

  Stream<double> uploadCab() async* {
    var fileToSend = (await File(location).readAsBytes());
    final dataStartAdd = fileUnit == AxeFXType.original ? 11 : 12;
    await MidiCommand().connectToDevice(device);

    // Uint8List startSysex = fileToSend.sublist(0, 12);
    Uint8List startSysex = Uint8List(11);
    startSysex = calcReqCommand(AxeFileType.ir, startSysex);
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

    Uint8List endSysex = fileToSend.sublist(fileToSend.length - 13);
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
