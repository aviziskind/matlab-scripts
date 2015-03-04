function playSound(wavFilename)
    [y,Fs] = wavread(wavFilename);
    playblocking(audioplayer(y, Fs));
end