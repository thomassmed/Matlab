%@(#)   cr2core.m 1.2	 94/08/12     12:10:00
%
%function core=cr2core(dist,mminj)
%Blow up control rod value vector to full core map
%Example: konrod is 169 by 1, mminj 30 by 1 => core 30 by 30 (F3)
function core=cr2core(konrod,mminj)
[map,mpos]=cr2map(konrod,mminj);
ll=length(konrod);
core=zeros(size(mminj,1));
for i=1:ll,
    my=2*mpos(i,1);mx=2*mpos(i,2);
    core(my,mx)=map(my/2,mx/2);
    core(my-1,mx)=map(my/2,mx/2);
    core(my,mx-1)=map(my/2,mx/2);
    core(my-1,mx-1)=map(my/2,mx/2);
end
