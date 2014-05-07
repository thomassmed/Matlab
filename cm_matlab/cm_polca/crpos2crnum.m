%@(#)   crpos2crnum.m 1.3	 97/10/31     09:59:15
%
%function crnum=crpos2crnum(y,x,mminj)
%function crnum=crpos2crnum(yx,mminj)
% Function converting cr postion to cr channel number
function crnum=crpos2crnum(y,x,mminj)
if nargin<3,
  mminj=x;
  x=y(:,2);
  y=y(:,1);
end
iimax=length(mminj);
iiss=iimax/2;
map=zeros(iiss,iiss);
l=min(length(y),length(x));
crnum=zeros(l,1);
for ly=1:l
  index=1;
  for i=1:2:2*(y(ly)-1)
    ii=i+1;
    jsta=fix(max(mminj(i)/2,mminj(ii)/2));
    jsto=iiss-jsta;
    jind(round(i/2),:)=[jsta+1,jsto];
    for j=jsta+1:jsto,
      index=index+1;
    end;
  end
  i=2*y(ly)-1;ii=i+1;
  jsta=fix(max(mminj(i)/2,mminj(ii)/2));
  crnum(ly)=index-1+x(ly)-jsta;
  jsto=iiss-jsta;
  if x(ly)<jsta+1|x(ly)>jsto,
     crnum(ly)=0;
  end
end
