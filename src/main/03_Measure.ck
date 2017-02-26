// Machine.add(me.dir() + "/PerMeasureProceeding.ck");
// Machine.add(me.dir() + "/TimeSignature.ck");

class Measure {
    TimeSignature ts;
    PerMeasureProceeding players[];
    
    fun void advanceTime() {
        for (0 => int i; i < players.cap(); i + 1 => i) {
            spork ~ players[i].proceed(this.ts);
        }
        
        ts.advanceTime();
    }
}
