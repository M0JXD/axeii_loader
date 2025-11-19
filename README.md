# DO NOT USE, AWAITING UPSTREAM FIXES IN PACAKGES

At the moment the FlutterMidiCommand package used to do the midi interfacing will not even build on Linux with the latest Flutter.
Please use [AXE II LOADER NATIVE](https://github.com/M0JXD/axeii_loader_native), which offers a CLI interface and a native GTK3 GUI, and uses ALSA directly.

Once the package is fixed/maintained I will revisit this version (I'd like it to run on all of Flutter's platforms at some point, as FractalBot even had issues on Windows for me!).
Original README below.

# Axe-FX II Loader

![Light Mode](/assets/screenshot_light.png)

A simple utility for loading presets and IRs in and out of an Axe-FX II on Linux.
Only tested on Linux Mint 22.2 with an Axe-FX II MkII. Made as an alternative to Fractal-Bot to avoid needing to rely on Wine, as it breaks on occasion.

Unsure how well it will work for XL/XL+ units, although I've provided some options for it based on semi-educated guesses.
Still I'd need more info to implement the XL's properly. Let me know if you want to help with that.

NO WARRANTY IS PROVIDED, USE AT YOUR OWN RISK.

## Notes

- If the Axe-FX is sending MIDI clock pulses (which it will start doing after requesting the firmware version, e.g. via Fractal-Bot) this utility will not work!

- The refresh devices doesn't remove unplugged devices from the list (if you restart the app it will clear). However new devices appear, and re-plugged devices continue to work with the stubborn entry. This seems to be a limitation of the MIDI library and out of my hands 🙁

- There are other bugs in the MIDI library I'm having to work around which might cause you issues if trying to use the receive mode after using the send mode, or are trying to change devices. I've filled an issue with them so when they reply I'll see about making it more robust. For now, if transfers stop working, restart the app.

- For those disgusted by light mode, don't worry, it respects your system theme:

![Dark Mode](/assets/screenshot_dark.png)

## Download

The releases page has a portable release bundle for x86-64 Linux. Just extract and run (you might need to use chmod). <br>
You need to keep the lib and data directories relative to the executable. <br>
You might need to install some packages that Flutter needs. On Debian style distros, these packages can be installed by:
`sudo apt-get install libgtk-3-0 libblkid1 liblzma5`

## XL/XL+ Users

I have no clue how to use the extra locations for presets and cabinets in the XL/XL+.
If you're an XL/XL+ owner and want to help me out in implementing that let me know! <br>
Eavesdropping on FractalBot (via Wine) and the Axe-FX II is pretty easy with the ReceiveMIDI tool, and I should only need a handful of information to know how it works.

## Credits

Thanks to:
- Geert Bevin's very handy ReceiveMIDI tool - https://github.com/gbevin/ReceiveMIDI
- The Wine contributors, which has let me run Fractal-Bot and Axe-Edit fairly well
- Fractal Audio for making *the best* modellers
- The contributors to the Axe-FX Wiki's
