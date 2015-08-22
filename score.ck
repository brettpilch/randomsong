// score.ck
// on the fly drumming with global BPM conducting
//add tracks:

//add classes to control tempo, levels, and key:
BPM tempo;
tempo.tempo(100);
Level level;
Key key;
key.setKey("C");
Bass bass;

Machine.add(me.dir()+"/setlevels.ck") => int levelsID;

//spork ~ printLevel();

Machine.add(me.dir()+"/chords.ck") => int chordsID;
Machine.add(me.dir()+"/concur-3.ck") => int concurID;
level.fadeMasterTo(1.0, tempo.SPB * 8);

Machine.add(me.dir()+"/randomDrums.ck") => int drumsID;
level.setDrumsLevel(0.3);
16 * tempo.quarterNote => now;

Machine.add(me.dir()+"/bass.ck") => int bassID;
level.setBassLevel(1.3);
16 * tempo.quarterNote => now;

Machine.add(me.dir()+"/lead.ck") => int leadID;
level.setLeadLevel(1.2);
32 * tempo.quarterNote => now;

level.fadeDrumsTo(0.0, tempo.SPB * 8);

level.fadeMasterTo(0.0, tempo.SPB * 16);

Machine.remove(drumsID);
Machine.remove(concurID);
Machine.remove(bassID);
Machine.remove(leadID);
Machine.remove(levelsID);
Machine.remove(chordsID);

fun void printLevel()
{// uses public Level class to print master level.
    while( true )
    {
        <<<level.masterGain, level.drumsGain>>>;
        tempo.quarterNote => now;
    }
}