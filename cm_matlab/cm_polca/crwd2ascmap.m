%@(#)   crwd2ascmap.m 1.2	 95/02/15     08:14:54
%
%function ascmap=crwd2ascmap(crwd,mminj,width)
function ascmap=crwd2ascmap(crwd,mminj,width)
[map,mpos]=cr2map(crwd,mminj);
s=size(map);
ind=0;
ascmap=setstr(32*ones(s(1),width));
for i=1:s(1)
  f=find(mpos(:,1)==i);
  jc=mpos(f,2);
  kc=(jc-1)*4;
  for k=1:length(kc)
    ind=ind+1;
    ascmap(i,kc(k)+1:kc(k)+4)=sprintf('%4s',num2str(crwd(ind)));
  end
end
