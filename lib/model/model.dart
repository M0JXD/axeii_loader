import 'package:flutter/material.dart';

//----- Enums -----//
enum SendReceiveMode { send, receive }
enum CabLocation { user, scratchpad }
enum AxeFXType { original, xl, xlPlus }

class AxeLoaderModel extends ChangeNotifier {
  SendReceiveMode _sendReceiveMode = SendReceiveMode.send;
  AxeFXType _axeFXType = AxeFXType.original;
  CabLocation _cabLocation = CabLocation.user;

  SendReceiveMode get sendReceiveMode => _sendReceiveMode;
  AxeFXType get axeFXType => _axeFXType;
  CabLocation get cabLocation => _cabLocation;

  void changeSendReceiveMode(SendReceiveMode newMode) {
    _sendReceiveMode = newMode;
    notifyListeners();
  }

  void changeUnitType(AxeFXType newType) {
    _axeFXType = newType;
    notifyListeners();
  }

  void changeCabLocation(CabLocation newLocation) {
    _cabLocation = newLocation;
    notifyListeners();
  }

}