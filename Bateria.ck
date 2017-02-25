// I don't know how to declare an interface ¬¬
class PerMeasureProceeding {
    fun void proceed(TimeSignature ts) {};
}

class TimeEvent extends Event {
    int isStrong;
}

class TimeEventPerFraction {
    float timeFraction;
    TimeEvent event;
}

class TimeSignature {
    int beatsPerMeasure[];
    int beatNoteValue;
    int bpmForQuarterNotes;
    int levels;
    
    TimeEventPerFraction timeEventPerFraction[100];

    fun void initTimeSignatureEvents(int levels) {
        levels => this.levels;
        
        TimeEventPerFraction tepf;
        1.0 => tepf.timeFraction;
        TimeEvent e @=> tepf.event;
        
        <<< tepf.timeFraction + ", " + tepf.event >>>;
        tepf @=> this.timeEventPerFraction[0];

        for (1 => int i; i < levels; ++i) {
          TimeEventPerFraction tepf;
          this.timeEventPerFraction[i - 1].timeFraction / 2 => tepf.timeFraction;
          TimeEvent e @=> tepf.event;
          
          <<< tepf.timeFraction + ", " + tepf.event >>>;
          tepf  @=> this.timeEventPerFraction[i];
        }
    }
            
    
    fun void advanceTime() {
        60000 / bpmForQuarterNotes => int delayTimeMs;
        delayTimeMs / (beatNoteValue / 4) => delayTimeMs;

        delayTimeMs * this.timeEventPerFraction[this.levels - 1].timeFraction => float step;
        
        Math.pow(2, this.levels - 1) => float stepNr;
        stepNr / 2 => float cutPosition;
        
        for (0 => int i; i < this.beatsPerMeasure.cap(); ++i) {
            for (0 => int j; j < this.beatsPerMeasure[i] + 1; ++j) {
                for (1 => int k; k < stepNr + 1; ++k) {
                    this.timeEventPerFraction[this.levels - 1] @=> TimeEventPerFraction tepf;

                    <<< "Emiting k=" + k + " - " + tepf.timeFraction + ", " + tepf.event >>>;
                    tepf.event.broadcast();
                    
                    if (k % cutPosition == 0) {
                        for (this.levels - 2 => int l; l > 0; --l) {
                            this.timeEventPerFraction[l] @=> tepf;
                            <<< "Emiting k=" + k + " - " + tepf.timeFraction + ", " + tepf.event >>>;
                            tepf.event.broadcast();
                        }
                    } else if (k % 2 == 0) {
                        k % cutPosition => float normalizedIndex;
                        tepf.timeFraction * normalizedIndex => float finalTimeFraction;
                        
                        for (this.levels -2 => int l; (l > 0 && this.timeEventPerFraction[l].timeFraction <= finalTimeFraction); --l) {
                            this.timeEventPerFraction[l] @=> tepf;
                            <<< "Emiting k=" + k + " - " + tepf.timeFraction + ", " + tepf.event >>>;
                            tepf.event.broadcast();
                        }
                    }
                    
                    step::ms => now;
                }
                
                this.timeEventPerFraction[0].event.broadcast();
            }
        }
    }
}

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

class Melody extends PerMeasureProceeding {
    fun int getFrequency(int i) {
        return 440 * 2^(i / 12);
    }
    
    fun void proceed(TimeSignature ts) {
        SinOsc sinOsc;
        0.5 => sinOsc.gain;
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
