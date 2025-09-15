import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

//----- Enums -----//
enum SendReceiveMode { send, receive }

enum CabLocation { user, scratchpad }

enum AxeFXType { original, xl, xlPlus }

enum AxeFileType { preset, ir }

//----- Model -----//
class AxeLoaderModel extends ChangeNotifier {
  SendReceiveMode _sendReceiveMode = SendReceiveMode.send;
  AxeFXType _axeFXType = AxeFXType.original;
  CabLocation _cabLocation = CabLocation.user;
  String _fileLocation = "";
  AxeFileType? _detectedType;
  double _transactionProgress = 0;

  //----- Getters -----//

  SendReceiveMode get sendReceiveMode => _sendReceiveMode;
  AxeFXType get axeFXType => _axeFXType;
  CabLocation get cabLocation => _cabLocation;
  double get transactionProgress => _transactionProgress;

  String? get fileLocation {
    if (sendReceiveMode == SendReceiveMode.send) {
      return _fileLocation.contains(".syx") ? _fileLocation : null;
    } else {
      return _fileLocation.isEmpty ? null : _fileLocation;
    }
  }

  AxeFileType? get detectedType => _detectedType;
  //----- Setters -----//

  set fileLocation(String path) {
    _fileLocation = path;
    notifyListeners();
    typeDetector(path);  // Set off the type detector now
  }

  set sendReceiveMode(SendReceiveMode newMode) {
    _sendReceiveMode = newMode;
    notifyListeners();
  }

  set axeFXType(AxeFXType newType) {
    _axeFXType = newType;
    notifyListeners();
  }

  set cabLocation(CabLocation newLocation) {
    _cabLocation = newLocation;
    notifyListeners();
  }

  set transactionProgress(double newProgress) {
    _transactionProgress = newProgress;
    notifyListeners();
  }

  //----- Utility -----//
  Future<AxeFileType?> typeDetector(String pathToFile) async {
    _detectedType = null;
    var file = File(pathToFile);
    Uint8List fileAsBytes;
    try {
      fileAsBytes = await file.readAsBytes();
      // A preset file's 6th byte should be 0x77
      if (fileAsBytes[5] == 0x77) {
        _detectedType = AxeFileType.preset;
      }
      // An IR file's 6th byte should be 0x7A
      if (fileAsBytes[5] == 0x7A) {
        _detectedType = AxeFileType.ir;
      }
    } on PathNotFoundException {
      _detectedType = null;
    }
    return _detectedType;
  }
}
