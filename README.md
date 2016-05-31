Keyboard Key Emulator
=====================

A simple program for emulating mac keyboard controls. This is useful when you have, for example a third party keyboard that does not have mac audio controls on it. Currently only audio and volume controls are supported.

To Build
--------
To build you must have XCode installed, as the program uses Cocoa

`make`


Use
---

`make` generates individual programs such as `volume_up`, `volume_down`, etc., but
it also generates a `keyboard_key_emulator` program that you can pass the
following commands to: volumeup, volumedown, volumemute, musicnext,
musicplaypause, musicprevious


