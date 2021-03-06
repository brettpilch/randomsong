// "lead.ck"

// walking lead line
BPM tempo;
Level level;
Key key;
Lead lead;
Progression progression;

[0, 3, 4] @=> int roots[];
tempo.meter * 4 => int sixteenthsPerMeasure;

2 => int stepSize;
[0.99,0.2,0.5,0.3,0.7,0.2,0.4,0.6] @=> float rhythm[];

spork ~ lead.updateLevel(level);

// start at a random place in the scale
Math.random2(0,key.scale.cap()-1) => int i;
0 => int j;
0 => int k;
while( true ) {
    if (Math.random2f(0.0, 1.0) < rhythm[j % rhythm.cap()]) {
        if (progression.useProgression) {
            progression.noteProbs[k % progression.noteProbs.cap()] @=> float noteProbs[];
            Math.random2f(0.0, 1.0) => float randy;
            for (0 => int m; m < noteProbs.cap(); 1 +=> m) {
                if (randy < noteProbs[m]) {
                    m => i;
                    break;
                }
            }
            //chord[Math.random2(0, chord.cap() - 1)] => i;
        } else if (j % sixteenthsPerMeasure == 0) {
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
        lead.playNote(tempo.sixteenthNote, j, tempo.shuffle);
    } else {
        lead.holdNote(tempo.sixteenthNote, j, tempo.shuffle);
    }
    1 +=> j;
    if (j % 8 == 0) {
        1 +=> k;
    }
}
