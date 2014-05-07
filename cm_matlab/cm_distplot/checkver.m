%@(#)   checkver.m 1.4	 97/07/17     08:17:47
%
%function checkver(file,verfile)
function checkver(file,verfile)
f1=fopen(file,'r');
l1=fgetl(f1);
fclose(f1);
b1=remblank(l1);
tx=readtextfile(verfile);
i=find(file=='/');
if ~isempty(i)
  func=file(i(length(i))+1:length(file));
end
i=bucatch(func,tx(:,1:length(func)));
if isempty(i)
  fprintf(1,'\nDet finns ingen godkänd version av filen %s\n',file);
else
  l2=tx(i,:);
  b2=remblank(l2);
  ver1=b1(length(sscanf(l1,'%s',[1 2]))+1:length(sscanf(l1,'%s',[1 3])));
  ver2=b2(length(sscanf(l2,'%s',[1 1]))+1:length(sscanf(l2,'%s',[1 2])));
  if strcmp(ver1,ver2)==0
    fprintf(1,'\nVarning, denna version (%s) av %s\nskiljer sig från godkänd version (%s).\n',ver1,file,ver2);
    fprintf(1,'Resultaten kan vara felaktiga.\n');
  else
    fprintf(1,'\n==== distplot ver %s ====\n',ver2);
  end
end
