function e=tt2ev(xref,x,Ts);
%e=tt2ev(xref,x,Ts);
%
%The complex number e corresponds to 
%the amplification and phase shift to the
%system G in the equation  
%
%  x/xref = G(w0)
%
%for the most powerful frequency component w0
%in the region 2 - 4 rad/s. x can be a columnwise matrix.
%Ts is the sampling interval.
%
%Note: xref can not be included in x due to
%numerical problems in the identification algorithm

%Pär Lansåker
%@(#)   tt2ev.m 1.2   97/10/24     09:28:13

%Input preparation
xref = dtrend(xref,1);
x = dtrend(x,1);

%Find interesting frequency
th0 = armax(xref,[8 7],[],[],[],[],Ts);
w0=2:0.01:4;
g0=th2ff(th0,[],w0);
[mg,mgi]=max(g0(:,2));
wref = w0(mgi-1);

%Do it
[tmp,le] = size(x);
e = zeros(le,1);
for n=1:le, 
  eval('th = armax([x(:,n),xref],[8 7 3 0],[],[],[],[],Ts);','error(''Check if xref is included in x!'')')
  g = th2ff(th,[],wref);
  amp = g(2,2); phi = g(2,4)*pi/180;
  e(n) = amp*(cos(phi)+i*sin(phi)); 
end


