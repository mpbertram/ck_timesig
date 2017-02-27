/* TimeSignature.ck */

/* 
 * Describes the events which are generated in each time fraction;
 * e.g. - [1.0, Event] describes the event which is broadcast when a full beat comes.
 *      - [0.5, Event] describes the event which is broadcast when a half time beat comes.
 */
class TimeEventPerFraction {
    float timeFraction;
    TimeEvent event;
}

/* 
 * Description of a time singature. This class is used a time signature definition for a measure.
 * The caller must decide how detailed must be the time events of the signature, which is defined
 * as 'levels'. The more levels, the more detailed the time events are going to be, and listeners 
 * may be registered to the smallest time fraction events. On the other hand, more events will be
 * generated, which makes execution more complex.
 */
class TimeSignature {
    100 => int timeEventLevelLimit;
    
    int beatsPerMeasure[];
    int beatNoteValue;
    int bpmForQuarterNotes;
    int levels;
    
    TimeEventPerFraction timeEventPerFraction[this.timeEventLevelLimit];

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
     
    fun Event getEvent(int level) {
        return this.timeEventPerFraction[level].event;
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
                this.timeEventPerFraction[0].event.broadcast();
                
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
            }
        }
    }
}
