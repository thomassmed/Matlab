%@(#)   month.m 1.3	 94/12/12     13:08:03
%
%function [monad,monstr]=month(tid1,tid2);
%
% monad is a vector
% 
% 
% 
%
%
%
function [monad,monstr]=month(tid1,tid2);
if tid1>tid2, temp=tid2;tid2=tid1;tid1=temp;end
manad=[31 28 31 30 31 30 31 31 30 31 30 31];
MONAD=['JAN'
       'FEB'
       'MAR'
       'APR'
       'MAJ'
       'JUN'
       'JUL'
       'AUG'
       'SEP'
       'OKT'
       'NOV'
       'DEC'];
dat1=tim2dat(tid1);
dat2=tim2dat(tid2);
dats=dat1;
dats(1,3:5)=[0 0 0];
datf=dat2;
datf(1,3:5)=[0 0 0];
datt=dats;
i=1;
while ~(datt(1)==datf(1)&datt(2)==datf(2))
   monstr(i,:)=MONAD(datt(2),:);
   monad(i,1)=dat2tim(datt);
   datt=addmon(datt,1);
   i=i+1;
end
monad(i,1)=dat2tim(datt);
monstr(i,:)=MONAD(datt(2),:);
datt=addmon(datt,1);
i=i+1;
monad(i,1)=dat2tim(datt);
end
