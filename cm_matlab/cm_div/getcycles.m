%@(#)   getcycles.m 1.4	 98/01/13     07:55:00
%
function [cycles,efph]=getcycles(unit)
if nargin <1,
  unit=findreakdir;
end
if length(find(unit=='/'))==0,
  unit=['/cm/',unit,'/'];
end
reakdir=unit;
opyear=[reakdir,'fil/op-year.txt'];
fid=fopen(opyear,'r');
efph(1)=fscanf(fid,'%f',1);
ord=fscanf(fid,'%s',1);
cycles(1,:)=remblank(ord);
rad=fgetl(fid);
i=2;
while isstr(rad)
  tmp=fscanf(fid,'%f',1);
  if ~isempty(tmp),efph(i)=tmp;end
  i=i+1;
  ord=fscanf(fid,'%s',1);
  ord=fscanf(fid,'%s',1);
  rad=fgetl(fid);  
  if length(ord)==0|~isstr(rad), break;end
  cycles=str2mat(cycles,remblank(ord));
end
fclose(fid);
cycles=lower(cycles);
efph=efph';
