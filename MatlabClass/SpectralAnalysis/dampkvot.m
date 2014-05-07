%% Ladda data
load zdata
plot(t,z)
Ts=t(2)-t(1);
fN=1/2/Ts;
zd=detrend(z);
%% Titta på spektrum.Kör först bara en enkel fft
Z=fft(zd);
N=ceil(length(Z)/2);
f_fft=linspace(0,fN,N);
hold off
loglog(f_fft,abs(Z(1:N)))
hold all
% Prova den klassiska funktionen spectrum
[Pold,fr]=spectrum(zd);
fold=fN*fr;
loglog(fold,Pold(:,1))
shg
%% Behålla bara den förfinade
hold off
loglog(fold,Pold(:,1))
hold all
%% Prova welch
Nfft=1024;
[Pw,w]=pwelch(zd,Nfft);
f=fN*w/pi;
loglog(f,Pw)
%% Prova att speca frekvenserna
ff=[0.1:.1:.4 .45:.005:.55 .6:.1:2];ff=ff';
Pwf=pwelch(zd,Nfft,0,ff,25);
loglog(ff,Pwf)
%% Behåll bara de med specade frekvenser
hold off
loglog(ff,Pwf)
hold all
%% Spektrum med pcov
Pc=pcov(zd,50,ff,25);
loglog(ff,Pc)
%% Spektrum med pcov, decimerad
zdec=decimate(zd,2,'fir');
Pcdec=pcov(zdec,50,ff,12.5);
loglog(ff,Pcdec)
%% Beräkna dämpkvot med drident
[dk,fd,drs,ord,th]=drident(z,Ts);
%% Först jämför vi med den valda
P5=squeeze(freqresp(th{5},ff*2*pi));
loglog(ff,abs(P5))
%% Sedan med ordning [7 7]
P4=squeeze(freqresp(th{4},ff*2*pi));
loglog(ff,abs(P4))
legend('Welch','pcov','pcov-decimate','ARMA(8,8)','ARMA(7,7)');
%% Zooma in på toppen
axis([0.3 0.7 1e-2 1])
%% Beräkna dämpkvot på ett annat sätt:
ar=arcov(zd,50);
zp0=roots(ar);
zpfreq=angle(zp0)*25/2/pi;
zp=zp0(zpfreq>0.3&zpfreq<0.7)
%% Gå till s-planet
s=log(zp)/Ts
%%
f0=imag(s)/2/pi;
T=1/f0;
dk=exp(real(s)*T);
[dk f0]


