// Machine.add(me.dir() + "/TimeEvent.ck");

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

    /* Constraint: 1 <= levels <= 100 */
    fun void initTimeSignatureEvents(int levels) {
        levels => this.levels;
        
        TimeEventPerFraction tepf;
        1.0 => tepf.timeFraction;
        TimeEvent e @=> tepf.event;
        
        <<< "Initializing " + tepf.timeFraction + ", " + tepf.event >>>;
        tepf @=> this.timeEventPerFraction[0];

        for (1 => int i; i < levels; ++i) {
          TimeEventPerFraction tepf;
          this.timeEventPerFraction[i - 1].timeFraction / 2 => tepf.timeFraction;
          TimeEvent e @=> tepf.event;
          
          <<< "Initializing " + tepf.timeFraction + ", " + tepf.event >>>;
          tepf @=> this.timeEventPerFraction[i];
        }
    }
            
    /* Emits all registered beat signals in broadcast */
    fun void advanceTime() {
        60000 / bpmForQuarterNotes => int delayTimeMs;
        delayTimeMs / (beatNoteValue / 4) => delayTimeMs;

        delayTimeMs * this.timeEventPerFraction[this.levels - 1].timeFraction => float step;
        
        Math.pow(2, this.levels - 1) => float stepNr;
        stepNr / 2 => float cutPosition;
        
        for (0 => int i; i < this.beatsPerMeasure.cap(); ++i) {
            for (0 => int j; j <= this.beatsPerMeasure[i]; ++j) {
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
