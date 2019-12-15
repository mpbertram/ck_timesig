/* test.ck */

class Harmony extends MeasureListener {
    SinOsc s[3];
    Envelope e[3];

    fun void onInit() {
        SinOsc s[3] @=> this.s;
        Envelope e[3] @=> this.e;

        for (0 => int i; i < s.cap(); ++i) {
            1.0 / (s.cap() * 50) => s[i].gain;
            
            5::second => e[i].duration;
            s[i] => JCRev c => e[i] => dac;
        }
    }

    fun void onDestroy() {
        for (0 => int i; i < s.cap(); ++i) {
            e[i] =< dac;
        }
    }

    fun void perform() {
        e[0].keyOn();
        e[1].keyOn();
        e[2].keyOn();
        
        for (0 => int i; i < 75; ++i) {
            Std.mtof(50) + Math.random2f(-2.5, 2.5) => s[0].freq;
            Std.mtof(54) + Math.random2f(-2.5, 2.5) => s[1].freq;
            Std.mtof(57) + Math.random2f(-2.5, 2.5) => s[2].freq;
            
            waitFullBeat();
            waitFullBeat();
            waitFullBeat();
            waitFullBeat();
        }
        
        for (0 => int i; i < 20; ++i) {
            for (0 => int i; i < s.cap(); ++i) {
                s[i].gain() / 2 => s[i].gain;
            }
            
            waitFullBeat();
            waitFullBeat();
            waitFullBeat();
            waitFullBeat();
        }
    }
}

class EnvelopeProvider {
    fun pure Envelope get();
}

class EnvelopeProviderWithEnvelope extends EnvelopeProvider {
    dur duration;
    
    fun Envelope get() {
        Envelope e;
        duration => e.duration;
        
        return e;
    }
}

class EnvelopeProviderWithAdsr extends EnvelopeProvider {
    dur a;
    dur d;
    float s;
    dur r;  
    
    fun Envelope get() {
        ADSR adsr;
        adsr.set(a, d, s, r);
        
        return adsr;
    }   
}

class Arpeggio extends MeasureListener {
    float notes[];
    int waits[];
    float gain;
    1 => int isDeviation;

    SinOsc v => SinOsc s;

    EnvelopeProvider envelopeProvider;
    Envelope e;

    fun void onInit() {
        envelopeProvider.get() @=> this.e;
        
        s => NRev r => Gain g => e;
        1000.0 => v.gain;
        2 => s.sync;
        0.05 => s.gain;
        
        gain => g.gain;
        e => dac;
    }

    fun void onDestroy() {
        e =< dac;
    }

    fun void perform() {
        for (0 => int i; i < notes.cap(); ++i) {
            if (isDeviation != 0) {
                (notes[i] / 2) + Math.random2f(-2.5, 2.5) => v.freq;
                notes[i] + Math.random2f(-2.5, 2.5) => s.freq;
            } else {
                (notes[i] / 2) => v.freq;
                notes[i] => s.freq;
            }
            
            e.keyOn();
            wait(waits[i] + 2);
            e.keyOff();
            wait(waits[i] + 2);
            wait(waits[i] + 2);
            wait(waits[i] + 2);
        }
    }
}

fun void playHarmony() {
    TimeSignature ts;
    [440] @=> ts.beatsPerMeasure;
    8 => ts.beatNoteValue;
    80 => ts.bpm;
    ts.init(5);

    Harmony h;

    Measure m;
    ts @=> m.ts;

    m.register(h);
    m.advanceTime();
}

TimeSignature ts;
[5] @=> ts.beatsPerMeasure;
8 => ts.beatNoteValue;
65 => ts.bpm;
ts.init(7);

Measure m;
ts @=> m.ts;

EnvelopeProviderWithAdsr envelopeProvider1;
100::ms => envelopeProvider1.a;
300::ms => envelopeProvider1.d;
0.05 => envelopeProvider1.s;
150::ms => envelopeProvider1.r;

EnvelopeProviderWithEnvelope envelopeProvider2;
350::ms => envelopeProvider2.duration;

