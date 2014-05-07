%@(#)   copcon7.m 1.4	 09/05/05     07:56:21
%
function copcon7
hval=get(gcf,'userdata');
load sim/simfile
if ~exist('sdmfiles','var'),sdmfiles=[];end
efph=str2num(get(hval(21),'string'));
point=find(efph==blist);
if point>1,conrod(point,:)=conrod(point-1,:);end
g=zeros(1,8);
w=100*ones(1,8);
k=find(conrod(point,:)==',');
j=find(conrod(point,:)=='=');
k=[0 k length(conrod(point,:))+1];
for ii=1:length(j)
  w=str2num(conrod(point,j(ii)+1:k(ii+1)-1));
  set(hval(ii),'string',conrod(point,k(ii)+1:j(ii)-1));
  set(hval(ii+8),'string',conrod(point,j(ii)+1:k(ii+1)-1));
  set(hval(ii+21),'value',1-w/100);
end
save sim/simfile bustep conrod tlowp hc pow filenames sdmfiles blist bocfile mangrpfile
if exist('polcacmd')
  save -append sim/simfile polcacmd
end