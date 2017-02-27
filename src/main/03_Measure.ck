/* Measure.ck */

class Measure {
    100 => int measureListenersLimit;
    0 => int registeredListenersCount;
    
    TimeSignature ts;
    MeasureListener measureListeners[this.measureListenersLimit];
        
    fun void register(MeasureListener measureListener) {
        if (this.registeredListenersCount >= this.measureListenersLimit) {
            <<< "Could not register listener " + measureListener + ": limit achieved" >>>;
            return;
        }
        
        <<< "Adding listener " + measureListener + " in position " + registeredListenersCount >>>;
        measureListener.assignTimeSignature(this.ts);
        measureListener @=> this.measureListeners[this.registeredListenersCount];
        ++registeredListenersCount;
    } 
    
    fun void advanceTime() {
        for (0 => int i; i < measureListeners.cap(); ++i) {
            spork ~ measureListeners[i].perform();
        }
        
        ts.advanceTime();
    }
}