Arpeggio a1;
[Std.mtof(67), Std.mtof(69), Std.mtof(74), Std.mtof(78), Std.mtof(86)] @=> a1.notes;
[0, 0, 0, 0, 0] @=> a1.waits;
envelopeProvider1 @=> a1.envelopeProvider;

Arpeggio a2;
[Std.mtof(66), Std.mtof(69), Std.mtof(74), Std.mtof(78), Std.mtof(86)] @=> a2.notes;
[0, 0, 0, 0, 0] @=> a2.waits;
envelopeProvider1 @=> a2.envelopeProvider;

Arpeggio G;
[Std.mtof(79), Std.mtof(86), Std.mtof(93), Std.mtof(100), Std.mtof(102)] @=> G.notes;
[0, 0, 0, 0, 0] @=> G.waits;
envelopeProvider2 @=> G.envelopeProvider;
0.55 => G.gain;
0 => G.isDeviation;

Arpeggio F;
[Std.mtof(78), Std.mtof(88), Std.mtof(93), Std.mtof(100), Std.mtof(102)] @=> F.notes;
[0, 0, 0, 0, 0] @=> F.waits;
envelopeProvider2 @=> F.envelopeProvider;
0.55 => F.gain;
0 => F.isDeviation;

Arpeggio E;
[Std.mtof(76), Std.mtof(88), Std.mtof(91), Std.mtof(100), Std.mtof(102)] @=> E.notes;
[0, 0, 0, 0, 0] @=> E.waits;
envelopeProvider2 @=> E.envelopeProvider;
0.55 => E.gain;
0 => E.isDeviation;

spork ~ playHarmony();
for (0 => int i; i < 4; ++i) {
    m.advanceTime();
}

{
    [0.01, 0.01, 0.02, 0.03, 0.05, 0.08, 0.13, 0.21, 0.34, 0.55, 0.89, 1.44] @=> float fib[];
    0 => int lastChord;
    for (0 => int f; f < 40; ++f) {
        Measure m;
        ts @=> m.ts;

        Arpeggio arpeggio;
        if (f % 2 == 0) {
            a1 @=> arpeggio;
        } else {
            a2 @=> arpeggio;
        }

        fib[Math.min(f, 7) $ int] => arpeggio.gain;
        m.register(arpeggio);

        if (f > 7) {
            if (lastChord == 0) {
                m.register(G);
                fib[Math.min(f / 2, 11) $ int] => G.gain;
                1 => lastChord;
            } else if (lastChord == 1) {
                m.register(F);
                fib[Math.min(f / 2, 11) $ int] => F.gain;
                2 => lastChord;
            } else if (lastChord == 2) {
                m.register(E);
                fib[Math.min(f / 2, 11) $ int] => E.gain;
                3 => lastChord;
            } else if (lastChord == 3) {
                m.register(F);
                fib[Math.min(f / 2, 11) $ int] => F.gain;
                0 => lastChord;
            }
        }
        
        m.advanceTime();
    }
}

{
    [1.44, 0.89, 0.55, 0.34, 0.21, 0.13, 0.08, 0.05, 0.03, 0.02, 0.01, 0.01] @=> float fib[];
    0 => int lastChord;
    for (0 => int f; f < 12; ++f) {
        Measure m;
        ts @=> m.ts;

        Arpeggio arpeggio;
        if (f % 2 == 0) {
            a1 @=> arpeggio;
        } else {
            a2 @=> arpeggio;
        }

        fib[Math.min(f + 3, 11) $ int] => arpeggio.gain;
        m.register(arpeggio);

        if (lastChord == 0) {
            m.register(G);
            fib[Math.min(f, 11) $ int] => G.gain;
            1 => lastChord;
        } else if (lastChord == 1) {
            m.register(F);
            fib[Math.min(f, 11) $ int] => F.gain;
            2 => lastChord;
        } else if (lastChord == 2) {
            m.register(E);
            fib[Math.min(f, 11) $ int] => E.gain;
            3 => lastChord;
        } else if (lastChord == 3) {
            m.register(F);
            fib[Math.min(f, 11) $ int] => F.gain;
            0 => lastChord;
        }
        
        m.advanceTime();
    }
}
