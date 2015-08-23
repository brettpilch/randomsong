BPM tempo;
Level level;
tempo.sixteenthNote => dur sixteenthNote;
tempo.eighthNote => dur eighthNote;
tempo.quarterNote => dur quarterNote;
// sound chain (left)
//ModalBar modal => NRev reverbL => dac.left;
SinOsc modal => ADSR env => NRev reverbL => dac.left;
env.set(0.02, 0.02, 0.2, 0.02);
level.masterGain * level.modalGain => modal.gain;
// set reverb mix
level.modalReverb => reverbL.mix;
// modal bar parameters
//7 => modal.preset;
//.9 => modal.strikePosition;

// another sound chain (right)
//ModalBar modal2 => NRev reverbR => dac.right;
SinOsc modal2 => ADSR env2 => NRev reverbR => dac.right;
level.masterGain * level.modal2Gain => modal2.gain;
env2.set(0.02, 0.02, 0.2, 0.02);
// set reverb mix
level.modal2Reverb => reverbR.mix;
// modal bar parameters
//4 => modal2.preset;
//.9 => modal.strikePosition;

// spork off 3 shreds using functions
spork ~ updateLevel();
spork ~ detune();
spork ~ one();
spork ~ two();

// keep the main shred going (so child shreds don't stop)
while( true ) 1::second => now;

// rhythm 1
fun void one()
{
    // infinite loop
    while( true )
    {
        // note!
        //1 => modal.strike;
        // wait
        env.keyOn();
        eighthNote => now;
        env.keyOff();
        // note!
        //.7 => modal.strike;
        // wait
        env.keyOn();
        eighthNote => now;
        env.keyOff();
        // repeat 6 times
        repeat( 6 )
        {
            // note!
            //.5 => modal.strike;
            // wait
            env.keyOn();
            eighthNote / 3 => now;
            env.keyOff();
        }
    }
}

// rhythm 2
fun void two()
{
    // infinite loop
    while( true )
    {
        // wait! (offset to cause phasing)
        //env2.keyOn();
        sixteenthNote => now;
        //env2.keyOff();
        // note!
        //1 => modal2.strike;
        // wait
        env2.keyOn();
        eighthNote => now;
        env2.keyOff();
        // note!
        //.75 => modal2.strike;
        // wait
        env2.keyOn();
        eighthNote => now;
        env2.keyOff();
        // note!
        //.5 => modal2.strike;
        // wait
        env2.keyOn();
        eighthNote => now;
        env2.keyOff();
        // note!
        //.25 => modal2.strike;
        // wait
        env2.keyOn();
        eighthNote => now;
        env2.keyOff();
    }
}

// detuning (both modalbars)
fun void detune()
{
    // infinite loop
    while( true )
    {
        // update modal bar 1 resonances
        Math.random2(75, 78) => int left;
        Math.random2(74, 77) => int right;
        //65 => left;
        //64 => right;
        left + Math.sin(now/second*.25*Math.PI) * 3 => Std.mtof => modal.freq;
        // update modal bar 2 resonances
        right + Math.sin(now/second*.15*Math.PI) * 5 => Std.mtof => modal2.freq;
        50::ms => now;
    }
}

fun void updateLevel()
{// uses public Level class to update gain from score.ck
    while( true )
    {
        level.masterGain * level.modalGain => modal.gain;
        level.masterGain * level.modal2Gain => modal2.gain;
        0.01::second => now;
    }
}

