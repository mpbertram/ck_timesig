[
    me.sourceDir() + "/../main/CkTimesig.ck",
    me.sourceDir() + "/test.ck"
] @=> string sources[];

for (0 => int i; i < sources.cap(); ++i) {
    sources[i] => string source;
    
    Machine.add(source) => int sId;
    Shred.fromId(sId) @=> Shred s;

    while(!s.done()) 100::ms => now;
}
