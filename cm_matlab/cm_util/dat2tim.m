%@(#)   dat2tim.m 1.8	 04/06/02     12:14:34
%
%function tid=dat2tim(dat)
%
% converts a date to a continuous time starting at
% nollt below (currently 1980-01-01)
%
%  dat = [yyyy mm dd hh mm]
%  or dat='yymmdd' (i.e dat is a string with 6 caharacters)
%
%
function tid=dat2tim(dat)
manad=[31 28 31 30 31 30 31 31 30 31 30 31];
nollt=[1980 01 01 00 00];
yearl=365*ones(60,1);
y=nollt(1);
if isstr(dat), 
  if size(dat,2)==6,
     date(:,1)=str2num(dat(:,1:2));
     date(:,2)=str2num(dat(:,3:4));
     date(:,3)=str2num(dat(:,5:6));
  end
  dat=date;
end
[id,jd]=size(dat);
if jd<5,
   dat=[dat zeros(id,5-jd)];
end
for i=1:60,
   if round(y/4)==y/4, yearl(i)=366;end
   %if y==2000, yearl(i)=365;end
   y=y+1;   
end  
ll=size(dat);ll=ll(1);
tid=zeros(ll,1);
for i=1:ll,
  month=dat(i,2);
  if dat(i,1)<100,dat(i,1)=dat(i,1)+1900;end
  edat=dat(i,:)-nollt;
  ey=edat(1);
  manad(2)=28;
  if (dat(i,1)/4)==round(dat(i,1)/4), manad(2)=29;end
  tid(i)=sum(yearl(1:ey))+sum(manad(1:dat(i,2)-1))+(dat(i,3)-1)+dat(i,4)/24+dat(i,5)/24/60;
end
