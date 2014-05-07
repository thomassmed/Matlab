%@(#)   prestep7.m 1.2	 04/11/03     12:50:40
%
function prestep7(step)
load sim/simfile;
hval=get(gcf,'userdata');
s=size(filenames);
efph=str2num(get(hval(21),'string'));
point=find(efph==blist);
if strcmp(step,'fwd') & point<s(1)
  point=point+1;
else if strcmp(step,'bwd') & point>1,point=point-1;end
end
efph=blist(point);
set(hval(19),'string',tlowp(point,:));
set(hval(18),'string',hc(point,:));
set(hval(17),'string',pow(point,:));
set(hval(21),'string',num2str(efph));
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
set(hval(30),'value',(point-1)/(length(blist)-2));
