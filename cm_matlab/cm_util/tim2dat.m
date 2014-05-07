%@(#)   tim2dat.m 1.6	 01/01/03     09:43:02
%
%function dat=tim2dat(tid)
%
% converts time to date
% date=[yyyy mm hh mm]
%
function dat=tim2dat(tid)
manad=[31 28 31 30 31 30 31 31 30 31 30 31];
nollt=[1980 01 01 00 00];
yearl=365*ones(60,1);
y=nollt(1);
for i=1:60,
   if round(y/4)==y/4, yearl(i)=366;end
   %if y==2000, yearl(i)=365;end
   y=y+1;   
end  
ll=size(tid);ll=ll(1);
for i=1:ll,
  ey=fix((tid(i)-2)/365.25);
  if sum(yearl(1:ey+1))<tid(i), ey=ey+1;end
  dt=tid(i)-sum(yearl(1:ey));
  manad(2)=28;
  if yearl(ey+1)==366, manad(2)=29;end
  em=fix(dt/31.001)+1;
  if sum(manad(1:em))<=dt, em=em+1;end
  if em>1, dt=dt-sum(manad(1:em-1));end
  ed=fix(dt);
  dt=dt-ed;
  eh=fix(dt*24);
  dh=dt*24-eh;
  emm=fix(dh*60);
  dat(i,:)=nollt+[ey em-1 ed eh emm];
end
