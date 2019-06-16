/* test.ck */

class SinOscPerformer extends MeasureListener {
    SinOscFrequencyGenerator sofg;
	sofg.init(2);
	sofg.setFrequency(1, 440.0);
	sofg.setFrequency(2, 555.0);
    
    Gain g;
    0.5 => g.gain;
    
    JCRev rev;
    
	sofg.addUGen(g);
    sofg.addUGen(rev);
    
    fun void perform() {
		while (true) {
			waitFullBeat();
			sofg.enable();

            waitHalfBeat();
            sofg.disable();
        }
    }
}

class ImpulsePerformerFullBeat extends MeasureListener {
   fun void perform() {
        while (true) {
            waitFullBeat();

            Impulse i => dac;
            1.0 => i.gain;
            1.0 => i.next;
        }
    }
}

class ImpulsePerformerHalfBeat extends MeasureListener {
   fun void perform() {
        while (true) {
            waitHalfBeat();

            Impulse i => dac;
            1.0 => i.gain;
            1.0 => i.next;
        }
    }
}

TimeSignature ts;
[4] @=> ts.beatsPerMeasure;
4 => ts.beatNoteValue;
60 => ts.bpm;
ts.init(4);

Measure m;
ts @=> m.ts;

ImpulsePerformerFullBeat ipfb;
ImpulsePerformerHalfBeat iphb;
SinOscPerformer sop;

// m.register(ipfb);
m.register(iphb);
m.register(sop);

m.advanceTime();
