[
    me.sourceDir() + "/TimeEvent.ck",
    me.sourceDir() + "/TimeSignature.ck",
    me.sourceDir() + "/MeasureListener.ck",
    me.sourceDir() + "/Measure.ck"
] @=> string sources[];

for (0 => int i; i < sources.cap(); ++i) {
    sources[i] => string source;
    
    Machine.add(source) => int sId;
    Shred.fromId(sId) @=> Shred s;

    while(!s.done()) 100::ms => now;
}
