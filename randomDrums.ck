// sound chain
BPM tempo;
Level level;
Pan2 master => NRev reverb => dac;
SndBuf kick, snare, hat;
// master fader level:
7.0 => float masterC;
level.drumsReverb => reverb.mix;

class Sound
{
    SndBuf sound;
    Pan2 panning;
    sound => panning => master;
    string soundfiles[];
    float thislevel;
    float pattern[];
    float gains[][];
    
    fun void construct(SndBuf some_sound, string some_files[], float some_level,
    float some_pattern[], float some_gains[][], float some_panning)
    {
        some_sound => sound;
        some_files @=> soundfiles;
        some_level => thislevel;
        some_pattern @=> pattern;
        some_gains @=> gains;
        some_panning => panning.pan;
    }
    
    fun void set_file(string some_file)
    {
        some_file => sound.read;
    }
    
    fun void set_pos(int some_pos)
    {
        some_pos => sound.pos;
    }
    
    fun void set_gain(float some_gain)
    {
        some_gain => sound.gain;
    }
    
    fun void set_rate(float some_rate)
    {
        some_rate => sound.rate;
    }
    
    fun void play(dur duration)
    {// play Sndbuf in a given pattern using specified duration
        0 => int i;
        while( true )
        {// play drum sound if random2 is less than the value of the current beat in the pattern.
            if( Math.random2f(0,1) < pattern[i % pattern.cap()] )
            {
                Math.random2(0,soundfiles.cap()-1) => int choice;
                set_file(me.dir() + "/audio/808_" + soundfiles[choice] + ".wav");
                set_pos(0);
                
                // set volume randomly between given lower and upper bounds.
                gains[i % gains.cap()][0] => float low;
                gains[i % gains.cap()][1] => float high;
                set_gain(Math.random2f(low,high) * thislevel * masterC);
                //set_rate(Math.random2f(0.8,1.3));
            }
            duration => now;
            1 + i => i;
        }
    }
    
    fun void oscillate_rate(dur duration, float amount, float offset)
    {
        0 => int iter;
        while( true )
        {
            Math.sin(iter / 100.0) * amount + 1 + offset => sound.rate;
            iter++;
            duration => now;
        }
    }
}

fun void updateLevel()
{// uses public Level class to update gain from score.ck
    while( true )
    {
        level.masterGain * level.drumsGain => master.gain;
        0.01::second => now;
    }
}

// sound file lists:
["kick2"] @=> string kickFiles[];
["maracas", "hihat", "maracas", "clave", "rimshot"] @=> string hatFiles[];
//["clave"] @=> string hatFiles[];
//["snare1", "snare2", "snare1", "snare1"] @=> string snareFiles[];
["snare1"] @=> string snareFiles[];

// fader levels
1.0 => float kickC;
1.1 => float hatC;
0.8 => float snareC;

// globals
tempo.quarterNote => dur quarter;
0.3 => float hatp;
-0.3 => float snarep;
0.0 => float kickp;

// Probabilistic drum patterns:
// the numbers determine probability of a note being played on each beat
// to create a pattern that is only partially random.
// change these numbers to create different patterns.
[.9,.05,.95,.05] @=> float hat0[];
[.86,.15,.39,.21,.03,.18,.39,.3] @=> float kick0[];
[.02,.38,.04,.15,.96,.15,.03,.37] @=> float snare0[];

// Upper and lower bounds for randomly selected gain on each beat:
[[.12,.24],[.02,.06],[.06,.14],[.02,.06]] @=> float hatGains[][];
[[.4,.6],[.1,.2],[.3,.5],[.1,.3],[.4,.6],[.1,.2],[.3,.5],[.1,.3]] @=> float kickGains[][];
[[.2,.3],[.05,.15],[.2,.3],[.05,.15],[.25,.35],[.05,.15],[.1,.2],[.05,.15]] @=> float snareGains[][];

if (tempo.meter == 3) {
    [.25,.05,.75,.05,.75,.05] @=> hat0;
    [.99,.15,.21,.21,.01,.18] @=> kick0;
    [.01,.38,.69,.15,.99,.15] @=> snare0;
    
    [[.06,.14],[.02,.06],[.12,.24],[.02,.06],[.12,.24],[.02,.06]] @=> hatGains;
    [[.4,.6],[.1,.2],[.3,.5],[.1,.3],[.3,.5],[.1,.3]] @=> kickGains;
    [[.2,.3],[.05,.15],[.25,.35],[.05,.15],[.25,.35],[.05,.15]] @=> snareGains;
} else if (tempo.meter == 6) {
    [.25,.05,.75,.05,.75,.05,.25,.05,.75,.05,.75,.05] @=> hat0;
    [.99,.15,.39,.21,.33,.21,.01,.18,.39,.21,.39,.3] @=> kick0;
    [.01,.38,.04,.15,.06,.15,.99,.15,.03,.15,.03,.37] @=> snare0;
    
    [[.06,.14],[.02,.06],[.12,.24],[.02,.06],[.12,.24],[.02,.06]] @=> hatGains;
    [[.4,.6],[.1,.2],[.3,.5],[.1,.3],[.3,.5],[.1,.3]] @=> kickGains;
    [[.25,.35],[.05,.15],[.2,.3],[.05,.15],[.2,.3],[.05,.15]] @=> snareGains;
}

Sound Kick, Snare, Hat;

Kick.construct(kick, kickFiles, kickC, kick0, kickGains, kickp);
Snare.construct(snare, snareFiles, snareC, snare0, snareGains, snarep);
Hat.construct(hat, hatFiles, hatC, hat0, hatGains, hatp);

// spork all child drum tracks to play concurrently
spork ~ updateLevel();
spork ~ Snare.oscillate_rate(15::ms, 0.2, 0.2);
spork ~ Hat.oscillate_rate(9::ms, 0.2, 0.0);
spork ~ Kick.play(quarter/4);
spork ~ Snare.play(quarter/4);
spork ~ Hat.play(quarter/4);

while (true) {
    1::second => now;
}
