/* TimeSignature.ck */

class Tree {
	TimeEvent item;
	
	/* Actually of type Tree (recursive data types not supported) */
	Object left;
	/* Actually of type Tree (recursive data types not supported) */
	Object right;

	fun int isLeaf() {
		return left == null && right == null;
	}
}

class TimeSignature {
    10 => int eventLimit;
    
    int beatsPerMeasure[];
    int beatNoteValue;
    int bpm;
    int levels;
    
	Tree tree;
	null => tree.left;
	null => tree.right;
	
    TimeEvent timeEvent[this.eventLimit];

	fun Tree insertTree(Tree node, TimeEvent te) {
		if (node == null) {
			Tree n;
			te @=> n.item;
			null => n.left;
			null => n.right;
			return n;
		}
		
		insertTree(node.left $ Tree, te) @=> node.left;
		insertTree(node.right $ Tree, te) @=> node.right;
		
		return node;
	}

    fun void init(int levels) {
        levels => this.levels;

        TimeEvent te;
        1.0 => te.timeFraction;
        
        <<< "Initializing " + te.timeFraction + ", " + te >>>;
        te @=> this.timeEvent[0];

		te @=> tree.item;

        for (1 => int i; i < levels; ++i) {
			TimeEvent te;
			this.timeEvent[i - 1].timeFraction / 2.0 => te.timeFraction;

			<<< "Initializing " + te.timeFraction + ", " + te >>>;
			te @=> this.timeEvent[i];

			insertTree(tree, te);
        }
    }
     
    fun void advanceTime() {
        240000 / bpm / beatNoteValue => float delayTimeMs;
        delayTimeMs * timeEvent[levels - 1].timeFraction => float step;
        
		traverseTree(tree, step);
    }

	fun void traverseTree(Tree tree, float step) {
		if (tree != null) {
			traverseTree(tree.left $ Tree, step);
            traverseTree(tree.right $ Tree, step);
			
			if (tree.isLeaf()) {
				step::ms => now;
			}
			
			<<< "Emitting " + tree.item.timeFraction + ", " + tree.item >>>;
            tree.item.broadcast();
		}
	}
	
	fun TimeEvent getEvent(int level) {
        return this.timeEvent[level];
    }
}
