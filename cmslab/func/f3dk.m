function [dk,sd,fd,am]=f3dk(x,nn,fs)
% [dk,sd,fd,am]=f3dk(x,nn,fs)
%
% stabilitetsmonitor f3
%
% x är insignalen nn är modellordningen [na nc] och fs är samplingsfrekvensen
x=x(:);
if nargin==1,
  fs=25;
  nn=[8 7];
elseif nargin==2,
  fs=25;
end
x=dtrend(x,1);
ns=fix(fs/5);
x=decimate(x,ns,'fir');
fs=fs/ns;
th=parmax(x,nn,-1,-1,-1,-1,1/fs);
[dk,sd,fd]=th2dr(th,1/fs);
if length(fd)>1,
  minfd=min(abs(fd-0.5));
  i=find(abs(fd-0.5)==minfd);
  dk=dk(i);
  fd=fd(i);
  sd=sd(i);
end 
am=ampphase(fd,1/fs,x);
