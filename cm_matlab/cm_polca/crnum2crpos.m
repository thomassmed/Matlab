%@(#)   crnum2crpos.m 1.3	 97/10/29     16:41:57
%
%function crpos=crnum2crpos(crnum,mminj)
% Function for converting cr channel number to cr position
function crpos=crnum2crpos(crnum,mminj)
iimax=length(mminj);
iiss=iimax/2;
map=zeros(iiss,iiss);
index=1;
for i=1:2:iimax,
 ii=i+1;
 jsta=fix(max(mminj(i)/2,mminj(ii)/2));
 jsto=iiss-jsta;
 jind(round(i/2),:)=[jsta+1,jsto];
 for j=jsta+1:jsto,
    mposs(index,:)=[(i+1)/2 j];
    index=index+1;
 end;
end
crpos=mposs(crnum,:);
