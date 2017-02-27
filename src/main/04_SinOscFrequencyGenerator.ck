/* SinOscFrequencyGenerator.ck */

class SinOscFrequencyGenerator extends MeasureListener {
    SinOsc sinOsc;
    
    fun float frequency(int i) {
        return 440 * Math.pow(2, (i / 12));
    }
    
    fun void enable() {
        this.sinOsc => dac;
    }
    
    fun void disable() {
        this.sinOsc =< dac;
    }
    
    fun void setGain(float gain) {
        gain => this.sinOsc.gain;
    }
    
    fun void setFrequency(float frequency) {
        frequency => this.sinOsc.freq;
    }
}
