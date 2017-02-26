/* test.ck */

TimeSignature ts;
[6] @=> ts.beatsPerMeasure;
8 => ts.beatNoteValue;
60 => ts.bpmForQuarterNotes;
ts.initTimeSignatureEvents(4);

Measure m;
ts @=> m.ts;

Percussion p;
Melody mel;
[p, mel] @=> m.players;

m.advanceTime();
