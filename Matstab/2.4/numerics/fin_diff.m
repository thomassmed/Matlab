function [d1,d2,d3,d4,d5,d6,d7]=fin_diff(fcn,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23)
%fin_diff
%
%[d1,d2,...]=fin_diff(fcn,p1,p2,...)
%
%Calculates the finite difference of a function fcn
%and its parameters from p1 up to p13. 
%
%Ex: y=fcn(p1,p2,p3) where
%
%y = (fcn(p1*h,p2,p3)-fcn(p1,p2,p3))/(p1*h-p1), Zeros in p1 is omitted

%@(#)   fin_diff.m 1.2   96/08/21     13:57:33

evalstr=['y=' fcn '(p1'];
p01=p1;
for j=2:nargin-1,
  evalstr = [evalstr,',p',int2str(j)];
  eval(['p0' int2str(j) '=p' int2str(j) ';'])
end
evalstr = [evalstr, ');'];

%Beräkna begynnelsevärdet
eval(evalstr);
y0=y;

lp=length(p1);

%Gör en störning på var och en av parametrarna
h=1.001;
for n=1:nargout,
  eval(['p' int2str(n) '=p' int2str(n) '*h;'])
  eval(evalstr)
  eval(['den=p' int2str(n) '-p0' int2str(n) ';'])
  jj=find(den~=0);
  eval(['d' int2str(n) '=zeros(lp,1);'])
  eval(['d' int2str(n) '(jj)=(y(jj)-y0(jj))./den(jj);'])
  eval(['p' int2str(n) '=p0' int2str(n) ';'])
end
