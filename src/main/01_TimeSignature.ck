/* TimeSignature.ck */

/* 
 * Describes the events which are generated in each time fraction; e.g.: 
 *		- [1.0, Event] describes the event which is broadcast when a full time beat comes.
 *      - [0.5, Event] describes the event which is broadcast when a half time beat comes.
 */
class TimeEventPerFraction {
    float timeFraction;
    TimeEvent event;
}

/*
 * Time signature definition for a measure.
 * 
 * The caller must decide how detailed the time events of the signature must be, which is defined
 * as 'levels'. The more levels, the more detailed the time events will to be. On the other hand, 
 * more events will be generated, which makes execution more complex.
 */
class TimeSignature {
    100 => int timeEventLevelLimit;
    
    int beatsPerMeasure[];
    int beatNoteValue;
    int bpm;
    int levels;
    
    TimeEventPerFraction timeEventPerFraction[this.timeEventLevelLimit];

    fun void init(int levels) {
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
    
    fun void advanceTime() {
        240000 / bpm / beatNoteValue => float delayTimeMs;

        delayTimeMs * timeEventPerFraction[levels - 1].timeFraction => float step;
        Math.pow(2, this.levels - 1) => float numberOfSteps;
        numberOfSteps / 2 => float cutPosition;
        
        for (0 => int i; i < this.beatsPerMeasure.cap(); ++i) {
            for (0 => int j; j < this.beatsPerMeasure[i]; ++j) {
                for (1 => int k; k < numberOfSteps + 1; ++k) {
                    this.timeEventPerFraction[this.levels - 1] @=> TimeEventPerFraction tepf;

                    <<< "Emitting k=" + k + " - " + tepf.timeFraction + ", " + tepf.event >>>;
                    tepf.event.broadcast();
                    
                    if (k % cutPosition == 0) {
                        for (this.levels - 2 => int l; l > 0; --l) {
                            this.timeEventPerFraction[l] @=> tepf;
                            <<< "Emitting k=" + k + " - " + tepf.timeFraction + ", " + tepf.event >>>;
                            tepf.event.broadcast();
                        }
                    } else if (k % 2 == 0) {
                        k % cutPosition => float normalizedIndex;
                        tepf.timeFraction * normalizedIndex => float finalTimeFraction;
                        
                        for (this.levels - 2 => int l; (l > 0 && this.timeEventPerFraction[l].timeFraction <= finalTimeFraction); --l) {
                            this.timeEventPerFraction[l] @=> tepf;
                            <<< "Emitting k=" + k + " - " + tepf.timeFraction + ", " + tepf.event >>>;
                            tepf.event.broadcast();
                        }
                    }
                    
					if (k == numberOfSteps) {
						<<< "Emitting full time event: " + getEvent(0) >>>;
						getEvent(0).broadcast();
					}
					
                    step::ms => now;
                }
            }
        }
    }
}
