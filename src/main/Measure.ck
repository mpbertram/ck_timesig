public class ck_timesig__Measure {
    ck_timesig__TimeSignature ts;
    ck_timesig__MeasureListener measureListeners[0];
        
    fun void register(ck_timesig__MeasureListener ml) {
        measureListeners.cap() => int listenersCap;
        
        ck_timesig__MeasureListener t[listenersCap + 1];
        if (listenersCap > 0) {
            for (0 => int i; i < listenersCap; ++i) {
                measureListeners[i] @=> t[i];
            }
        }

        ml.assignTimeSignature(ts);
        ml @=> t[t.cap() - 1];
        
        t @=> measureListeners;
    } 
    
    fun void advanceTime() {
        measureListeners.cap() => int listenersCount;
        
        Shred shreds[listenersCount];
        
        for (0 => int i; i < listenersCount; ++i) {
            measureListeners[i] @=> ck_timesig__MeasureListener ml;
            
            ml.prepare();
            spork ~ ml.perform() @=> Shred s;
            
            s @=> shreds[i];
        }
        
        ts.advanceTime();
        
        for (0 => int i; i < listenersCount; ++i) {
            measureListeners[i] @=> ck_timesig__MeasureListener ml;
            shreds[i] @=> Shred s;
            
            spork ~ destroy(ml, s);
        }
    }
    
    fun void destroy(ck_timesig__MeasureListener ml, Shred s) {
        ml.tearDownTolerance() => now;
        ml.tearDown();
        s.exit();
    }
}
