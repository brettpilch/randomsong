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
    -1 => int octave;
    0 => int interval;
    36 => int minNote;
    60 => int maxNote;
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
    
    fun void playNote(dur duration, int beat, float shuffle) {
        1 => env.keyOff;
        1 => env.keyOn;
        dur adjustment;
        if (beat % 2 == 0) {
            shuffle * duration * 0.5 => adjustment;
        } else {
            -shuffle * duration * 0.5 => adjustment;
        }
        duration + adjustment => now;
    }
    
    fun void holdNote(dur duration, int beat, float shuffle) {
        dur adjustment;
        if (beat % 2 == 0) {
            shuffle * duration * 0.5 => adjustment;
        } else {
            -shuffle * duration * 0.5 => adjustment;
        }
        duration + adjustment => now;
    }
}