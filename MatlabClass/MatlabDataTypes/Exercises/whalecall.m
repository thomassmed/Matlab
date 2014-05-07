function [call,t,fs]=whalecall(f0,fs)
if nargin<1, 
    f0=170;
end
if ischar(f0),
    f0=str2num(f0);
end
if nargin<2,
    fs=4000;
end
if ischar(fs),
    fs=str2num(fs);
end
t = 0:1/fs:1.5;
y1 = sin(2*pi*f0*t);
y2 = sin(2*pi*2*f0*t);
y3 = sin(2*pi*3*f0*t);
y0 = y1+y2+y3;
A = (2*exp(-1.5*t)).*sin(2*pi*0.65*t);
call = A.*y0;

