function [dr,fd]=recdr(x,fs,gamma,nn)
% [dr,fd]=recdr(x,fs,gamma,nn);
%
% Rekursiv dampkvotsberakning
if fs>10 x=decimate(x,2);end
if nargin<3 gamma=0.9995;end
if nargin<4 nn=[4 3];end
if length(x)>1000
  xx=x(1:1000);
else
  xx=x;
end
[thm,yhat,p0]=rarmax(xx,nn,'ff',gamma);
[thm,yhat]=rarmax(x,nn,'ff',gamma,thm(length(xx),:),p0);
for n=1:length(thm),
  [magtemp,wntemp,ztemp]=ddamp([1 thm(n,1:4)],1/fs);
  wndiff=abs(wntemp'-pi);
  i=find(wndiff==min(wndiff));
  i=i(1);
  mag(n)=magtemp(i);
  wn(n)=wntemp(i);
  z(n)=ztemp(i);
end
dr=z2dr(z);
fd=wn/2/pi;
