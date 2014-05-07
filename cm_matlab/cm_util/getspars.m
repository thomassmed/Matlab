%@(#)   getspars.m 1.2	 04/09/09     10:26:03
%
function dis2d=getspars(dis3d,i,j)

[x,y]=size(dis3d);
if x*y==1 & length(i)*length(j)>1, dis3d=zeros(length(i),length(j)); end
if size(i,2)>1,i=i';end
if size(j,2)>1,j=j';end
if size(dis3d)==size(j),j=1;end
if size(dis3d)==size(i),i=1;end
k=(j-1)*x+i;
dis2d=dis3d(k);
