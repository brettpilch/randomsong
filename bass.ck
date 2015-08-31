// "bass.ck"

// walking bass line
BPM tempo;
Level level;
Key key;
Bass bass;

[0, 2, 3] @=> int roots[];
2 => int longestNote;
tempo.meter * 4 => int sixteenthsPerMeasure;

2 => int stepSize;

spork ~ bass.updateLevel(level);

// start at a random place in the scale
//Math.random2(0,notes.cap()-1) => int i;
Math.random2(0,key.scale.cap()-1) => int i;
0 => int j;
<<<key.scale[2]>>>;
while( true )
{
    if (j % sixteenthsPerMeasure == 0) {
        roots[Math.random2(0, roots.cap() - 1)] => i;
    }
    key.root + key.scale[i] + bass.octave * 12 => int thisNote;
    bass.correctOctave(thisNote);
    key.root + key.scale[i] + bass.octave * 12 => thisNote;
    bass.setNote(thisNote);
    
    // random duration between 1/16- and 1/4-note
    (sixteenthsPerMeasure / 2) - (j % (sixteenthsPerMeasure / 2)) => int leave;
    Math.min(longestNote, leave) $ int => int maxDur; // $ casts float to int
    Math.random2(1, maxDur) => int duration;
    j + duration => j;
    
    bass.playNote(tempo.eighthNote * duration);
    
    // randomly step 0 to 3 positions up or down the scale.
    i + Math.random2(-stepSize,stepSize) => i;
    
    // if you stepped off the scale, jump up or down an octave to get back on
    //if( i < 0 ) i + 7 => i;
    if(i < 0) {
        key.scale.cap() +=> i;
        bass.changeOctave(-1);
    } else if( i >= key.scale.cap()){
        key.scale.cap() -=> i;
        bass.changeOctave(1);
    }
}

