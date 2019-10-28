/*
 * Based on http://chuck.cs.princeton.edu/doc/examples/basic/rec-auto.ck
 */

dac => Gain g => WvOut w => blackhole;

me.dir() + "recs/chuck-session" => w.autoPrefix;
"special:auto" => w.wavFilename;

<<< "Writing to file: ", w.filename() >>>;

1.0 => g.gain;

// temporary workaround to automatically close file on remove-shred
null @=> w;

Machine.add(me.arg(0)) => int shredId;
Shred.fromId(shredId) @=> Shred s;
	
while (!s.done()) 1::second => now;
