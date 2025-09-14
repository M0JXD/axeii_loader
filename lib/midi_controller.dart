// Contains utility functions for MIDI actions on the Axe-FX II

import 'package:axeii_loader/model/model.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class AxeController {

  AxeFXType axeFXType = AxeFXType.original;
  MidiCommand _midiDevice;

  AxeController(this._midiDevice, this.axeFXType);

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

// AxeController axeConnection = AxeController();