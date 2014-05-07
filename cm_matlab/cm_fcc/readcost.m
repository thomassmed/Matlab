%@(#)   readcost.m 1.2	 94/08/12     12:15:35
%
%function [buntot,batchcost]=readcost(costfil)
function [buntot,batchcost]=readcost(costfil)
fid=fopen(costfil,'r');
for i=1:1000,
  ord=fgetl(fid);
  if length(ord)>5,
    if  strcmp(upper(ord(1:6)),'BUNTYP'), break;end
  end
end
for i=1:1000,
  ord=fscanf(fid,'%s',1);
  if strcmp(upper(ord),'END'),break;end
  batchcost(i)=fscanf(fid,'%f',1);
  if i==1,
    buntot=ord;
  else
    buntot=str2mat(buntot,ord);
  end
end
fclose(fid);
