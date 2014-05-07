%@(#)   dramap1.m 1.1	 05/07/13     10:29:30
%
%
%function [plvec1,plvec]=dramap1(eocfil,urladdfil,bocfil,OK,plotta)
function [plvec1,plvec]=dramap1(eocfil,urladdfil,bocfil,OK,plotta)
if nargin<5, plotta=0;end
buid=readdist7(urladdfil,'asyid');
kkan=size(buid,1);
if nargin<4, OK=ones(kkan,1);end
buidboc=readdist7(bocfil,'asyid');
[from,to,ready,fuel]=initvec(buid,buidboc,OK);
plvec=fuel.*(5*(to>0).*(1-ready)+4*ready+7*(to==0).*fuel);
buideoc=readdist7(eocfil,'asiyd');
[from1,to1,ready1,fuel1]=initvec(buideoc,buidboc,OK);
plvec1=fuel1.*(5*(to1>0).*(1-ready1)+4*ready1+7*(to1==0).*fuel1);
ii=find(plvec1==7);
plvec1(ii)=8*ones(size(ii));
ii=find(plvec1==5);
plvec1(ii)=10*ones(size(ii));
ii=find(plvec==0&plvec1==10);
plvec1(ii)=2*ones(size(ii));
ii=find(plvec==0&plvec1==4);
plvec1(ii)=3*ones(size(ii));
ii=find(plvec==0&plvec1==8);
plvec1(ii)=7*ones(size(ii));
plvec=plvec';
plvec1=plvec1';
if plotta>0,
  distplot(eocfil,'plvec1',upright,plvec1);
  setprop(7,'0.01');
  setprop(8,'10');
  setprop(9,'yes');
  setprop(3,'colormap(shuffcolor)');
  ccplot(plvec1);
  if plotta>1,
    distplot(eocfil,'plvec',upleft,plvec);
    setprop(7,'0');
    setprop(8,'10');
    setprop(3,'colormap(shuffcolor)');
    ccplot(plvec);end
  end
end
