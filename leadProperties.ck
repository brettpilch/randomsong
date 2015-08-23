public class Lead {
    Level level;
    // sound chain
    Pan2 master => dac;
    SawOsc bass => ADSR env => Chorus chorus => NRev reverb => master;
    PulseOsc bass2 => env;
    
    // globals
    0.01 => bass.gain;
    0.01 => bass2.gain;
    0.1 => bass2.width;
    10.0 => chorus.modFreq;
    0.005 => chorus.modDepth;
    1.0 => chorus.mix;
    level.leadReverb => reverb.mix;
    level.leadPanning => master.pan;
    1 => int octave;
    12 => int interval;
    56 => int minNote;
    90 => int maxNote;
    (0.01::second, 0.2::second, 0.5, 0.01::second) => env.set;
    
    fun void updateLevel(Level level) {// uses public Level class to update gain from score.ck
        while( true )
        {
            level.masterGain * level.leadGain => master.gain;
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