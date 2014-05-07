% Convert core map of string to cell array of strings
%
% strcev=cor2vec(core,mminj)
%
% Input
%   core  - coremap (iamax by iamax)
%   mminj - core contour
%
% Output
%   vec   - cell array of strings
%
% Example
%   strvec=cor2vec(core,mminj);
%
%
% See also cmsplot, core2vec, cpos2knum, ij2mminj, knum2cpos, sym_full, 
%          vec2cor, vec2corcell
%          Control rods: mminj2crmminj
function vec=cor2veccell(core,mminj)
nbun=sum(length(mminj)-2*(mminj-1));

k=0;
iamax=length(mminj);

vec=cell(nbun,1);
for i=1:iamax,
  for j=mminj(i):(iamax+1-mminj(i))
      k=k+1;
      vec{k}=core{i,j};
  end
end
