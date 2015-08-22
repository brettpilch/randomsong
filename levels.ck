// "randomConcur"

// levels

// a public class used to automate track levels in score.ck

public class Level
{// initialize all levels to 1.0
    static float masterGain;
    static float modalGain;
    static float modal2Gain;
    static float kickGain;
    static float hatGain;
    static float snareGain; 
    static float drumsGain;
    static float bassGain;
    static float leadGain;
    static float chordsGain;
    
    static float modalReverb;
    static float modal2Reverb;
    
    fun void fadeMasterTo(float num, float secs) {
        (num - this.masterGain) / (1000 * secs) => float increment; 
        while (Std.fabs(this.masterGain - num) > Std.fabs(increment)) {
            this.masterGain + increment => this.masterGain;
            0.001::second => now;
        }
        num => this.masterGain;
    }
    
    fun void fadeDrumsTo(float num, float secs) {
        (num - this.drumsGain) / (1000 * secs) => float increment; 
        while (Std.fabs(this.drumsGain - num) > Std.fabs(increment)) {
            this.drumsGain + increment => this.drumsGain;
            0.001::second => now;
        }
        num => this.drumsGain;
    }
    
    fun void setDrumsLevel(float num) {
        num => this.drumsGain;
    }
    
    fun void setMasterLevel(float num) {
        num => this.masterGain;
    }
    
    fun void setModalLevel(float num) {
        num => this.modalGain;
    }
    
    fun void setModal2Level(float num) {
        num => this.modal2Gain;
    }
    
    fun void setBassLevel(float num) {
        num => this.bassGain;
    }
    
    fun void setLeadLevel(float num) {
        num => this.leadGain;
    }
    
    fun void setChordsLevel(float num) {
        num => this.chordsGain;
    }
    
    fun void setModalReverb(float num) {
        num => this.modalReverb;
    }
    
    fun void setModal2Reverb(float num) {
        num => this.modal2Reverb;
    }
    
}
    