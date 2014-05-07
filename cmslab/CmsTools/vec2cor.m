% Convert from vector to core map
%
% map=vec2cor(vec2d,mminj,fcn)
%
% Input
%   vec2d - Vector of values, one for each channel
%   mminj - core contour
%
% Output
%   map   - iamax by iamax matrix, zero outside of core
%
% Example:
%  [fue_new,Oper]=read_restart_bin('dist-boc.res');
%  mminj=fue_new.mminj;
%  mpow=mean(Oper.Power);
%  map_pow=vec2cor(mpow,mminj);
%
% See also cor2vec, cpos2knum, ij2mminj, knum2cpos, sym_full
%          Control rods: mminj2crmminj
function core=vec2cor(vec2d,mminj,fcn)
if nargin<3, fcn=@zeros;end
l=length(mminj);
lv=size(vec2d);
kmax=lv(1);
if lv(1)>1&&lv(2)==1,
    vec2d=vec2d';
end

kan=sum(length(mminj)+2-2*mminj);
if size(vec2d,2)~=kan,
    prtstr=['mminj incompatible with input vector. size(vec2d,2)='...
        ,num2str(size(vec2d,2)),', kan derived from mminj=',num2str(kan)];
    if size(vec2d,2)==4*kan,
        prtstr=[prtstr,10,'You probably need to use mminj2x2.'];
    end
    error(prtstr);
end
if strcmp(class(fcn),'function_handle')
    if min(lv)==1,
        core=fcn(l,l);
    else
        core=fcn(l,l,kmax);
    end
else
    if min(lv)==1,
        core=fcn*ones(l,l);
    else
        core=fcn*ones(l,l,kmax);
    end
end
ind=0;
if min(lv)==1,
    for i=1:l,
        nind=l+2-2*mminj(i);
        core(i,mminj(i):l+1-mminj(i))=vec2d(ind+1:ind+nind);
        ind=ind+nind;
    end
else
    for k=1:kmax,
        ind=0;
           for i=1:l,
               nind=l+2-2*mminj(i);
               core(i,mminj(i):l+1-mminj(i),k)=vec2d(k,ind+1:ind+nind);
               ind=ind+nind;
           end
    end
end
    