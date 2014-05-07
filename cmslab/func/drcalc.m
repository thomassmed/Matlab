function [drfd,th]=drcalc(x,fs)
% [drfd,th]=drcalc(x,fs)
%
% Calculates the dacay-ratios for an [4 3]  
% 
% dfrf(:,1) = deacay-ratios
% drf2(:,2) = frequencies [Hz]
% th is the theta-format model description
% 
x=dtrend(x,1);

if fs>10 x=decimate(x,2);fs=fs/2;end
th=armax(x,[4 3],1,-1,-1,-1,fs);
[ze,po]=getzp(th2zp(th),0);
po=po;
[mag,wn,z]=ddamp(po,1/fs);
drfd(:,1)=z2dr(z);
drfd(:,2)=wn/2/pi;
