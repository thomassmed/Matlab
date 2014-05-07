%@(#)   envelop.m 1.6	 98/04/16     15:34:54
%
%function [env,ivec,symme]=envelop(filevec,distname,min_max)
function [env,ivec,symme]=envelop(filevec,distname,min_max)
hmat=get(gcf,'userdata');
hvec=hmat(1,:);
hpar=hvec(length(hvec)-1);
figure(hpar)
mstr=setprop(6);
evstr=sprintf('%s%s%s','dist=',mstr,'(dist);');
if strcmp('BURNUP',distname)|strcmp('VHIST',distname)|strcmp('SSHIST',distname)|strcmp('EFPH',distname)
  d=0;
else
  d=1;
end
for i=1:size(filevec,1)-1
  [dist,mminj,konrod,bb,hy,mz]=readdist(filevec(i+d,:),distname);
  symme=mz(2);
  if size(dist,1)>1
    eval(evstr)
  end
  if i==1,env=dist;ivec=ones(1,length(dist));end
  if strcmp(min_max,'min'),j=dist<env;else j=dist>env;end
  j=find(j);
  if ~isempty(j),env(j)=dist(j);ivec(j)=i*ones(1,length(j));end
end
