import 'package:flutter/material.dart';

//----- Enums -----//
enum SendReceiveMode { send, receive }
enum CabLocation { user, scratchpad }
enum AxeFXType { original, xl, xlPlus }

//----- Model -----//
class AxeLoaderModel extends ChangeNotifier {
  SendReceiveMode _sendReceiveMode = SendReceiveMode.send;
  AxeFXType _axeFXType = AxeFXType.original;
  CabLocation _cabLocation = CabLocation.user;
  String _fileLocation = "";

  SendReceiveMode get sendReceiveMode => _sendReceiveMode;
  AxeFXType get axeFXType => _axeFXType;
  CabLocation get cabLocation => _cabLocation;

  String? get fileLocation {
    if (sendReceiveMode == SendReceiveMode.send) {
      return _fileLocation.contains(".syx") ? _fileLocation : null;
    } else {
      return _fileLocation.isEmpty ? null : _fileLocation;
    }
  }

  set fileLocation(String path) {
    _fileLocation = path;
    notifyListeners();
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
}
