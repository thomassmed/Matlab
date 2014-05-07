%@(#)   shuffplot.m 1.1	 05/07/13     10:29:42
%
%
%function hfig=shuffplot(distfile,bocfil,pos)
%Input:
%  distfile - distribution file (string)
%  bocfil   - boc-file (string)
%  pos      - position 1 by 4 vector with position of the figure, see also
%             the functions upright, upleft, loright, loleft (default upright)
%
%Output:
%  hfig     - handle to figure
%
%Example: distplot('distr-1','POWER',upright) plots POWER
%of the file distr-1.dat in the upper right of the screen
function hfig=shuffplot(distfile,bocfil)
ncol=10;
if nargin<3
  pos=upright;
else
  ij=size(pos);
  ip=min(ij);jp=max(ij);
  if ip~=1|jp~=4
    pos=upright;
  end
end
hfig=figure('position',pos,'color',[0.8 0.8 0.8]);
set(hfig,'inverthardcopy','off');
h=zeros(90,1);
h(10)=uimenu('label','File');
h(11)=uimenu(h(10),'label','Current','callback','curfile;goplot');
h(12)=uimenu(h(10),'label','BOC-File','callback','bocfile;goplot');
h(13)=uimenu(h(10),'label','Exit','callback','exitshuffle');
h(20)=uimenu('label','Shuffle');
h(21)=uimenu(h(20),'label','Manual','callback','crfilt,goplot');
h(22)=uimenu(h(20),'label','Autoshuffle','callback','bunfilt');
h(23)=uimenu(h(20),'label','Autopool','callback','remfilt,goplot');
h(24)=uimenu(h(20),'label','Unload by spec.','callback','unloadspec;goplot');
h(25)=uimenu(h(20),'label','Help','callback','shuffhelp');
h(4)=axes('position',[0.90 0.12 0.09 0.8]);
h(5)=plot([0.1 0.1],'visible','off');
ud=str2mat('scale','new');
set(h(4),'userdata',ud);
h(2)=axes('position',[0.05 0.12 0.75 0.8]);
ud=str2mat('core','image  ','colormap(jett)','POWER','','mean','0','1','auto');ud=str2mat(ud,'new','no ','no ','black','no ','1:25','on ','off','off','no');
ud=str2mat(ud,'no');
set(h(2),'userdata',ud);
set(hfig,'userdata',h);
end
