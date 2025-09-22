# Axe-FX II Loader

A simple utility for loading presets and IRs into and out of the Axe-FX II.
Only tested on Linux Mint 22.2 with an Axe-FX II MkII.

Unsure how well it will work for XL/XL+ units, although I've provided some options for it based on semi-educated guesses.
Still I'd need more info to implement the XL's properly. Let me know if you want to help with that. <br>
NO WARRANTY IS PROVIDED, USE AT YOUR OWN RISK.

Made as an alternative to Fractal-Bot to avoid needing to rely on Wine on Linux as it breaks on occasion.
But should be possible to get working on all of Flutter's supported platforms.

If the Axe-FX is sending MIDI clock pulses (which it will start doing after requesting the firmware version, e.g. via Fractal-Bot) this util will not work!

Note: The refresh devices doesn't remove unplugged devices from the list (if you restart the app it will clear). However new devices appear, and replugged devices continue to work with the stubborn entry. This seems to be a limitation of the MIDI library and out of my hands 🙁

For the terminal traditionalist, you might like the CLI version I made of this utility: https://github.com/M0JXD/axeii_loader_cli

## Download

The releases page has a portable release bundle for x86-64 Linux. Just extract and run.
You need to keep the lib and data directories relative to the executable.

You might need to install some packages that Flutter needs. On Debian style distros, these packages can be installed by:
`sudo apt-get install libgtk-3-0 libblkid1 liblzma5`

## Credits

Thanks to:
- Geert Bevin's very handy ReceiveMIDI tool - https://github.com/gbevin/ReceiveMIDI
- The Wine contributors, which has let me run Fractal-Bot and Axe-Edit fairly well
- Fractal Audio for making *the best* modellers
- The contributors to the Axe-FX Wiki's
