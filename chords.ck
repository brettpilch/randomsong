// "Assignment 7: Soletelos"

// Chords
BPM tempo;
Level level;

// sound chain
Pan2 master => dac;
VoicForm voices[4];
Pan2 voicesp[4];
ADSR voiceEnv[4];

for( 0 => int i; i < voices.cap(); i++ )
{
    // complete the sound chain for all voices
    voices[i] => voiceEnv[i] => voicesp[i] => master;
    // set the gain, envelope, and panning of all voices.
    (0.95 / voices.cap()) => voices[i].gain;
    ( 2::second, 2::second, 0.1, 0.1::second ) => voiceEnv[i].set;
    -0.99 + 0.66*i => voicesp[i].pan; // each panned differently
    11 => voices[i].phonemeNum;
}

// globals
[43,45,47,48,50,52,53,55,57,59,60,62,64,65,67] @=> int notes[]; //major
//[43,44,47,48,50,51,53,55,56,59,60] @=> int notes[]; //minor
//[43,46,48,51,53,54,55,58,60] @=> int notes[]; //blues
//[43,46,47,48,51,52,54,55,58,59,60,63,64,66,67] @=> int notes[]; //harmonic major

// 2D array is a list of different chord types.
// each chord is a list of the intervals in that chord.
[ [0,2,4,5], [0,2,4,6], [0,2,4,7], [0,2,4,8] ] @=> int chords[][];

fun void setVoiceFreqs(int chord[], int root)
{// set the frequency of each voice according to the given chord
    for( 0 => int i; i < chord.cap(); i++ )
    {
        1 => voiceEnv[i].keyOff;
        // root note + intervals from chord determine freq of each voice.
        Std.mtof(notes[root + chord[i]]) => voices[i].freq;
        1 => voiceEnv[i].keyOn;
    }
}

fun void updateLevel()
{// uses public Level class to update gain from score.ck
    while( true )
    {
        level.masterGain * level.chordsGain => master.gain;
        0.02::second => now;
    }
}

spork ~ updateLevel();

while( true )
{
    // select a random chord type
    Math.random2(0,chords.cap() - 1) => int which;
    chords[which] @=> int chord[];
    
    // select a random root note
    Math.random2(0,notes.cap() - 9) => int root;
    
    // set voice freqs according to root and chord type.
    setVoiceFreqs(chord, root);
    
    // random duration between 1 and 5 1/4-notes.
    tempo.quarterNote * Math.random2(1,5) => now;
}