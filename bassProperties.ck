public class Bass {
    Level level;
    // sound chain
    Pan2 master => dac;
    SinOsc mod => PulseOsc bass => ADSR env => NRev reverb => Pan2 panning => master;
    SinOsc bass2 => env;
    
    // instrument properties
    0.3 => bass.width;
    0.01 => bass.gain;
    0.07 => bass2.gain;
    10 => mod.gain;
    500 => mod.freq;
    2 => bass.sync;
    level.bassReverb => reverb.mix;
    level.bassPanning => panning.pan;
    -2 => int octave;
    12 => int interval;
    26 => int minNote;
    50 => int maxNote;
    (0.01::second, 0.3::second, 0.1, 0.01::second) => env.set; // punchy bass envelope
    
    fun void updateLevel(Level level) {// uses public Level class to update gain from score.ck
        while( true )
        {
            level.masterGain * level.bassGain => master.gain;
            0.02::second => now;
        }
    }
    
    fun void changeOctave(int amount) {
        amount +=> octave;
    }
    
    fun void correctOctave(int note) {
        if (note < minNote){
            changeOctave(1);
        } else if (note > maxNote){
            changeOctave(-1);
        }
    }
    
    fun void setNote(int note) {
        Std.mtof(note) => bass.freq;
        Std.mtof(note + interval) => bass2.freq;
    }
    
    fun void playNote(dur duration) {
        1 => env.keyOn;
        duration => now;
        1 => env.keyOff;
    }
}