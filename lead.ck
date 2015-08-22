// "bass.ck"

// walking bass line
BPM tempo;
Level level;

// sound chain
Pan2 master => dac;
SawOsc bass => ADSR bassEnv => master;
PulseOsc bass2 => bassEnv;
// globals
0.01 => bass.gain;
0.01 => bass2.gain;
0.2 => bass2.width;
//3 => int stepSize; //original
2 => int stepSize;
(0.01::second, 0.2::second, 0.5, 0.01::second) => bassEnv.set; // punchy bass envelope
[43,45,47,48,50,52,53,55,57,59,60] @=> int notes[]; //major
//[43,44,47,48,50,51,53,55,56,59,60] @=> int notes[]; //minor
//[43,46,48,51,53,54,55,58,60] @=> int notes[]; //blues
//[43,46,47,48,51,52,54,55,58,59,60] @=> int notes[]; //harmonic major

// start at a random place in the scale
Math.random2(0,notes.cap()-1) => int i;

fun void updateLevel()
{// uses public Level class to update gain from score.ck
    while( true )
    {
        level.masterGain * level.leadGain => master.gain;
        0.02::second => now;
    }
}

spork ~ updateLevel();

0 => int j;
[3, 6, 7, 10] @=> int roots[];
while( true )
{
    // play the selected note in the scale
    if (j % 16 == 0) {
        roots[Math.random2(0,3)] => i;
    }
    Std.mtof(notes[i] + 24) => bass.freq;
    Std.mtof(notes[i] + 12) => bass2.freq;
    ///<<< bass.gain(), bass2.gain() >>>;
    
    8 - (j % 8) => int leave;
    Math.min(4, leave) $ int => int maxDur; // $ casts float to int
    Math.random2(1, maxDur) => int duration;
    j + duration => j;
    
    bassEnv.keyOn();
    // random duration between 1/16- and 1/4-note
    tempo.sixteenthNote * duration => now;
    
    bassEnv.keyOff();
    
    // randomly step 0 to 3 positions up or down the scale.
    i + Math.random2(-stepSize,stepSize) => i;
    
    // if you stepped off the scale, jump up or down an octave to get back on
    if( i < 0 ) i + 7 => i;
    else if( i >= notes.cap()) i - 7 => i;
}
