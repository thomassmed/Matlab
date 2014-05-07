%@(#)   prestep.m 1.3	 98/04/15     13:36:32
%
function prestep(step)
load simfile;
hval=get(gcf,'userdata');
s=size(filenames);
efph=str2num(get(hval(6),'string'));
point=find(efph==blist);
if strcmp(step,'fwd') & point<s(1)
  point=point+1;
else if strcmp(step,'bwd') & point>1,point=point-1;end
end
efph=blist(point);
set(hval(1),'string',conrod(point,:));
set(hval(3),'string',tlowp(point,:));
set(hval(4),'string',hc(point,:));
set(hval(5),'string',pow(point,:));
set(hval(6),'string',num2str(efph));
