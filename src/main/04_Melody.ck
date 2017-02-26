// Machine.add(me.dir() + "/lib/PerMeasureProceeding.ck");
// Machine.add(me.dir() + "/lib/TimeSignature.ck");

class Melody extends PerMeasureProceeding {
    fun float getFrequency(int i) {
        return 440 * Math.pow(2, (i / 12));
    }
    
    fun void proceed(TimeSignature ts) {
        SinOsc sinOsc;
        0.5 => sinOsc.gain;
        440.0 => sinOsc.freq;
        
        while (true) {
            ts.timeEventPerFraction[0].event => now;
            sinOsc => dac;
            
            ts.timeEventPerFraction[1].event => now;
            sinOsc =< dac;
        }
    }
}
