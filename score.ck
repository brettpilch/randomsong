// score.ck
// on the fly drumming with global BPM conducting
//add tracks:

//add classes to control tempo, levels, and key:
BPM tempo;
tempo.setTempo(Math.random2f(80, 120));

[4] @=> int meterChoices[];
tempo.setMeter(meterChoices[Math.random2(0, meterChoices.cap() - 1)]);

[0.0, 0.5] @=> float shuffleChoices[];
tempo.setShuffle(shuffleChoices[Math.random2(0, shuffleChoices.cap() - 1)]);
1 => int sectionAdjust;
if (tempo.meter < 3) {
    2 => sectionAdjust;
}
if (tempo.meter < 2) {
    4 => sectionAdjust;
}
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
<<<"key:", thisKey + thisAccidental + thisTonality, "tempo:", tempo.tempo,
   "meter:", tempo.meter, " / 4", "shuffle:", tempo.shuffle>>>;

Machine.add(me.dir()+"/setlevels.ck");

spork ~ printLevel();

Machine.add(me.dir()+"/chords.ck") => int chordsID;
Machine.add(me.dir()+"/concur-3.ck") => int concurID;
level.fadeMasterTo(8.0, tempo.SPB * tempo.meter * sectionAdjust * 2);

Machine.add(me.dir()+"/randomDrums.ck") => int drumsID;
level.setDrumsLevel(0.2);
tempo.advance(4 * sectionAdjust);

Machine.add(me.dir()+"/bass.ck") => int bassID;
level.setBassLevel(1.2);
tempo.advance(4 * sectionAdjust);

Machine.add(me.dir()+"/lead.ck") => int leadID;
level.setLeadLevel(1.75);
tempo.advance(12 * sectionAdjust);

level.fadeMasterTo(0.0, tempo.SPB * tempo.meter * 4);

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
        if (v % (tempo.meter * 2) == 0) {
            <<<" MASTER ", " MODAL  ", " CHORDS ", " DRUMS  ", "  BASS  ", "  LEAD  ">>>;
        }
        <<<level.masterGain, level.modalGain, level.chordsGain,
        level.drumsGain, level.bassGain, level.leadGain>>>;
        tempo.quarterNote => now;
        v++;
    }
}