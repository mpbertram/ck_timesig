# ck_timesig
A ChucK library to deal with time signatures.

`ck_timesig` uses ChucK's event and thread (shred) framework.
Events are broadcast as a measure passes (full beats, half beats, etc.).
Threads (shreds) are spawned for each performer (instrument) in order to allow parallel execution.

## Functionality

The library is divided in three main functionalities: time signatures, measures and measure listeners. 

### Time signatures
The block
```
TimeSignature ts;
[4] @=> ts.beatsPerMeasure;
4 => ts.beatNoteValue;
120 => ts.bpm;
```
is equivalent to a 4/4 time signature à 120 BPM.

In order for a time signature to be used, its time events must be initialized with the function `init(int levels)`.
E.g. if only full beats (notes) are going to be listened to, `init(1)` is sufficient. If half beats are also relevant, one must use `init(2)` and so on.

### Measures
Measures are composed of a time signature and measure listeners.
Once a measure has a time signature and registered measure listeners, time may be advanced and the measure will be played.
Each measure listener is perfomed in a separate thread (shred) in order to allow parallel performers.

### Measure listeners
The class `MeasureListener` may be extended (abstract function `perform` must be implemented).
This defines a performer which will be played if it is registered at a measure and the measure's time is advanced.

## Building the lib

### Build/test library
This is the default Ant target, which builds the library and runs tests.
```
ant
```
In order to just build the library without testing, run
```
ant build
```

The library is available after a successful build in `build/ChuckLib.ck`.

### Record test
```
ant rec-test
```
This produces a `.wav` file in the folder `recs` with the current test recording.

## Deps
```
ChucK <= 1.3.5.1
Ant
```

## Examples
Please check `src/test/test.ck`.
