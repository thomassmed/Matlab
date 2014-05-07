function a=lpov(r);
%LPRM-vervakning av P. Lansker 15/3-90
x=sin(pi*(0:24)/6.25);
y=cos(pi*(0:24)/6.25);
window=zeros(1,25);
for n=1:(length(r))
   as=(x.*window)/(x.^2);
   ac=(y.*window)/(y.^2);
   a(n)=sqrt(as^2+ac^2);
   window=[r(n) window(1:24)];
end
a(1:25)=zeros(1,25);
a=a';
