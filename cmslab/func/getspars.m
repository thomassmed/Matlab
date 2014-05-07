function dis2d=getspars(dis3d,i,j)

[x,y]=size(dis3d);
k=(j-1)*x+i;
dis2d=dis3d(k);
