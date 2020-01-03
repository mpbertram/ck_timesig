class Tree {
    ck_timesig__TimeEvent item;
    
    /* Actually of type Tree (recursive data types not supported) */
    Object left;
    /* Actually of type Tree (recursive data types not supported) */
    Object right;

    fun int isLeaf() {
        return left == null && right == null;
    }
}

public class ck_timesig__TimeSignature {
    int beatsPerMeasure[];
    int beatNoteValue;
    int bpm;
    
    Tree tree;
    null => tree.left;
    null => tree.right;
    
    ck_timesig__TimeEvent timeEvent[];

    fun Tree insertTree(Tree node, ck_timesig__TimeEvent te) {
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
        ck_timesig__TimeEvent t[levels] @=> timeEvent;

        ck_timesig__TimeEvent te;
        1.0 => te.timeFraction;
        te @=> timeEvent[0];
        te @=> tree.item;

        for (1 => int i; i < levels; ++i) {
            ck_timesig__TimeEvent te;
            timeEvent[i - 1].timeFraction / 2.0 => te.timeFraction;
            te @=> timeEvent[i];
            insertTree(tree, te);
        }
    }
     
    fun void advanceTime() {
        240000 / bpm / beatNoteValue => float delayTimeMs;
        delayTimeMs * timeEvent[timeEvent.cap() - 1].timeFraction => float step;
        
        for (0 => int i; i < beatsPerMeasure.cap(); ++i) {
            for (0 => int j; j < beatsPerMeasure[i]; ++j) {
                traverseTree(tree, step);
            }
        }
    }

    fun void traverseTree(Tree tree, float step) {
        if (tree != null) {
            traverseTree(tree.left $ Tree, step);
            traverseTree(tree.right $ Tree, step);
            
            if (tree.isLeaf()) {
                step::ms => now;
            }
            
            tree.item.broadcast();
        }
    }
    
    fun ck_timesig__TimeEvent getEvent(int level) {
        return timeEvent[level];
    }
}
