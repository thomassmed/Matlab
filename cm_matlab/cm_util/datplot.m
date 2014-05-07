%@(#)   datplot.m 1.2	 94/02/08     12:31:23
%
%function hand=datplot(tid,y,symbol,axlar,startdat,enddat)
%
% plots y versus tid and draws lines 
% at month boudaries tid may be continuous time in days or
% a vector of dates
% startdat=[yyyy mm dd]
% enddat=[yyyy mm dd]
% 
%    startdat, enddat and symbol may be ommitted
%    symbol is the plot symbole, e.g. '-','x','r','rx',etc
%    see help for plot for more information
%    axlar is 1 by 4 vector used to define axis(axlar)
%    if axlar is a 1 by 2 vector, it is assumed that ymin and ymax is
%    specified
function hand=datplot(tid,y,symbol,axlar,startdat,enddat)
if min(size(tid))>2,
   tid=dat2tim(tid);
end
mit=min(tid);mat=max(tid);
if nargin>4,
  if length(startdat)<5, startdat(4:5)=[0 0];end
  mit=dat2tim(startdat);
end
if nargin>5,
  if length(enddat)<5, enddat(4:5)=[0 0];end
  mat=dat2tim(enddat);
end
hold on
[monad,monstr]=month(mit,mat);
if nargin>3,
  if size(axlar,2)==2,
    axx=[mit mat axlar];
  else
    axx=axlar;
  end
else
  axx=axis;
end
yax=[axx(3)*ones(size(monad))  axx(4)*ones(size(monad))];
xax=[monad monad];
if nargin<3
  hand=plot(tid-mit,y);
elseif ~isstr(symbol)
 disp('symbol (5:th) in argument must be a string'); 
else
  disp(symbol)
  hand=plot(tid-mit,y,symbol);
end
plot(xax'-mit,yax','white');
ll=length(monad);
dy=axx(4)-axx(3);
text(monad(1:ll-1)+10-mit,yax(1:ll-1,1)+0.05*dy,monstr);
axis([0 mat-mit axx(3) axx(4)]);
hold off
end
