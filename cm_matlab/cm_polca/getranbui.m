%@(#)   getranbui.m 1.3	 05/12/08     10:31:36
%
%function buidvec=getranbui(distfile,pos)
function buidvec=getranbui(distfile,pos)
if nargin==1,pos=2;end
[vec,mminj]=readdist7(distfile,'asyid');
coremap=randvec(mminj);
i=find(coremap==pos);
buidvec(:,1:size(vec,2))=vec(i,:);
