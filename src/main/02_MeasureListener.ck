/* MeasureListener.ck */

class MeasureListener {
    TimeSignature timeSignature;
    
    fun pure void perform();
    
    fun void assignTimeSignature(TimeSignature timeSignature) {
        timeSignature @=> this.timeSignature;
    }
    
    fun void wait(int level) {
        this.timeSignature.getEvent(level) => now;
    }
}
