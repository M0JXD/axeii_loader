# Axe-FX II Loader

![Light Mode](/assets/screenshot_light.png) 

A simple utility for loading presets and IRs into and out of the Axe-FX II on Linux.
Only tested on Linux Mint 22.2 with an Axe-FX II MkII.

Unsure how well it will work for XL/XL+ units, although I've provided some options for it based on semi-educated guesses.
Still I'd need more info to implement the XL's properly. Let me know if you want to help with that. <br>
NO WARRANTY IS PROVIDED, USE AT YOUR OWN RISK.

Made as an alternative to Fractal-Bot to avoid needing to rely on Wine as it breaks on occasion.

## Notes

- If the Axe-FX is sending MIDI clock pulses (which it will start doing after requesting the firmware version, e.g. via Fractal-Bot) this util will not work!

- The refresh devices doesn't remove unplugged devices from the list (if you restart the app it will clear). However new devices appear, and replugged devices continue to work with the stubborn entry. This seems to be a limitation of the MIDI library and out of my hands 🙁

- For those disgusted by light mode, don't worry, it respects your system theme:

![Dark Mode](/assets/screenshot_dark.png)

- For the terminal traditionalist, you might like the CLI version I made of this utility: https://github.com/M0JXD/axeii_loader_cli

## Download

The releases page has a portable release bundle for x86-64 Linux. Just extract and run.
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


