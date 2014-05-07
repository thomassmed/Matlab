% Convert core map to vector of values
%
% vec=cor2vec(core,mminj)
%
% Input
%   core  - coremap (iamax by iamax)
%   mminj - core contour
%
% Output
%   vec   - vector of values
%
% Example
%   vec=cor2vec(core,mminj);
%   cmsplot s3-1.res vec
%
%
% See also cmsplot, cpos2knum, ij2mminj, knum2cpos, sym_full, vec2cor
%          Control rods: mminj2crmminj
function vec=cor2vec(core,mminj,knum,sym)
nbun=sum(length(mminj)-2*(mminj-1));
if nargin<3
    sym = 'FULL';
elseif nargin == 3
    if ischar(knum);
        sym = knum;
    else
        sym='FULL';
    end
end

if size(core,1) == 2*length(mminj)
    mminjh = 2*mminj-1;
    mminj = reshape([mminjh mminjh]',2*length(mminjh),1);
end
switch sym
    case 'E'
        [ic,jc]=size(core);
        cvtemp=core';cvtemp=cvtemp(:);
        lcv=length(cvtemp);cvtemp=cvtemp(lcv:-1:1);
        cvtemp=reshape(cvtemp,jc,ic);cvtemp=cvtemp';
        core=[cvtemp core];
    case 'S'
        [ic,jc]=size(core);
        cvtemp=core';cvtemp=cvtemp(:);
        lcv=length(cvtemp);cvtemp=cvtemp(lcv:-1:1);
        cvtemp=reshape(cvtemp,jc,ic);cvtemp=cvtemp';
        core=[cvtemp;core];
    case 'SE'
        [ic,jc]=size(core);
        csw=core';csw=csw(:,jc:-1:1);
        cvtemp=core';cvtemp=cvtemp(:);
        lcv=length(cvtemp);cvtemp=cvtemp(lcv:-1:1);
        cvtemp=reshape(cvtemp,jc,ic);cvtemp=cvtemp';
        cnw=cvtemp;cne=cnw';cne=cne(:,jc:-1:1);
        core=[cnw cne
              csw core];
end

k=0;
iamax=length(mminj);

vec=zeros(1,nbun);
for i=1:iamax,
  for j=mminj(i):(iamax+1-mminj(i))
      k=k+1;
      vec(k)=core(i,j);
  end
end
