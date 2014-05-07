function [e, fd]=timetraj2eig(xref,x,t,tmin)
% [e, fd]=timetraj2eig(xref,x,t,tmin)
%
% Calculates the right eigenvector at frequency fd according
% to the time trajectories defined by x (columns) against the
% reference xref and the time vector t from the time
% tmin to max(t). The time trajectories are interpolated to 
% vector of the sampling interval of 0.1 s. 

%Pär Lansåker, Forsmark, 1995-11-20
% Modified 1999-01-03 by VDB

T=0.1;
ti = (tmin:T:max(t))';
nfft=length(ti);
if rem(nfft,2),    % nfft odd
  select = [1:(nfft+1)/2]';
else
  select = [1:nfft/2+1]';   % include DC AND Nyquist
end

xref = detrend(interp1(t,xref,ti),1);
x = detrend(interp1(t,x,ti),1);
hh=hanning(nfft);
pref = fft(xref).*hh;
pref=pref(select);

p = diag(hh)*fft(x);
p=p(select,:);

f = (select - 1)/T/nfft;
%f=((1:N/2+1)-1)/(T*N);       % frekvensvektor t.o.m halva samplingsfrekvensen
fi=find(f>0.3 & f<1.1);       % stabilitetsområde 0.3 - 1.1 Hz
[m,mi] = max(abs(pref(fi)));

e = p(fi(mi),:)/pref(fi(mi));
e=e(:);
fd=f(fi(mi));
