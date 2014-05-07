%@(#)   map2cr.m 1.2	 94/08/12     12:10:39
%
%function konrod=map2cr(map,mminj)
%Convert control rod value vector to control rod map
%Example: map is 15 by 15, mminj 30 by 1 =>  konrod is 169 by 1 (F3)
function konrod=map2cr(map,mminj)
iimax=length(mminj);
iiss=iimax/2;
index=1;
for i=1:2:iimax,
 ii=i+1;
 jsta=fix(max(mminj(i)/2,mminj(ii)/2));
 jsto=iiss-jsta;
 jind(i/2,:)=[jsta+1,jsto];
 for j=jsta+1:jsto,
    konrod(index)=map((i+1)/2,j);
    index=index+1;
 end;
end
