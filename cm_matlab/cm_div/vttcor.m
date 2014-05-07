%@(#)   vttcor.m 1.3	 95/04/03     09:42:54
%
%
% Computes moisture content for a given POLCA-distr. file
%
% Input: 
%  distfile - (vector of) distr. file(s)
%  regions - number of separator regions 3 or 6 , default=6
function [Xw,X]=vttcor(distfile,regions)

%Initiering
if nargin<2, regions=6;end


[xsep,ysep]=sepaplac;
if regions==6,
  separeg=readsepareg('sepasixreg.txt');
else
  separeg=readsepareg('sepa3reg.txt');
end
% For each distribution file


for i=1:size(distfile,1),
  [Xsep,Msep,Mstsep]=core2sep(remblank(distfile(i,:)),xsep,ysep);
  if regions==6,
    [Xw(i),Xtemp]=vttcor6(Xsep,separeg);
  else
    [Xw(i),Xtemp]=vttcor3(Xsep,separeg);
  end
  X=[X;Xtemp'];
end
