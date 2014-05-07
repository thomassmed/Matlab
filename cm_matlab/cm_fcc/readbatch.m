%@(#)   readbatch.m 1.2	 94/08/12     12:15:34
%
%function [eladd,garburn,antal,levyear,enr,buntot,weight,eta,typ,stav]=readbatch(batchfil)
function [eladd,garburn,antal,levyear,enr,buntot,weight,eta,typ,stav]=readbatch(batchfil)
if nargin<1, batchfil=[findreakdir,'div/bunhist/batch-data.txt'];end
fid=fopen(batchfil,'r');
for i=1:1000,
  ord=fgetl(fid);
  if length(ord)>4,
    if  strcmp(upper(ord(1:5)),'ELADD'), break;end
  end
end
for i=1:1000,
  ord=fscanf(fid,'%s',1);
  if strcmp(upper(ord),'END'),break;end
  eladd(i)=str2num(ord);
  levyear(i)=fscanf(fid,'%i',1);
  ty=fscanf(fid,'%s',1);
  antal(i)=fscanf(fid,'%i',1);
  enr(i)=fscanf(fid,'%f',1);
  weight(i)=fscanf(fid,'%f',1);
  garburn(i)=fscanf(fid,'%f',1);
  bunt=fscanf(fid,'%s',1);
  stav(i)=fscanf(fid,'%i',1);
  if i==1,
    buntot=bunt;
    typ=ty;
  else
    buntot=str2mat(buntot,bunt);
    typ=str2mat(typ,ty);
  end
end
fscanf(fid,'%s',1);
eta=fscanf(fid,'%f',1);
fclose(fid);
