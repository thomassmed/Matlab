function [e,e1,e2,eAew]=tt2eigvec(xref,x,Ts)
%e=tt2eigvec(xref,x,Ts);
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

%Pär Lansåker wrote tt2ev
%Thomas Smed modified slightly to make it function with the new system id toolbox

%%
%Input preparation
xref = dtrend(xref,1);
x = dtrend(x,1);

%Find interesting frequency
th0 = armax(xref,[8 7],[],[],[],[],Ts);
g0=th2ff(th0);
[mg,mgi]=max(g0.SpectrumData);
wref = g0.Frequency(mgi);

if 1, %wref<2
    [dr,fd]=drident(xref,Ts);
    wref=2*pi*fd;
    sig=log(dr)*fd;
    ew=exp(1j*wref*Ts);
    ewA=exp((sig+1j*wref)*Ts);
else
    ew=exp(1j*wref*Ts);
    rotA=roots(th0.a);
    [xi,ii]=min(abs(rotA-ew));
    ewA=rotA(ii);
end
%% Do it
[tmp,le] = size(x);
e = zeros(le,1);e1=e;
for n=1:le, 
  th = armax(iddata(x(:,n),xref,Ts),[8 7 3 0]);
  e1(n)=polyval(th.b,ew)/polyval(th.a,ew);
  e(n)=polyval(th.b,ewA)/polyval(th.a,ewA);
  if nargout>3,
      aew=angle(ew);
      Aew=(.8:.01:1.2)*aew;
      eAew=exp(1j*Aew);
      e2{n}=polyval(th.b,eAew)./polyval(th.a,eAew);
  end
end


