%@(#)   readdist7.m 1.9	 06/01/23     14:11:09
%
%function [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
% staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(filename,distname)
function [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(filename,distname)
if nargin==1,
  [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=dist2mlab7(filename);
else [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=dist2mlab7(filename,distname);
end
if nargin==2,
  switch upper(distname)
    case 'ASYTYP'
      dist=flipud(rot90(reshape(dist,4,mz(14))));
    case 'CRTYP'
      dist=flipud(rot90(reshape(dist,4,mz(69))));
    case {'ASYID','CRID'}
      ll=length(dist)/16;
      dist=flipud(rot90(reshape(dist,16,ll)));
  end
end
if nargout>7,
  ll=length(asytyp)/4;
  asytyp=flipud(rot90(reshape(asytyp,4,ll)));
end
if nargout>8,
  ll=length(asyref)/4;
  asyref=rot90(reshape(asyref,4,ll));
end
if nargout>9,
  ll=length(distlist)/8;
  distlist=rot90(reshape(distlist,8,ll));
end
