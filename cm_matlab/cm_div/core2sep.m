function [Xsep,Msep,Mstsep]=core2sep(distfil,xsep,ysep);
% [Xsep,Msep,Mstsep]=core2sep(distfil,xsep,ysep);
%
% Calculates steam quality(Xsep), total flow (Msep),
% and steam flow (Mstsep) for each separator for a given.
% POLCA distribution file
%
%   Input:
%     distfil - distribution file from POLCA
%     xsep    - X-coordinate for each separator 125 by 1
%     ysep    - Y-coordinate for each separator 125 by 1

% Written: 1995-01-19  Thomas Smed
[chflow,mminj,konrod,bb,hy,mz]=readdist7(distfil,'chflow');
pow=readdist7(distfil,'power');
kkan=length(chflow);
XY=ij2xy(knum2cpos((1:kkan)',mminj));
P=zeros(length(XY),length(xsep));
for i=1:size(XY,1),
  DX=XY(i,1)-xsep;
  DY=XY(i,2)-ysep;
  R2=DX.*DX+DY.*DY;
  iR=find(R2<.564^2);
  ETTGR2=1./R2(iR);
  P(i,iR)=ETTGR2'/sum(ETTGR2);
end
Msep=chflow*P;
hc=hy(2);
c=sum(chflow);
tlowp=hy(14); hlowp=hy(13); h286=entT(286)*1e3; Qtot=hy(11)*hy(1);
hfg=1.50673e6;
mp=mean(pow);mp=mp/sum(mp);
Hout=hlowp+Qtot*mp./chflow;
XCH=(Hout-h286)/hfg;
MstCH=XCH.*chflow;
%mfeed=hy();
%cu=bb();
%Msteam=mfeed+cu*(hc-mfeed);
%mp=mean(pow);mp=mp/sum(mp);
%MstCH=Msteam*mp;
Msep=chflow*P;
Mstsep=MstCH*P;
Xsep=Mstsep./Msep;
end
