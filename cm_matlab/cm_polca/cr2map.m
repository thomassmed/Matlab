%@(#)   cr2map.m 1.3	 97/07/17     08:14:12
%
%function [map,mpos]=cr2map(konrod,mminj)
%Convert control rod value vector to control rod map
%Example: konrod is 169 by 1, mminj 30 by 1 => map is 15 by 15, mpos 169 by 2  (F3)
function [map,mpos]=cr2map(konrod,mminj)
iimax=length(mminj);
iiss=iimax/2;
map=zeros(iiss,iiss);
 index=1;
for i=1:2:iimax,
 ii=i+1;
 jsta=fix(max(mminj(i)/2,mminj(ii)/2));
 jsto=iiss-jsta;
 jind((i+1)/2,:)=[jsta+1,jsto];
 for j=jsta+1:jsto,
    map((i+1)/2,j)=konrod(index);
    mposs(index,:)=[(i+1)/2 j];
    index=index+1;
 end;
end
if nargout>1, mpos=mposs;end
