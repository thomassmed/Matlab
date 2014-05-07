function [xp,yp,P4]=sqblock(P)
[imax,jmax]=size(P);
P4=zeros(imax*2,jmax*2);
il=1;
for i=1:imax
   il1=il+1;
   jl=1;
   xp(il)=i-1;
   xp(il1)=i;
   for j=1:jmax 
      jl1=jl+1;
      yp(jl)=j-1;
      yp(jl1)=j;
      pp=P(i,j);
      P4(il,jl)=pp;
      P4(il1,jl)=pp;
      P4(il,jl1)=pp;
      P4(il1,jl1)=pp;
      jl=jl+2;
   end
   il=il+2;
end

