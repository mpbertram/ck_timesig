/* test.ck */

class SinOscPerformer extends MeasureListener {
    SinOscFrequencyGenerator sofg;
    
    fun void perform() {
        sofg.setGain(0.5);
        sofg.setFrequency(440.0);
        
        while (true) {
            wait(0);
            sofg.enable();
            
            wait(1);
            sofg.disable();
        }
    }
}

class ImpulsePerformer extends MeasureListener {    
   fun void perform() {
        while (true) {
            wait(0);

            Impulse i => dac;
            1.0 => i.gain;
            1.0 => i.next;
        }
    }
}

TimeSignature ts;
[6] @=> ts.beatsPerMeasure;
8 => ts.beatNoteValue;
60 => ts.bpmForQuarterNotes;
ts.initTimeSignatureEvents(4);

Measure m;
ts @=> m.ts;

ImpulsePerformer ip;
SinOscPerformer sop;

m.register(ip);
m.register(sop);

m.advanceTime();
