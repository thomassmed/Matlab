% Convert from vector to core map
%
% map=vec2corcell(strvec,mminj)
%
% Input
%   strvec - cell array of strings, one for each channel
%   mminj - core contour
%
% Output
%   map   - iamax by iamax matrix, zero outside of core
%
% Example:
%  [fue_new,Oper]=read_restart_bin('s3-1.res');
%  mminj=fue_new.mminj;
%  mpow=mean(Oper.Power);
%  map_pow=vec2cor(mpow,mminj);
%
% See also cor2vec, cpos2knum, ij2mminj, knum2cpos, sym_full, vec2cor
%          Control rods: mminj2crmminj
function core=vec2corcell(strvec,mminj)
l=length(mminj);
if ischar(strvec),
    strvec=cellstr(strvec);
end
core=cell(l,l);
ind=0;
for i=1:l,
  for j=mminj(i):l+1-mminj(i),
      ind=ind+1;
      core{i,j}=strvec{ind};
  end
end
