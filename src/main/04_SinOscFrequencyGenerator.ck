/* SinOscFrequencyGenerator.ck */

class SinOscFrequencyGenerator extends MeasureListener {
    SinOsc sinOsc[];
    
    10 => int uGenLimit;
    0 => int uGenCount;
    UGen uGens[this.uGenLimit];
    
    fun void init(int numberOfSinOscs) {
		SinOsc sinOsc[numberOfSinOscs] @=> this.sinOsc;
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
            chuckSinOscToUGen(this.uGens[0]);
            
            <<< "Chucking " + this.uGens[this.uGenCount - 1] + " to dac" >>>;
            this.uGens[this.uGenCount - 1] => dac; 
        } else {
            chuckSinOscToUGen(dac);
        }
    }
    
    fun void disable() {
        if (this.uGenCount > 0) {
            unchuckSinOscFromUGen(this.uGens[0]);
            
            <<< "Unchucking " + this.uGens[this.uGenCount - 1] + " from dac" >>>;
            this.uGens[this.uGenCount - 1] =< dac;
        } else {
            unchuckSinOscFromUGen(dac);
        }
    }
    
    fun void setGain(int sinOscIndex, float gain) {
        if (sinOscIndex < 1) {
			<<< "Parameter sinOscIndex must be > 0. Not setting anything." >>>;
			return;
		}
		
		gain => this.sinOsc[sinOscIndex - 1].gain;
    }
    
    fun void setFrequency(int sinOscIndex, float frequency) {
        if (sinOscIndex < 1) {
			<<< "Parameter sinOscIndex must be > 0. Not setting anything." >>>;
			return;
		}

		frequency => this.sinOsc[sinOscIndex - 1].freq;
    }
	
	fun void chuckSinOscToUGen(UGen uGen) {
		for (0 => int i; i < this.sinOsc.cap(); ++i) {
            <<< "Chucking " + this.sinOsc[i] + " to UGen " + uGen >>>;		
			1.0 / this.sinOsc.cap() => this.sinOsc[i].gain;
			this.sinOsc[i] => uGen;
		}
	}

	fun void unchuckSinOscFromUGen(UGen uGen) {
		for (0 => int i; i < this.sinOsc.cap(); ++i) {
			<<< "Unchucking " + this.sinOsc[i] + " from UGen " + uGen >>>;
			this.sinOsc[i] =< uGen;
		}
	}
}
