function [nw,se,ijnw,ijse]=mirror(mminj)
% mirror - calculates nw and se channel numbers for mirror symmetry
%
% [nw,se,ijnw,ijse]=mirror(mminj)
%
%
% Input:
%  mminj - Core contour
% 
% Output:
%  nw - Channel number Northwest portion
%  se - Channel numbers South East portion
%  ijnw - Core position i,j nw
%  ijse - Core position i,j se
%
% Note that the channels on the symmetry line will appear in both nw and se
%
% Example:
%   fue_new=read_restart_bin('s3.res',20000);
%   [nw,se,ijnw,ijse]=mirror(fue_new.mminj);
%
%  See also cor2vec, cpos2knum, ij2mminj, knum2cpos, sym_full, vec2cor

% Written: Thomas Smed 2009-04-30

%%
ll=length(mminj);
kan=sum(ll-2*(mminj-1));
%% 
ij=knum2cpos(1:kan,mminj);
nw=find(sum(ij,2)<(ll+2));
%%
ijnw=knum2cpos(nw,mminj);
ijse=zeros(size(ijnw));
for i=1:length(nw),
    ijse(i,:)=ijnw(i,:)+[1 1]*(ll+1-sum(ijnw(i,:)));
end
se=cpos2knum(ijse,mminj);
    