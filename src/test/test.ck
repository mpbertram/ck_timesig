// Machine.add(me.dir() + "/lib/PerMeasureProceeding.ck");
// Machine.add(me.dir() + "/lib/TimeSignature.ck");
// Machine.add(me.dir() + "/lib/Measure.ck");

// Machine.add(me.dir() + "/Percussion.ck");
// Machine.add(me.dir() + "/Melody.ck");

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
