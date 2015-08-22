// "bass.ck"

// walking bass line
BPM tempo;
Level level;
Key key;

// sound chain
Pan2 master => dac;
SinOsc mod => PulseOsc bass => ADSR bassEnv => master;
SinOsc bass2 => bassEnv;

// globals
0.2 => bass.width;
0.01 => bass.gain;
0.07 => bass2.gain;
10 => mod.gain;
500 => mod.freq;
2 => bass.sync;

key.setKey("C");
-2 => int octave;
32 => int minNote;
56 => int maxNote;

//3 => int stepSize; //original
2 => int stepSize;
(0.01::second, 0.2::second, 0.0, 0.2::second) => bassEnv.set; // punchy bass envelope
[43,45,47,48,50,52,53,55,57,59,60] @=> int notes[]; //major
//[43,44,47,48,50,51,53,55,56,59,60] @=> int notes[]; //minor
//[43,46,48,51,53,54,55,58,60] @=> int notes[]; //blues
//[43,46,47,48,51,52,54,55,58,59,60] @=> int notes[]; //harmonic major


fun void updateLevel()
{// uses public Level class to update gain from score.ck
    while( true )
    {
        level.masterGain * level.bassGain => master.gain;
        0.02::second => now;
    }
}

spork ~ updateLevel();

// start at a random place in the scale
//Math.random2(0,notes.cap()-1) => int i;
Math.random2(0,key.scale.cap()-1) => int i;
0 => int j;
//[3, 6, 7, 10] @=> int roots[];
[0, 2, 3] @=> int roots[];
while( true )
{
    // play the selected note in the scale
    if (j % 16 == 0) {
        roots[Math.random2(0, roots.cap() - 1)] => i;
    }
    key.root + key.scale[i] + octave * 12 => int thisNote;
    if (thisNote < minNote){
        1 +=> octave;
    } else if (thisNote > maxNote){
        1 -=> octave;
    }
    key.root + key.scale[i] + octave * 12 => thisNote;
    Std.mtof(thisNote) => bass.freq;
    Std.mtof(thisNote) => bass2.freq;
    
    // random duration between 1/16- and 1/4-note
    16 - (j % 16) => int leave;
    Math.min(2, leave) $ int => int maxDur; // $ casts float to int
    Math.random2(1, maxDur) => int duration;
    j + duration => j;
    
    1 => bassEnv.keyOn;
    tempo.sixteenthNote * duration => now;
    
    // randomly step 0 to 3 positions up or down the scale.
    i + Math.random2(-stepSize,stepSize) => i;
    
    // if you stepped off the scale, jump up or down an octave to get back on
    //if( i < 0 ) i + 7 => i;
    if(i < 0) {
        key.scale.cap() +=> i;
        1 -=> octave;
    } else if( i >= key.scale.cap()){
        key.scale.cap() -=> i;
        1 +=> octave;
    }
}

