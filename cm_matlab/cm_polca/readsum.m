%@(#)   readsum.m 1.5	 98/01/13     08:23:15
%
%function [a1,a2,a3,a4,a5,a6]=readsum(filename,option,startrec,powlim);
% option=1: [pow,keff,dat,tid,emed,hc]=readsum(filename,1,startrec,powlim);
function [a1,a2,a3,a4,a5,a6]=readsum(filename,option,startrec,powlim);
if nargin==1,
  option=1;
end;
if nargin<3,
    summ=sum2mlab(filename);
end
if nargin>2,
    summ=sum2mlab(filename,startrec);
end
summ=summ';
if nargin>3,
   ii=find(summ(:,9)>powlim);
   summ=summ(ii,:);
end
if option==1,
  a1=summ(:,9);
  a2=summ(:,14);
  dat=[summ(:,6) summ(:,5) summ(:,4) summ(:,3) summ(:,2)];
  tid=dat2tim(dat);
  a3=dat;
  a4=tid;
  a5=summ(:,7);
  a6=summ(:,10);
end
