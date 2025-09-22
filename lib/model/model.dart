import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'midi_controller.dart';

//----- Enums -----//
enum SendReceiveMode { send, receive }

enum AxeFileType { preset, ir }

//----- Model -----//
class AxeLoaderViewModel extends ChangeNotifier {
  //----- Fields -----//
  int number = 0;
  AxeFileType receivePlace = AxeFileType.preset;
  bool _buttonDisable = true;
  String _fileLocation = "";
  double _transactionProgress = 0.0;
  SendReceiveMode _sendReceiveMode = SendReceiveMode.send;
  AxeFXType? _axeFXType = AxeFXType.original;
  MidiDevice? _selectedDevice;
  final FileProperties _fileProperties = FileProperties(null, null);

  //----- Getters -----//
  SendReceiveMode get sendReceiveMode => _sendReceiveMode;
  AxeFXType? get axeFXType => _axeFXType;
  MidiDevice? get selectedDevice => _selectedDevice;
  double get transactionProgress => _transactionProgress;
  bool get buttonDisable => _buttonDisable;
  AxeFileType? get fileType => _fileProperties.fileType;

  String? get fileLocation {
    if (sendReceiveMode == SendReceiveMode.send) {
      return _fileLocation.contains(".syx") ? _fileLocation : null;
    } else {
      return _fileLocation.isEmpty ? null : _fileLocation;
    }
  }

  String get sendReason {
    if ((_fileProperties.unitType != AxeFXType.original &&
            axeFXType == AxeFXType.original) &&
        _fileLocation.isNotEmpty &&
        _fileProperties.unitType != null) {
      return "Can't send XL/XL+ Presets to Original/MkII!";
    } else {
      return '';
    }
  }

  //----- Setters -----//
  set fileLocation(String path) {
    _fileLocation = path;
    if (_sendReceiveMode == SendReceiveMode.send) {
      // Set off the type detector now
      runTypeDetectorAndNotify(path);
    } else {
      buttonDisable = isButtonDisabled();
      notifyListeners();
    }
  }

  set sendReceiveMode(SendReceiveMode newMode) {
    _sendReceiveMode = newMode;
    // When changing, also reset some stuff...
    fileLocation = '';
    transactionProgress = 0.0;
    buttonDisable = isButtonDisabled();
    notifyListeners();
  }

  set axeFXType(AxeFXType? newType) {
    _axeFXType = newType;
    buttonDisable = isButtonDisabled();
    notifyListeners();
  }

  set selectedDevice(MidiDevice? newDevice) {
    _selectedDevice = newDevice;
    buttonDisable = isButtonDisabled();
    notifyListeners();
  }


  set transactionProgress(double newProgress) {
    _transactionProgress = newProgress;
    notifyListeners();
  }

  set buttonDisable(bool newState) {
    _buttonDisable = newState;
    notifyListeners();
  }

  //------ Get/Set Utilities -----//
  void runTypeDetectorAndNotify(String path) async {
    await _fileProperties.typeDetector(path);
    buttonDisable = isButtonDisabled();
    notifyListeners();
  }

  bool isButtonDisabled() {
    bool ret = true;

    // These need to be set to send or receive
    if (_selectedDevice != null &&
        _fileLocation.isNotEmpty &&
        _axeFXType != null) {
      // Just send checks
      if (_sendReceiveMode == SendReceiveMode.send) {
        if (_fileProperties.unitType != null &&
            _fileProperties.fileType != null) {
          if (_fileProperties.fileType == AxeFileType.preset &&  !(_axeFXType == AxeFXType.original &&
              _fileProperties.unitType != AxeFXType.original)) {
            ret = false;
          } else if (_fileProperties.fileType == AxeFileType.ir) {
            ret = false;
          }
        }

        // Just receive checks
      } else if (_sendReceiveMode == SendReceiveMode.receive) {
        ret = false;
      }
    }
    return ret;
  }

  //----- Methods -----//
  void beginTransfer() async {
    buttonDisable = true;
    transactionProgress = 0.0;
    AxeController axeController = AxeController(
      device: selectedDevice!,
      axeFXType: _axeFXType!,
      location: _fileLocation,
      number: number,
      fileUnit: _fileProperties.unitType,
    );
    if (_sendReceiveMode == SendReceiveMode.send) {
      if (_fileProperties.fileType == AxeFileType.preset) {
        await for (final i in axeController.uploadPreset()) {
          transactionProgress = i;
        }
      } else {
        await for (final i in axeController.uploadCab()) {
          transactionProgress = i;
        }
      }
    } else {
      if (receivePlace == AxeFileType.preset) {
        await for (final i in axeController.downloadPreset()) {
          transactionProgress = i;
        }
      } else {
        await for (final i in axeController.downloadCab()) {
          transactionProgress = i;
        }
      }
    }
    buttonDisable = isButtonDisabled();
  }
}

class FileProperties {
  AxeFileType? fileType;
  AxeFXType? unitType;

  FileProperties(this.fileType, this.unitType);

  Future<void> typeDetector(String pathToFile) async {
    fileType = null;
    var file = File(pathToFile);
    Uint8List fileAsBytes;
    try {
      fileAsBytes = await file.readAsBytes();
      // A preset file's 6th byte should be 0x77
      if (fileAsBytes[5] == 0x77) {
        fileType = AxeFileType.preset;
      } else if (fileAsBytes[5] == 0x7A) {
        // An IR file's 6th byte should be 0x7A
        fileType = AxeFileType.ir;
      } else {
        fileType = null;
      }

      if (fileAsBytes[4] == 0x03) {
        unitType = AxeFXType.original;
      } else if (fileAsBytes[4] == 0x06) {
        unitType = AxeFXType.xl;
      } else if (fileAsBytes[4] == 0x07) {
        unitType = AxeFXType.xlPlus;
      } else {
        unitType = null;
      }
    } on PathNotFoundException {
      fileType = null;
      unitType = null;
    }
  }
}
