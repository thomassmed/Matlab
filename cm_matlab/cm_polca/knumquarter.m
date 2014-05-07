%@(#)   knumquarter.m 1.1	 06/04/05     15:02:23
%
% function mat=knumquarter(mminj)
%
% This function returns a (nr_rods/4)x4 matrix of rod numbers. Each row in
% the matrix contains symmetry elements (rods).
%
% mminj - describes the core
%
% To call knumsym(mminj,5) is equivalent to call knumquarter(mminj).
function [ur,ul,ll,lr]=knumquarter(mminj)

n=length(mminj);
rod=0;
for r = 1:(n/2)
   c=1;
   while c < mminj(r)
      ul(r,c)=0;
      c=c+1;
   end
   for c=c:n/2
      rod=rod+1;
      ul(r,c)=rod;
   end
   for c=(n/2+1):(n+1-mminj(r))
      rod=rod+1;
      ur(r,c-n/2)=rod;
   end
   for c=(n+2-mminj(r)):n
      ur(r,c-n/2)=0;
   end
end

ul = flipud(ul);
ul=ul(:);
ul=ul(find(ul>0));

ur=flipud(rot90(ur));
ur=ur(:);
ur=ur(find(ur>0));

ll=2*rod+1-ur;
lr=2*rod+1-ul;
