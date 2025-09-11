// Contains utility functions for MIDI actions on the Axe-FX II

import 'package:flutter_midi_command/flutter_midi_command.dart';

enum AxeFXType { original, xl, xlPlus }

class AxeController {

  AxeFXType _type;
  MidiCommand _midiDevice;

  AxeController(this._midiDevice,  this._type);

  void changePreset(int presetNumber) {
    
  }

  void uploadPreset(String pathToPreset) {

  }

  void downloadPreset(String pathToSave) {

  }

  void uploadCab(String pathToCab, int location, bool scratchpad) {

  }

  void downloadCab(String pathToSave, int location) {

  }

}


