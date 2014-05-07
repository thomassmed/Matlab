function [a1,a2,ph]=ampphase(f,T,x1,x2);
%
%
% [a1,a2,ph]=ampphase(f,T,x1,x2) lmnar amplituderna och fasen [radianer]
% mellan tv insignaler x1 och x2 med x1 som referens. Analysen genomfrs fr 
% signalerna x1 och x2 fr en given frekvens f [Hz].  T r samplingstiden.
% ampphase(f,T,x) ger amplituden for x.
%

%Pr Lansker 20/3-91

twopi=2*pi;
if nargin==4,
  x1=dtrend(x1(:));
  x2=dtrend(x2(:));
  arrlength=ceil(1/T/f);
  x=sin(2*pi*f*(0:arrlength)*T);
  y=cos(2*pi*f*(0:arrlength)*T); %maste andras, fel
  window1=zeros(1,arrlength+1);
  window2=zeros(1,arrlength+1);
  sqrsumx=sum(x.^2);
  sqrsumy=sum(y.^2);
  for n=1:(length(x1))
     a1=sum(x.*window1)/sqrsumx;
     b1=sum(y.*window1)/sqrsumy;
     a2=sum(x.*window2)/sqrsumx;
     b2=sum(y.*window2)/sqrsumy;
     am1(n)=sqrt(a1^2+b1^2);
     am2(n)=sqrt(a2^2+b2^2);
     ph(n)=atan2(a1,b1)-atan2(a2,b2);
     window1=[x1(n) window1(1:arrlength)];
     window2=[x2(n) window2(1:arrlength)];  
  end
  am1(1:arrlength)=zeros(1,arrlength);
  am2(1:arrlength)=zeros(1,arrlength);
  a1=am1';
  a2=am2';
  ph=ph';
else
  x1=dtrend(x1(:)');
  arrlength=ceil(1/T/f);
  x=sin(2*pi*f*(0:arrlength)*T);
  y=cos(2*pi*f*(0:arrlength)*T);
  window1=zeros(1,arrlength+1);
  window2=zeros(1,arrlength+1);
  sqrsumx=sum(x.^2);
  sqrsumy=sum(y.^2);
  for n=1:(length(x1))
     a1=sum(x.*window1)/sqrsumx;
     b1=sum(y.*window1)/sqrsumy;
     am1(n)=sqrt(a1^2+b1^2);
     window1=[x1(n) window1(1:arrlength)];
  end
  am1(1:arrlength)=zeros(1,arrlength);
  a1=am1';
end
