// "bass.ck"

// walking bass line
BPM tempo;
Level level;
Key key;
Bass bass;

[0, 2, 3] @=> int roots[];
2 => int longestNote;
tempo.meter * 4 => int sixteenthsPerMeasure;

//3 => int stepSize; //original
2 => int stepSize;
[43,45,47,48,50,52,53,55,57,59,60] @=> int notes[]; //major
//[43,44,47,48,50,51,53,55,56,59,60] @=> int notes[]; //minor
//[43,46,48,51,53,54,55,58,60] @=> int notes[]; //blues
//[43,46,47,48,51,52,54,55,58,59,60] @=> int notes[]; //harmonic major

spork ~ bass.updateLevel(level);

// start at a random place in the scale
//Math.random2(0,notes.cap()-1) => int i;
Math.random2(0,key.scale.cap()-1) => int i;
0 => int j;
while( true )
{
    // play the selected note in the scale
    if (j % sixteenthsPerMeasure == 0) {
        roots[Math.random2(0, roots.cap() - 1)] => i;
    }
    0 => int thisTonality;
    if ((i == 2 || i == 5) && key.tonality == -1) {
        -1 => thisTonality;
    }
    key.root + key.scale[i] + bass.octave * 12  + thisTonality => int thisNote;
    bass.correctOctave(thisNote);
    key.root + key.scale[i] + bass.octave * 12 + thisTonality => thisNote;
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

