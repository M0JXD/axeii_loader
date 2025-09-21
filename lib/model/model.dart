import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'midi_controller.dart';

//----- Enums -----//
enum SendReceiveMode { send, receive }

enum AxeFileType { preset, ir }

enum CabLocation { user, scratchpad }

//----- Model -----//
class AxeLoaderViewModel extends ChangeNotifier {
  //----- Fields -----//
  int _location = 0;
  bool _buttonDisable = true;
  String _fileLocation = "";
  double _transactionProgress = 0.0;
  FileProperties _fileProperties = FileProperties(null, null);
  SendReceiveMode _sendReceiveMode = SendReceiveMode.send;
  AxeFXType? _axeFXType = AxeFXType.original;
  MidiDevice? _selectedDevice;
  CabLocation _cabLocation = CabLocation.user;

  //----- Getters -----//
  SendReceiveMode get sendReceiveMode => _sendReceiveMode;
  AxeFXType? get axeFXType => _axeFXType;
  CabLocation get cabLocation => _cabLocation;
  MidiDevice? get selectedDevice => _selectedDevice;
  int get location => _location;
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

  //----- Setters -----//
  set fileLocation(String path) {
    _fileLocation = path;
    if (_sendReceiveMode == SendReceiveMode.send) {
      // Set off the type detector now, it will call notify when it's done
      buttonDisable = isButtonDisabled();
      _fileProperties.typeDetector(_fileLocation);
      notifyListeners();
      // typeDetector(path);
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
    notifyListeners();
  }

  set axeFXType(AxeFXType? newType) {
    _axeFXType = newType;
    notifyListeners();
  }

  set cabLocation(CabLocation newLocation) {
    _cabLocation = newLocation;
    notifyListeners();
  }

  set selectedDevice(MidiDevice? newDevice) {
    _selectedDevice = newDevice;
    buttonDisable = isButtonDisabled();
    notifyListeners();
  }

  set location(int newLocation) {
    _location = newLocation;
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

  //----- Methods -----//

  void beginTransfer() async {
    transactionProgress = 0.0;
    if (_selectedDevice != null && _fileLocation.isNotEmpty) {
      AxeController axeController = AxeController(device: selectedDevice!);
      if (_sendReceiveMode == SendReceiveMode.send) {
        if (_fileProperties.fileType == AxeFileType.preset) {
          await for (final i in axeController.uploadPreset(_fileLocation)) {
            transactionProgress = i;
          }
        } else {
          axeController.uploadCab(_fileLocation, _location);
        }
      } else {
        if (_fileProperties.fileType == AxeFileType.preset) {
          axeController.downloadPreset(_fileLocation);
        } else {
          axeController.downloadCab(_fileLocation, _location);
        }
      }
    }
  }

  bool isButtonDisabled() {
    if (_sendReceiveMode == SendReceiveMode.send) {
      return (_fileProperties.fileType == null || _selectedDevice == null) ? true : false;
    } else {
      return (_selectedDevice == null || _fileLocation.isNotEmpty)
          ? true
          : false;
    }
  }
}

class FileProperties {
  AxeFileType? fileType;
  AxeFXType? unitType;

  FileProperties(this.fileType, this.unitType);

  void typeDetector(String pathToFile) async {
    fileType = null;
    var file = File(pathToFile);
    Uint8List fileAsBytes;
    try {
      fileAsBytes = await file.readAsBytes();
      // A preset file's 6th byte should be 0x77
      if (fileAsBytes[5] == 0x77) {
        fileType = AxeFileType.preset;
      }
      // An IR file's 6th byte should be 0x7A
      if (fileAsBytes[5] == 0x7A) {
        fileType = AxeFileType.ir;
      }
    } on PathNotFoundException {
      fileType = null;
    }
  }
}
