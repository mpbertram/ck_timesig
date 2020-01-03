public class ck_timesig__MeasureListener {
    ck_timesig__TimeSignature ts;
    
    fun void onInit() {}
    fun void onDestroy() {}
    fun pure void perform();
    
    fun void assignTimeSignature(ck_timesig__TimeSignature t) {
        t @=> ts;
    }
    
    fun void wait(int level) {
        ts.getEvent(level) => now;
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
