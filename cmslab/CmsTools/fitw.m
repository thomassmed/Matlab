function [err,Pfftest]=fitw(w0,d,Pfft,jw)
one_den=1./((jw/w0).^2+2*d*jw/w0+1);
A=[jw.*one_den one_den];
ac=A\Pfft;
a=ac(1);c=ac(2);
Pfftest=(a*jw+c)./((jw/w0).^2+2*d*jw/w0+1);
err=sum(real(Pfftest-Pfft).^2+imag(Pfftest-Pfft).^2);