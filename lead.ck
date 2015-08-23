// "bass.ck"

// walking bass line
BPM tempo;
Level level;
Key key;
Lead lead;

[0, 2, 3] @=> int roots[];
4 => int longestNote;

2 => int stepSize;
[43,45,47,48,50,52,53,55,57,59,60] @=> int notes[]; //major
//[43,44,47,48,50,51,53,55,56,59,60] @=> int notes[]; //minor
//[43,46,48,51,53,54,55,58,60] @=> int notes[]; //blues
//[43,46,47,48,51,52,54,55,58,59,60] @=> int notes[]; //harmonic major

spork ~ lead.updateLevel(level);

// start at a random place in the scale
Math.random2(0,key.scale.cap()-1) => int i;
0 => int j;
while( true )
{
    // play the selected note in the scale
    if (j % 16 == 0) {
        roots[Math.random2(0, roots.cap() - 1)] => i;
    }
    key.root + key.scale[i] + lead.octave * 12 => int thisNote;
    lead.correctOctave(thisNote);
    key.root + key.scale[i] + lead.octave * 12 => thisNote;
    lead.setNote(thisNote);
    
    8 - (j % 8) => int leave;
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
