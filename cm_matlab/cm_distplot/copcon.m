%@(#)   copcon.m 1.2	 98/04/22     14:01:51
%
function copcon
hval=get(gcf,'userdata');
load simfile
efph=str2num(get(hval(6),'string'));
point=find(efph==blist);
if point>1,conrod(point,:)=conrod(point-1,:);end
set(hval(1),'string',conrod(point,:));
save simfile conrod tlowp hc pow filenames blist bocfile
