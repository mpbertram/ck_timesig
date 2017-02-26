// Machine.add(me.dir() + "/lib/PerMeasureProceeding.ck");
// Machine.add(me.dir() + "/lib/TimeSignature.ck");

class Percussion extends PerMeasureProceeding {    
   fun void proceed(TimeSignature ts) {
        while (true) {
            ts.timeEventPerFraction[0].event => now;

            Impulse i => dac;
            1.0 => i.gain;
            1.0 => i.next;
        }
    }
}
