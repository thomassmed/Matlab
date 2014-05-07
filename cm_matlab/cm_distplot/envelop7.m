%@(#)   envelop7.m 1.1	 00/12/15     10:06:40
%
%function [env,ivec,symme]=envelop7(filevec,distname,min_max)
function [env,ivec,symme]=envelop7(filevec,distname,min_max)
hval=get(gcf,'userdata');
hpar=hval(length(hval));
figure(hpar)
mstr=setprop(6);
prevdist=['BURNUP  ';'EFPH    ';'KHOT    ';'SDM     '];
evstr=sprintf('%s%s%s','dist=',mstr,'(dist);');
if ~isempty(find(strmatch(distname,prevdist)))
  d=0;
else
  d=1;
end
for i=1:size(filevec,1)-1
  [dist,mminj,konrod,bb,hy,mz]=readdist7(filevec(i+d,:),distname);
  symme=mz(2);
  if size(dist,1)>1
    eval(evstr)
  end
  if i==1,env=dist;ivec=ones(1,length(dist));end
  if strcmp(min_max,'min'),j=dist<env;else j=dist>env;end
  j=find(j);
  if ~isempty(j),env(j)=dist(j);ivec(j)=i*ones(1,length(j));end
end
