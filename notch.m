function [b,a]=notch(Fs, BW, fc, dbGain)
%Fs - sampling frequency
%BW - bandwidth
%fc - center frequency, "where it's happenin'"
%dbGain - gain level

A = 10^(dbGain/40); %amplitude
alpha = sin(2*pi*fc/Fs)*sinh(log(2)/2 * BW * (2*pi*fc/Fs)/sin(2*pi*fc/Fs));

%filter coefficients derived from transfer function of notch filter
b0 =   1;
b1 =  -2*cos(2*pi*fc/Fs);
b2 =   1;
a0 =   1 + alpha;
a1 =  -2*cos(2*pi*fc/Fs);
a2 =   1 - alpha;

%combining coefficients into an array
b = [b0, b1, b2];
a = [a0, a1, a2];

end