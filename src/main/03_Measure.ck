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
        Shred shreds[this.registeredListenersCount];
        
        for (0 => int i; i < this.registeredListenersCount; ++i) {
            measureListeners[i].onInit();
            spork ~ measureListeners[i].perform() @=> shreds[i];
            <<< "Sporked shred " + shreds[i] >>>;
        }
        
        ts.advanceTime();
        
        for (0 => int i; i < this.registeredListenersCount; ++i) {
            <<< "Killing shred " + shreds[i] >>>;
            measureListeners[i].onDestroy();
            shreds[i].exit();
        }
    }
}
