%@(#)   adjustyear.m 1.3	 97/12/02     08:22:11
%
%function newyear=adjustyear(oldyear)
% Changes 83, 95, 03 to 1983,1995 2005 etc
function newyear=adjustyear(oldyear)
i=find(oldyear<100&oldyear>70);
newyear=oldyear;
newyear(i)=oldyear(i)+1900;
i=find(newyear<100);
newyear(i)=oldyear(i)+2000;
