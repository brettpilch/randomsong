import wave

w = wave.open('808_clap.wav', 'r')
print w.getnchannels()
print w.getsampwidth()
print w.getframerate()
print w.getnframes()
print w.getcompname()

print w.getparams()
w.rewind()
print w.readframes(w.getnframes())
