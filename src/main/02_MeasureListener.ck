/* MeasureListener.ck */

class MeasureListener {
    TimeSignature timeSignature;
    
    fun void onInit() {}
    fun void onDestroy() {}
    fun pure void perform();
    
    fun void assignTimeSignature(TimeSignature timeSignature) {
        timeSignature @=> this.timeSignature;
    }
    
    fun void wait(int level) {
        this.timeSignature.getEvent(level) => now;
    }
    
    fun void waitFullBeat() {
        wait(0);
    }
    
    fun void waitHalfBeat() {
        wait(1);
    }
    
    fun void waitQuarterBeat() {
        wait(2);
    }
    
    fun void waitEighthBeat() {
        wait(3);
    }
    
    fun void waitSixteenthBeat() {
        wait(4);
    }
    
    fun void waitThirtySecondBeat() {
        wait(5);
    }
    
    fun void waitSixtyFourthBeat() {
        wait(6);
    }
    
    fun void waitHundredTwentyEighthBeat() {
        wait(7);
    }
    
    fun void waitTwoHundredFiftySixthBeat() {
        wait(8);
    }
    
    fun void waitFiveHundredTwelfthBeat() {
        wait(9);
    }
}
