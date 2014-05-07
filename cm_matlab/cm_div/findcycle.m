%@(#)   findcycle.m 1.1   97/08/13     14:51:50
%
% cycnam=findcycle(date,unit)
%
function cycnam=findcycle(date,unit)
cycles=getcycles(unit);
[cycstart,cycslut]=findcyctid(cycles,unit);
d=dat2tim(date);
c=dat2tim(cycstart);
dc=zeros(size(d));
for i=1:length(c),
  ii=find(d>c(i));
  dc(ii)=dc(ii)+1;  
end
cycnam=cycles(dc,:);
end
