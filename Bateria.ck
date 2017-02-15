// I don't know how to declare an interface ¬¬
class PerMeasureProceeding {
    fun void proceed(TimeSignature ts) {};
}

class TimeSignatureEvent extends Event {
    int isStrong;
}

class TimeSignature {
    int beatsPerMeasure[];
    int beatNoteValue;
    int bpmForQuarterNotes;
    
    TimeSignatureEvent timeSignatureEvent;
    Event silence;

    fun void advanceTime() {
        60000 / bpmForQuarterNotes => int delayTimeMs;
        delayTimeMs / (beatNoteValue / 4) => delayTimeMs;

        delayTimeMs / 16 => int timePreBeat;
        (delayTimeMs * 15) / 16 => int timePostBeat;
        
        for (0 => int j; j < beatsPerMeasure.cap(); j + 1 => j) {
            for (0 => int k; k < beatsPerMeasure[j]; k + 1 => k) {
                0 => timeSignatureEvent.isStrong;
                
                if (k == 0) {
                   1 => timeSignatureEvent.isStrong;
                }

                timePreBeat::ms => now;
                timeSignatureEvent.broadcast();                
                timePostBeat::ms => now;

                silence.broadcast();
            }
        }
    }
}

class Percussion extends PerMeasureProceeding {    
   fun void proceed(TimeSignature ts) {
        while (true) {
            ts.timeSignatureEvent => now;

            Impulse i => dac;
            1.0 => i.gain;
            0.2 => i.next;
            if (ts.timeSignatureEvent.isStrong == 1) {
                1.0 => i.next;
            }
            
            ts.silence => now;
        }
    }
}

class Melody extends PerMeasureProceeding {
    fun int getFrequency(int i) {
        return 440 * 2^(i / 12);
    }
    
    fun void proceed(TimeSignature ts) {
        SinOsc sinOsc;
        0.5 => sinOsc.gain;
        
        while (true) {
            getFrequency(Math.random()) => sinOsc.freq;
            
            ts.timeSignatureEvent => now;
            sinOsc => dac;

            ts.silence => now;
            sinOsc =< dac;
        }
    }
}

class Measure {
    TimeSignature ts;
    PerMeasureProceeding players[];
    
    fun void advanceTime() {
        for (0 => int i; i < players.cap(); i + 1 => i) {
            spork ~ players[i].proceed(this.ts);
        }
        
        ts.advanceTime();
    }
}

while (true) {
    TimeSignature ts;
    [3, 3] @=> ts.beatsPerMeasure;
    8 => ts.beatNoteValue;
    120 => ts.bpmForQuarterNotes;

    Measure m;
    ts @=> m.ts;

    Percussion p;
    Melody mel;
    [p, mel] @=> m.players;

    m.advanceTime();
}
