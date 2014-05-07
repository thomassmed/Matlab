%Signalanalys av  Pr Lansker 24/7-89
svar=0;
while svar~=7
clc
disp('Signalanalys...')
disp('')
disp('1. FFT')
disp('2. AKF')
disp('3. Korskorrelation')
disp('4. Keyboard')
disp('5. Hardcopy')
disp('6. Korrplot')
disp('7. Exit')
disp('')
svar=input('Input: ');
if svar<3
  x=input('Signal: ');
  n1=input('Frsta mtvrdet:  ');
  n2=input('Hur mnga vrden, 2^: ');
  n2=n1+2^n2-1; 
  x=x(n1:n2);
end
if svar==1 
  w=fft(x);
  y=w.*conj(w);
  fs=input('Samplingsfrekvens: ');
  fg=input('vre grnsfrekvens: '); 
  n1=n2-n1;
  f=fs*(0:n1/2)/(n1+1);
  plot(f(1:round(fg*n1/fs)),y(1:round(fg*n1/fs)));
  semilogy; 
  pause
  clear w fs fg
elseif svar==2
  xx=x-mean(x);
  kf=xcorr(xx);
  kf=kf/max(kf);
  fs=input('Samplingsfrekvens: ');
  t=(0:(n2-1))/fs;
  s=input('Antal sampel: ');
  plot(t(1:s),kf(n2:n2+s-1))
  pause
  clear s
elseif svar==3
  x1=input('Signal 1: ');
  x2=input('Signal 2: ');
  n1=input('Frsta mtvrdet:  ');
  n2=input('Hur mnga vrden, 2^: ');
  n2=n1+2^n2-1; 
  x1=x1(n1:n2);
  x2=x2(n1:n2);
  x1=x1-mean(x1);
  x2=x2-mean(x2);
  kf=xcorr(x1,x2);
  fs=input('Samplingsfrekvens: ');
  t=(0:(n2-1))/fs;
  s=input('Antal sampel: ');
  plot(t(1:s),kf(n2:n2+s-1))
  pause
  clear s
elseif svar==4
keyboard
elseif svar==5
tit=input('Vad skall ploten heta? ','s');
yax=input('Vad skall st p y-axeln? ','s');
xax=input('Vad skall st p x-axeln? ','s');
xlabel(xax);
title(tit);
ylabel(yax);
print
clear tit yax xax
elseif svar==6
s=input('Antal sampel: ');
td=input('Tidsfrskjutning: ');
t=(td:(n2-1+td))/fs;
plot(t(1:s),kf(n2+td:n2+s-1+td))
pause
clear s td
elseif svar==7
break
end
end
