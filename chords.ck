// "Assignment 7: Soletelos"

// Chords
BPM tempo;
Key key;
Chords chordProperties;

// 2D array is a list of different chord types.
// each chord is a list of the intervals in that chord.
[ [0,2,4,5], [0,2,4,6], [0,2,4,7], [0,2,4,8] ] @=> int chords[][];
[1.0, 0.0, 0.0, 0.0] @=> float rhythm[];

fun int[] getNotes(int chord[], int root)
{// given a chord type and root note, return the notes in the chord
    int notes[chord.cap()];
    for (0 => int i; i < chord.cap(); i++) {
        0 => int thisOctave;
        if (root + chord[i] > key.scale.cap() - 1) {
            1 +=> thisOctave;
            if (root + chord[i] > key.scale.cap() * 2 - 1) {
                1 +=> thisOctave;
            }
        }
        0 => int thisTonality;
        (root + chord[i]) % key.scale.cap() => int index;
        if ((index == 2 || index == 5) && key.tonality == -1) {
            -1 => thisTonality;
        }
        key.root + key.scale[(root + chord[i]) % key.scale.cap()] => int thisNote;
        12 * thisOctave + thisTonality +=> thisNote;
        thisNote => notes[i];
    }
    return notes;
}

spork ~ chordProperties.updateLevel();

0 => int j;
while( true )
{
    if (Math.random2f(0.0, 1.0) < rhythm[j % rhythm.cap()]) {// play a new chord
        chordProperties.keyOff();
        // select a random chord type
        Math.random2(0,chords.cap() - 1) => int which;
        chords[which] @=> int chord[];
        // select a random root note
        Math.random2(0, key.scale.cap() - 1) => int root;
        // set voice freqs according to root and chord type.
        getNotes(chord, root) @=> int notes[];
        chordProperties.setNotes(notes);
        chordProperties.keyOn();
    }
    // advance time 1 quarter-note
    tempo.quarterNote => now;
    1 +=> j;
}
