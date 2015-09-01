// "lead.ck"

// walking lead line
BPM tempo;
Level level;
Key key;
Lead lead;

[0, 2, 3] @=> int roots[];
tempo.meter * 4 => int sixteenthsPerMeasure;

2 => int stepSize;
[0.99,0.2,0.5,0.3,0.7,0.2,0.4,0.6] @=> float rhythm[];

spork ~ lead.updateLevel(level);

// start at a random place in the scale
Math.random2(0,key.scale.cap()-1) => int i;
0 => int j;
while( true ) {
    if (Math.random2f(0.0, 1.0) < rhythm[j % rhythm.cap()]) {
        if (j % sixteenthsPerMeasure == 0) {
            roots[Math.random2(0, roots.cap() - 1)] => i;
        } else {
            // randomly step 0 to 3 positions up or down the scale.
            i + Math.random2(-stepSize,stepSize) => i;
        }
        
        // if you stepped off the scale, jump up or down an octave to get back on
        if(i < 0) {
            key.scale.cap() +=> i;
            lead.changeOctave(-1);
        } else if( i >= key.scale.cap()){
            key.scale.cap() -=> i;
            lead.changeOctave(1);
        }
        
        0 => int thisTonality;
        if ((i == 2 || i == 5) && key.tonality == -1) {
            -1 => thisTonality;
        }
        key.root + key.scale[i] + lead.octave * 12  + thisTonality => int thisNote;
        lead.correctOctave(thisNote);
        key.root + key.scale[i] + lead.octave * 12 + thisTonality => thisNote;
        lead.setNote(thisNote);
        lead.playNote(tempo.sixteenthNote);
    } else {
        lead.holdNote(tempo.sixteenthNote);
    }
    1 +=> j;
}
