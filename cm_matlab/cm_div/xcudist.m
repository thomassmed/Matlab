%function [xcu,pow,efph,hc]=xcudist(distfiles,powlim);
%This function gives cu and power and efph
%for a given set of distr.files
%Input: 
%   distfiles - vector of distr. files
%   powlim    - relative power limit (default=1.0), exclude files for which
%               the relative power (Qrel) is > powlim
function [xcu,pow,efph,hc]=xcudist(distfiles,powlim);
if nargin<2,
  powlim=1.0;
elseif powlim>10,  % Assume power is given in %
  powlim=powlim/100;
end
for i=1:size(distfiles,1),
  [efp,mminj,konrod,bb,hy,mz,ks]=readdist(distfiles(i,:),'efph');
  efp=min(efp);
  if bb(1)>powlim,
     xcu=[xcu;bb(4)];
     pow=[pow;bb(1)];
     efph=[efph;efp];
     hc=[hc;bb(2)];
  end
end
