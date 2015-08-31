// "bass.ck"

// walking bass line
BPM tempo;
Level level;
Key key;
Lead lead;

[0, 2, 3] @=> int roots[];
tempo.meter => int longestNote;
tempo.meter * 4 => int sixteenthsPerMeasure;

2 => int stepSize;

spork ~ lead.updateLevel(level);

// start at a random place in the scale
Math.random2(0,key.scale.cap()-1) => int i;
0 => int j;
<<<key.scale[2]>>>;
while( true )
{
    // play the selected note in the scale
    if (j % sixteenthsPerMeasure == 0) {
        roots[Math.random2(0, roots.cap() - 1)] => i;
    }
    key.root + key.scale[i] + lead.octave * 12 => int thisNote;
    lead.correctOctave(thisNote);
    key.root + key.scale[i] + lead.octave * 12 => thisNote;
    lead.setNote(thisNote);
    
    (sixteenthsPerMeasure / 2) - (j % (sixteenthsPerMeasure / 2)) => int leave;
    Math.min(longestNote, leave) $ int => int maxDur; // $ casts float to int
    Math.random2(1, maxDur) => int duration;
    j + duration => j;
    
    lead.playNote(tempo.sixteenthNote * duration);
    
    // randomly step 0 to 3 positions up or down the scale.
    i + Math.random2(-stepSize,stepSize) => i;
    
    // if you stepped off the scale, jump up or down an octave to get back on
    if(i < 0) {
        key.scale.cap() +=> i;
        lead.changeOctave(-1);
    } else if (i >= key.scale.cap()) {
        key.scale.cap() -=> i;
        lead.changeOctave(1);
    }
}
