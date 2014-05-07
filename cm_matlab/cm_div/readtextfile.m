%@(#)   readtextfile.m 1.6	 06/02/02     08:17:18
%
%function tx=readtextfile(file)
function tx=readtextfile(file)
fid=fopen(file);
i=1;
lin=fgetl(fid);
if strcmp(lin,''),lin=' ';end
tx(1,:)=lin;
while 1
  i=i+1;
  lin=fgetl(fid);
  if strcmp(lin,''),lin=' ';end
  if ~isstr(lin), break, end
  tx(i,:)=setstr(32*ones(1,size(tx,2)));
  s=size(tx);
  ll=length(lin);
  if ll>s(2)
    w=ll-s(2);
    tx=[tx(:,1:s(2)) setstr(32*ones(s(1),w))];
  end
  tx(i,1:ll)=lin;
end
fclose(fid);
