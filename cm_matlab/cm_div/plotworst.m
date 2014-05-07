%@(#)   plotworst.m 1.2	 94/02/08     12:31:44
%
%function [lworst,bworst,imax]=plotworst(lhgr,burn);
%Plots the worst point of lhgr vs burn for each bundle.
%'worst' is taken with respect to the burnup-dependent 
%limitation given by ABB, i.e. 41.5*(1-0.0075*1.1*E)
%The factor 1.1 is included to account for the fact that POLCA
%stores mean(BURNUP) for each node, while the limit function
%is given with respect to BURNUP(pellet)
function [lworst,bworst,imax]=plotworst(l,b);
burmax=60;
x=[0 burmax];y=41.5*[1 1-burmax*0.0075*1.1];
diffline=l/1000-41.5*(1-1.1*0.0075*b/1000);
[maxd,imax]=max(diffline);
bworst=zeros(length(imax),1);
lworst=zeros(length(imax),1);
for i=1:length(imax),
  bworst(i)=b(imax(i),i);
  lworst(i)=l(imax(i),i);
end
plot(bworst/1000,lworst/1000,'x');
hold on
plot(x,y);
grid
