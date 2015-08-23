// score.ck
// on the fly drumming with global BPM conducting
//add tracks:

//add classes to control tempo, levels, and key:
BPM tempo;
tempo.tempo(Math.random2f(80, 120));
Level level;
Key key;
["A", "B", "C", "D", "E", "F", "G"] @=> string keys[];
["b", "#", ""] @=> string accidentals[];
["m", ""] @=> string tonalities[];

fun string getRandom(string array[]) {
    Math.random2(0, array.cap() - 1) => int choice;
    return array[choice];
}
getRandom(keys) => string thisKey;
getRandom(accidentals) => string thisAccidental;
getRandom(tonalities) => string thisTonality;
key.setKey(thisKey + thisAccidental + thisTonality);
<<<thisKey + thisAccidental + thisTonality>>>;
<<<key.root, key.scale[2]>>>;

Machine.add(me.dir()+"/setlevels.ck");

spork ~ printLevel();

Machine.add(me.dir()+"/chords.ck") => int chordsID;
Machine.add(me.dir()+"/concur-3.ck") => int concurID;
level.fadeMasterTo(8.0, tempo.SPB * 8);

Machine.add(me.dir()+"/randomDrums.ck") => int drumsID;
level.setDrumsLevel(0.23);
16 * tempo.quarterNote => now;

Machine.add(me.dir()+"/bass.ck") => int bassID;
level.setBassLevel(1.3);
16 * tempo.quarterNote => now;

Machine.add(me.dir()+"/lead.ck") => int leadID;
level.setLeadLevel(1.5);
32 * tempo.quarterNote => now;

level.fadeDrumsTo(0.0, tempo.SPB * 8);

level.fadeMasterTo(0.0, tempo.SPB * 16);

Machine.remove(drumsID);
Machine.remove(concurID);
Machine.remove(bassID);
Machine.remove(leadID);
Machine.remove(chordsID);

fun void printLevel()
{// uses public Level class to print master level.
    0 => int v;
    while( true )
    {
        if (v % 10 == 0) {
            <<<" MASTER ", " MODAL  ", " CHORDS ", " DRUMS  ", "  BASS  ", "  LEAD  ">>>;
        }
        <<<level.masterGain, level.modalGain, level.chordsGain,
        level.drumsGain, level.bassGain, level.leadGain>>>;
        tempo.quarterNote => now;
        v++;
    }
}