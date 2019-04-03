%read in the audio file and convert to mono
song_stereo = audioread('Test_Guitar.wav');
song = (song_stereo(:,1)+song_stereo(:,1))/2;

%designing the LFO to operate between a low and high frequency 
Fs = 44100;
i=0;
index=0;
f_high = 1000;
f_low = 100;
w_lfo = 2*pi*5; %resolution of LFO
T = 1/Fs;
t = 0:T:length(song)/Fs;
fc = (f_high-f_low)/2 * sin(w_lfo*t) + ((f_high+f_low)/2); %calculation of fc

%plot LFO
% plot(t, fc);
% title('Low Frequency Oscillator');
% xlabel('Time');
% ylabel('Frequency');

%initializing variables that represent the first two delays of the input
%and output in the difference equation below
x1=0;
x2=0;
y1=0;
y2=0;

clear('F')
%for loop to cycle through the signal and vary the frequency depending on the rate set using fc
for n = 1:1000:length(song)*700/Fs
    %function call to set the filter coefficients that are derived from the
    %transfer function
    [b,a]=notch(44100, 1, fc(n), 10);
    
    %graph the notch filter moving between 100 and 1000
    figure(2);
    [H, F] = freqz(b,a,20000,Fs);
    subplot(2,1,1)
    semilogx(F,20*log10(abs(H)))
    axis([20 10000 -60 0]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    subplot(2,1,2)
    semilogx(F,angle(H))
    axis([20 10000 -pi pi]);
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');
    pause(0.1);

    %normalizing coefficients
    b=b./a(1);
    a=a./a(1);
    
    %difference equation for biquad filter
    %apply each coefficient and delays to the signal
    y(n) = b(1)*song(n) + b(2)*x1 + b(3)*x2 - a(2)*y1 - a(3)*y2;
    
    %reset delay values for each iteration (through each sample)
    x2 = x1;
    x1 = song(n);
    y2 = y1;
    y1 = y(n); 

end
