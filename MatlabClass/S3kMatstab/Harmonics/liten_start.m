%% Explain how to get phasors by direct parameter fitting in the time domain
%% Read some data data
cmsinfo=read_cms('../../../BigFiles/r1_cy14_09_glbl.cms');
t=read_cms_scalar(cmsinfo,1);
pow=read_cms_scalar(cmsinfo,'Relative Power');
%% And plot
plot(t,pow)
hold on
%% And then we read decay ratio and frequency from S3K
[dr,f]=read_drfd_s3kout('../../../BigFiles/r1_cy14_09_glbl.out')
%% calculate lam=sig+j w
w=2*pi*f;
sig=f*log(dr);
lam=sig+1j*w
%% plot the 'dc'-component
one=ones(size(t));
plot(t,one,'g');
%% and the 'ac'
plot(t,one+.03*exp(lam*t),'r')
%% Of course we can separate lam into sig + wj:
plot(t,1+0.03*exp(sig*t).*exp(1j*w*t),'kx');
%% compute
r=0.028;
fi=0.6;
powest=1+real(r*exp(1j*fi)*exp(sig*t).*exp(1j*w*t));
%% plotta
hold off
plot(t,pow)
hold on
plot(t,powest,'r');
%% Translate into cartesian (why will shortly be evident
c=r*exp(1j*fi);
a=real(c)
b=imag(c)
%% Use the function fitstab
itmin=86;
tc=t(itmin:end);powc=pow(itmin:end);powc=powc(:);tc=tc(:);
A=[ones(size(tc)) cos(w*tc).*exp(sig*tc) -sin(w*tc).*exp(sig*tc)];
%% try with the numbers we derived before
plot(tc,A(:,1)+a*A(:,2)+b*A(:,3),'k')
%% Estimate the parameters using \
p0=A\powc;
[err,xest]=fitstab([p0;sig;w],tc,powc);
%% check it out
hold off
plot(tc,powc)
hold all
plot(tc,xest)
plot(tc,powc-xest+1)
%% Make a parametric fit
options=optimset('fminsearch');
p=fminsearch(@fitstab,[p0;sig;w],options,tc,powc);
%% check the fit now
[err,xest]=fitstab(p,tc,powc);
hold off
plot(tc,powc)
hold on
plot(tc,xest,'r')
plot(tc,powc-xest+1)
%% What is now frequency and decay ratio
f1=p(5)/2/pi
dr1=exp(p(4)/f1)
