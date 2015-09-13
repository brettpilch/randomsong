// BPM.ck
// global BPM conductor Class
public class BPM
{
    // global variables
    dur myDuration[4];
    static float SPB;
    static dur quarterNote, eighthNote, sixteenthNote, thirtysecondNote;
    static int meter;
    static float tempo;
    static float shuffle;
    
    fun void setTempo(float beat)  {
        // beat is BPM, example 120 beats per minute
        beat => this.tempo;
        60.0/(beat) => SPB; // seconds per beat
        SPB :: second => quarterNote;
        quarterNote*0.5 => eighthNote;
        eighthNote*0.5 => sixteenthNote;
        sixteenthNote*0.5 => thirtysecondNote;
        
        // store data in array
        [quarterNote, eighthNote, sixteenthNote, thirtysecondNote] @=> myDuration;
    }
    
    fun void setMeter(int beatsPerMeasure) {
        beatsPerMeasure => this.meter;
    }
    
    fun void setShuffle(float amount) {
        amount => this.shuffle;
    }
    
    fun void advance(int measures) {
        quarterNote * meter * measures => now;
    }
    
    fun void fade(float num, float secs) {
        (num - this.tempo) / (1000 * secs) => float increment;
        while (Std.fabs(this.tempo - num) > Std.fabs(increment)) {
            this.setTempo(increment + this.tempo);
            0.001::second => now;
        }
        num => this.tempo;
    }
}

