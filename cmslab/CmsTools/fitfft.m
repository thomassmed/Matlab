function [err,Pfftest,errvec]=fitfft(p,Pfft,jw)
d=p(1);
w0=p(2);
one_den=1./((jw/w0).^2+2*d*jw/w0+1);
A=[jw.*one_den one_den];
ac=A\Pfft;
a=ac(1);c=ac(2);
Pfftest=(a*jw+c).*one_den;
errvec=real(Pfftest-Pfft).^2+imag(Pfftest-Pfft).^2;
err=sum(errvec);