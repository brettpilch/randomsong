public class Key
{
    [57,59,60,62,64,65,67] @=> static int midiNoteNums[];
    static int root;
    [0,2,4,5,7,9,11] @=> static int scale[];
    
    fun void setKey(string k) { //Abm = Ab minor, etc...
        k.charAt(0) - 'A'$int => int index;
        midiNoteNums[index] => this.root;
        if (k.length() == 2) {
            k.charAt(1) => int two;
            if (two - 'b'$int == 0 || two - 'f'$int == 0){
                1 -=> this.root;
            } else if (two - '#'$int == 0 || two - 's'$int == 0) {
                1 +=> this.root;
            } else if (two == 'm') {
                1 -=> scale[2];
                1 -=> scale[5];
            }
        } else if (k.length() == 3) {
            k.charAt(2) => int three;
            if (three - 'm'$int == 0) {
                1 -=> scale[2];
                1 -=> scale[5];
            }
        }
    }
}
