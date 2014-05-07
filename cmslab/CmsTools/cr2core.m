%function core=cr2core(konrod,mminj[,crmminj])
%Blow up control rod value vector to full core map
%Example: konrod is 169 by 1, mminj 30 by 1 => core 30 by 30 (F3)
% TODO: Fix for all types of reactors (Cooper, Fitzpatrick)
function core=cr2core(konrod,mminj,crmminj,offsetval)
if nargin>3
    mpos=knum2cpos(1:length(konrod),crmminj);
    map=vec2cor(konrod,crmminj);
    offset=offsetval;
elseif nargin==3,
    mpos=knum2cpos(1:length(konrod),crmminj);
    map=vec2cor(konrod,crmminj);
    offset=0;
else
    [map,mpos]=cr2map(konrod,mminj);
end
ll=length(konrod);
core=zeros(size(mminj,1)) + offset;
for i=1:ll,
    my=2*mpos(i,1);mx=2*mpos(i,2);
    core(my,mx)=map(my/2,mx/2);
    core(my-1,mx)=map(my/2,mx/2);
    core(my,mx-1)=map(my/2,mx/2);
    core(my-1,mx-1)=map(my/2,mx/2);
end
