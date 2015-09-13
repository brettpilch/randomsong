// Chord Properties

public class Chords {
    Level level;
    // sound chain
    Pan2 master => dac;
    VoicForm voices[4];
    Pan2 voicesp[4];
    ADSR voiceEnv[4];
    NRev reverb[4];
    -1 => int octave;
    
    for( 0 => int i; i < voices.cap(); i++ )
    {
        // complete the sound chain for all voices
        voices[i] => voiceEnv[i] => reverb[i] => voicesp[i] => master;
        // set the gain, envelope, and panning of all voices.
        (0.95 / voices.cap()) => voices[i].gain;
        ( 2::second, 2::second, 0.1, 0.1::second ) => voiceEnv[i].set;
        -0.99 + 0.66*i => voicesp[i].pan; // each panned differently
        level.chordsReverb => reverb[i].mix;
        11 => voices[i].phonemeNum;
    }
    
    fun void setNotes(int notes[])
    {// set the frequency of each voice according to the given notes
        for (0 => int i; i < notes.cap(); i++) {
            Std.mtof(notes[i] + 12 * octave) => voices[i].freq;
        }
    }
    
    fun void keyOn() {
        for (0 => int i; i < voiceEnv.cap(); i++) {
            1 => voiceEnv[i].keyOn;
        }
    }
    
    fun void keyOff() {
        for (0 => int i; i < voiceEnv.cap(); i++) {
            1 => voiceEnv[i].keyOff;
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
}
