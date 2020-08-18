%%Adding Echo to Monotonous Sound
%It takes monotonous sound as I/P and 
%amplification and delay of echo and
%returns music after echo to sound.
function a=echo_gen(input,fs,delay,amp)
if nargin==3
    t=delay;
    delay=fs;
    amp=t;
    [input,fs]=audioread(input);
end    
k=input*amp;
if delay~=0
    z=[zeros(round(fs*delay),1);k];
    input=[input;zeros(round(fs*delay),1)];
else
    z=k;
end
a=input+z;
if max(abs(a)) > 1
    a = a./max(abs(a));
end
sound(a,fs);
end