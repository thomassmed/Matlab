function [xsep,ysep]=sepaplac
% [xsep,ysep]=sepaplac
% Gives the x and y coordinates for the steam
% separators in F1 and F2, see also xy2ij and ij2xy
%
a=0.376;
b=sqrt(3)*a/2;
y=(6*b:-b:-6*b);
x1=(-5.5*a:a:5.5*a)';
x2=(-5*a:a:5*a)';
mmin1=[5 2 1 1 2 2 5];
mmax1=[8 11 12 12 12 11 8];
mmin2=[2 1 1 1 1 2];
mmax2=[10 11 11 11 11 10];
k=0;
for i=1:13,
   i1=(i+1)/2;  
   i2=i/2;
   if round(i1)==i1,
      for j=mmin1(i1):mmax1(i1),
        k=k+1;      
        xsep(k)=x1(j);
        ysep(k)=y(i);
      end
   else
      for j=mmin2(i2):mmax2(i2),
        k=k+1;      
        xsep(k)=x2(j);
        ysep(k)=y(i);
      end
   end
end
xsep=xsep';
ysep=ysep';
