%@(#)   findcyctid.m 1.2	 94/08/12     12:15:03
%
%function [cycstart,cycslut]=findcyctid(CYCNAM,unit)
% ger cykeltider for cykelnamn
% Exempel: [cycstart,cycslut]=findcyctid('c10','f1')
%          [cycstart,cycslut]=findcyctid(['c9 ';'c10';'c11'],'f1')
function [cycstart,cycslut]=findcyctid(CYCNAM,unit)
trac=['/cm/',lower(unit),'/'];
ib=size(CYCNAM,1);
cyctider=[];
for i=1:ib,
  cycin=[trac,lower(remblank(CYCNAM(i,:))),'/fil/cycle-info.txt'];
  fid=fopen(cycin,'r');
  s=fgetl(fid);s=fgetl(fid);
  ord=fscanf(fid,'%s',1);
  ord(find(ord=='-'))='';
  ord=ord(3:8);
  cycstart=[cycstart;ord];
  for j=1:9, s=fgetl(fid);end
  ord=fscanf(fid,'%s',1);
  fclose(fid);
  ord(find(ord=='-'))='';
  ord=ord(3:8);
  cycslut=[cycslut;ord];
end
