%@(#)   readbuntyp.m 1.3	 94/08/12     12:10:47
%
%function buntyp=readbuntyp(sourcefil)
% Reads buntyp from a sourcefile or complementfile,
% e.g. output from anaload
function buntyp=readbuntyp(sourcefil)
fid=fopen(sourcefil,'r');
rad=fgetl(fid);
while ~strcmp(upper(rad(1:4)),'BUNT')
  rad=fgetl(fid);
end
buntyp=32*ones(1000,4);
setstr(buntyp);
k=0;
rad=fgetl(fid);
while strcmp(upper(rad(1:3)),'ROW'),
  istart=min(find(rad=='/'|rad=='*'));
  rad=rad(istart+1:length(rad));
  ib=find(rad==','|rad=='/');
  for j=1:length(ib),
     rad(ib(j))=' ';
  end
  for j=1:100,
    [A,COUNT,ERRMSG,NEXTINDEX]=sscanf(rad,'%s',1);
    if length(A)==0, break;end
    k=k+1;
    buntyp(k,:)=sprintf('%4s',A);
    rad=rad(NEXTINDEX:length(rad));
  end
  rad=fgetl(fid);
end
buntyp=buntyp(1:k,:);
fclose(fid);
end
