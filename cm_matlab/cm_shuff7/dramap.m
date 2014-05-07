%@(#)   dramap.m 1.1	 05/07/13     10:29:30
%
%
%function plvec=dramap(curfil,bocfil,OK,plotta,poolfil)
function plvec=dramap(curfil,bocfil,OK,plotta,poolfil)
if nargin<4, plotta=0;end
buid=readdist7(curfil,'asyid');
kkan=size(buid,1);
if nargin<3, OK=ones(kkan,1);end
buidboc=readdist7(bocfil,'asyid');
[from,to,ready,fuel]=initvec(buid,buidboc,OK);
plvec=fuel.*(5*(to>0).*(1-ready)+4*ready+7*(to==0).*fuel);
plvec=plvec';
if plotta==1,
  distplot(curfil,'plvec',upright,plvec);
  mapprop;
  ccplot(plvec);
  handles=get(gcf,'userdata');
  set(handles(91),'userdata',bocfil);
  set(handles(92),'enable','on');
  set(handles(100),'enable','on');
  set(handles(94),'enable','on');
  set(handles(95),'enable','on');
  set(handles(96),'enable','on');
  if poolfil~=[], set(handles(97),'userdata',poolfil);end
end
