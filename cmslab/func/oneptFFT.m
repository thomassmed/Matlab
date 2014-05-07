function [Go,Gc,FP,FPbv,i1]=oneptFFT(data,f)
% [Go,Gc,Y,Yref]=oneptFFT(data,f)
%
% Input:
%   data - matrix with columns data=[t yref y]
%   f    - Frequency (in Hz)
%
% Output:
%   Go   - Open system transfer funcion. If applicable, Go=Gc/(1-Gc)
%   Gc   - Plain transfer function from yref tioo y (=Y/Yref)
%   Y    - Complex amplitude of sine portion of y (y(sinus) = real(Y*exp(2*pi*f*1j*t))
%   Yref - Complex amplitude of sine portion of yref (yref(sinus) = real(Yref*exp(2*pi*f*1j*t))
%
% Example:
% ds=ReadMatdataFil('Varmaprov_2013-03-21_05_000.dat');
% [Go,Gc,Y,Yref]=oneptFFT(ds.data(:,[1 99 2]),30e-3)
%
% See also ioneptFFT

% At first, this function was specifically written for Varmaprov
filename=data;
if ischar(filename),
    ds=ReadMatdataFil(filename);
    Pbv=ds.data(:,99);
    t=ds.data(:,1);
    P=ds.data(:,2);
    Pbv=Pbv-mean(Pbv(1:10));
    i1=find(abs(Pbv)>0.1,1,'first');
    slut=max(i1-100,2);
    P=P-mean(P(1:slut));
else
    t=filename(:,1);
    Pbv=detrend(filename(:,2),0);
    P=detrend(filename(:,3),0);
    i1=1;
end
i2=length(Pbv);
test=exp(1j*2*pi*f*t);
test=test(i1:i2);
FPbv=2*test'*Pbv(i1:i2)/length(test);
FP=2*test'*P(i1:i2)/length(test);
Gc=FP/FPbv;
Go=Gc/(1-Gc);



