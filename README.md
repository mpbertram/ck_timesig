# ck_timesig
A ChucK library to deal with time signatures.

Examples for usage may be found in the test files.

## Functionality
```
TimeSignature ts;
[4] @=> ts.beatsPerMeasure;
4 => ts.beatNoteValue;
120 => ts.bpm;
```
is equivalent to a 4/4 time signature à 120 BPM.
