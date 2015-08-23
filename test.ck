"hello" => string word;
<<<word == "hello" || word == "world">>>;
if (1){
    <<<"true">>>;
} else {
    <<<"false">>>;
}
<<<'A' $ int>>>;
"bye" => string bye;
<<<bye.charAt(0)>>>;
<<<"Bbm".charAt(0) - 'A' $ int>>>;
<<<12 % 7>>>;
float faders[0];
<<<faders["bass"]>>>;
0.5 => faders["bass"];
<<<faders["bass"]>>>;
<<<"A" + "b" + "m">>>;
while (faders["bass"] > 0) {
    0.1 -=> faders["bass"];
    <<<faders["bass"]>>>;
}
State state;
[0.4, 0.5] @=> state.states["master"];
0 => int current;
while (true) {
    Math.random2f(0.0, 1.0) => float r;
    0 => int i;
    state.states[current][i] => float sum;
    while (r > sum) {
        i++;
        state.states[current][i] +=> sum;
    }
    <<<i>>>;
    i => current;
    0.5::second => now;
}
