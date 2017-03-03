/* SinOscFrequencyGenerator.ck */

class SinOscFrequencyGenerator extends MeasureListener {
    SinOsc sinOsc;
    
    10 => int uGenLimit;
    0 => int uGenCount;
    UGen uGens[this.uGenLimit];
    
    fun float frequency(int i) {
        return 440 * Math.pow(2, (i / 12));
    }
    
    fun void addUGen(UGen uGen) {
        if (this.uGenCount < this.uGenLimit) {
            <<< "Adding UGen " + uGen + " to position: " + uGenCount >>>;
            uGen @=> this.uGens[this.uGenCount];
            
            if (this.uGenCount > 0) {
                <<< "Chucking UGen " + this.uGens[uGenCount - 1] + " to UGen: " + this.uGens[uGenCount] >>>;
                this.uGens[uGenCount - 1] => this.uGens[uGenCount];
            }
            
			++this.uGenCount;
        } else {
            <<< "Operation not possible, too many UGens" >>>;
        }
    }
    
    fun void enable() {
        if (this.uGenCount > 0) {
            <<< "Chucking " + this.sinOsc + " to " + this.uGens[0] >>>;
            this.sinOsc => this.uGens[0];
            
            <<< "Chucking " + this.uGens[this.uGenCount - 1] + " to dac" >>>;
            this.uGens[this.uGenCount - 1] => dac; 
        } else {
            <<< "Chucking " + this.sinOsc + " to dac" >>>;
            this.sinOsc => dac;
        }
    }
    
    fun void disable() {
        if (this.uGenCount > 0) {
            <<< "Unchucking " + this.sinOsc + " from " + this.uGens[0] >>>;
            this.sinOsc =< this.uGens[0];
            
            <<< "Unchucking " + this.uGens[this.uGenCount - 1] + " from dac" >>>;
            this.uGens[this.uGenCount - 1] =< dac;
        } else {
            <<< "Unchucking " + this.sinOsc + " to dac" >>>;
            this.sinOsc =< dac;
        }
    }
    
    fun void setGain(float gain) {
        gain => this.sinOsc.gain;
    }
    
    fun void setFrequency(float frequency) {
        frequency => this.sinOsc.freq;
    }
}
