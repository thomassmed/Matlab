%@(#)   distplot.m 1.21	 05/07/13     10:38:48
%
%function hfig=distplot(distfile,dist,pos,matvar);
%Input:
%  distfile - distribution file (string)
%  dist     - distribution name or matlab variable name (string)
%  pos      - position 1 by 4 vector with position of the figure, see also
%             the functions upright, upleft, loright, loleft (default upright)
%  matvar   - matlab variable, only needed when a matlab-variable is plotted
%
%Output:
%  hfig     - handle to figure
%
%Example: distplot('distr-1','POWER',upright) plots POWER
%of the file distr-1.dat in the upper right of the screen
function hfig=distplot(distfile,dist,pos,matvar);
file=which('distplot');
checkver(file,'/cm/tools/matlab/version.txt');
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
%hfig=figure('position',pos,'color',[0.8 0.8 0.8]);
hfig=figure('color',[0.8 0.8 0.8]);
set(hfig,'inverthardcopy','off');
h=zeros(100,1);

% Data menu
h(6)=uimenu('label','Data');
%h(7)=uicontrol('style','Pushbutton','position',[0.62 0.0 0.1 0.065],...
h(7)=uicontrol('style','Pushbutton','position',[350 0 60 30],...
'callback','cplot','string','Plot');
%'callback','cplot','string','Plot','units','normalized');

% Option menu
h(10)=uimenu('label','Option');
h(11)=uimenu(h(10),'label','max','callback','setprop(6,''max'');goplot');
h(12)=uimenu(h(10),'label','average','callback','setprop(6,''mean'');goplot');
h(13)=uimenu(h(10),'label','min','callback','setprop(6,''min'');goplot');
h(17)=uimenu(h(10),'label','minmax','callback','setprop(6,''minmax'');goplot');
h(14)=uimenu(h(10),'label','scale max','callback','scalesetmax');
h(15)=uimenu(h(10),'label','scale min','callback','scalesetmin');
h(18)=uimenu(h(10),'label','def scale','callback','defscwin');
h(16)=uimenu(h(10),'label','autoscale','callback','autoscale');

% Filter menu
h(20)=uimenu('label','Filter');
h(21)=uimenu(h(20),'label','show cr-modules','callback','crfilt,goplot');
h(22)=uimenu(h(20),'label','show buntyp','callback','bunfilt');
h(24)=uimenu(h(20),'label','MATLAB-vector','callback','getfil(''evalfiltvec=getmatvec;eval(evalfiltvec);'',''MATLAB-vector:'',[0.0 0.5 0.60 0.25]);');
h(23)=uimenu(h(20),'label','remove filter','callback','remfilt,goplot');

% Layout menu
h(30)=uimenu('label','Layout');
h(31)=uimenu(h(30),'label','controlrods');
h(32)=uimenu(h(31),'label','Black/white','callback','sstoggle');
h(33)=uimenu(h(31),'label','On/off','callback','ssremove');
h(35)=uimenu(h(30),'label','halfcore','callback','halfcore');
h(35)=uimenu(h(30),'label','fullcore','callback','fullcore');
h(36)=uimenu(h(30),'label','zoom','callback','zoom');
h(34)=uimenu(h(30),'label','flow pos');
h(35)=uimenu(h(34),'label','F1/F2','callback','flowp(''f1'')');
h(35)=uimenu(h(34),'label','F3','callback','flowp(''f3'')');
h(37)=uimenu(h(30),'label','tipsond');
h(29)=uimenu(h(37),'label','Black/red','callback','settippos(''blaredredbla'')');
h(28)=uimenu(h(37),'label','White/cyan','callback','settippos(''whicyacyawhi'')');
h(27)=uimenu(h(37),'label','Off','callback','settippos(''delete'')');
h(38)=uimenu(h(30),'label','brighten','callback','brighten(.5)');
h(39)=uimenu(h(30),'label','darken','callback','brighten(-.5)');
h(26)=uimenu(h(30),'label','flip scale','callback','flipscale');
set(h(26),'userdata',ncol);
h(25)=uimenu(h(30),'label','buntyp','callback','buntext');
h(120)=uimenu(h(30),'label','Labels');
h(121)=uimenu(h(120),'label','ij','callback','setprop(1,''IJ'');goplot;');
h(122)=uimenu(h(120),'label','AXIS','callback','setprop(1,''AXIS'');goplot;');

% Specials menu
h(40)=uimenu('label','Specials');
h(47)=uimenu(h(40),'label','Chan. value','callback','chanvalue');
h(49)=uimenu(h(40),'label','Chan. Info','callback','chaninfo');
h(41)=uimenu(h(40),'label','Axplot','callback','hax=setaxplot;axplot(hax)');
h(42)=uimenu(h(40),'label','Ind. Chan','callback','axchan');
h(48)=uimenu(h(40),'label','Arithmetics','callback','arnewfig(1),arnewfig(2)');
h(43)=uimenu(h(40),'label','Sdmvalues');
h(45)=uimenu(h(43),'label','Black/white','callback','sdmtoggle');
h(46)=uimenu(h(43),'label','On/off','callback','sdmremove');
h(44)=uimenu(h(40),'label','Nodplane','callback','nodplan');
h(53)=uimenu(h(40),'label','sc-axplot','callback','scaxplot');
h(55)=uimenu(h(40),'label','MATSTAB');
h(551)=uimenu(h(55),'label','Plot evoid','callback','plot_evoid(1);');
h(552)=uimenu(h(55),'label','Plot efi1','callback','plot_evoid(2);');
h(553)=uimenu(h(55),'label','Plot efi2','callback','plot_evoid(3);');

% Simulation menu
h(50)=uimenu('label','Simulation');
%h(123)=uimenu(h(50),'label','input_p4','callback','preplot');
h(124)=uimenu(h(50),'label','Input','callback','preplot7');
%h(51)=uimenu(h(50),'label','output_p4','callback','cyplot');
h(125)=uimenu(h(50),'label','Output','callback','cyplot7');
h(126)=uimenu(h(50),'label','Set Polca command','callback','getfil(''setpolcacmd;'',''Polca-command:'');');

% Info menu
h(60)=uimenu('label','Info');
h(61)=uimenu(h(60),'label','Polca','callback','ponoff');
%h(62)=uimenu(h(60),'label','General','callback','not_ready');

% Print menu
h(70)=uimenu('label','Print');
hdum=uimenu(h(70),'label','Graph to printer','callback','printer');
h(71)=uimenu(h(70),'label','Graph to file','callback','getgrafil');
h(72)=uimenu(h(70),'label','ASCII to file','callback','getprifil(2)');
h(73)=uimenu(h(70),'label','File, right','callback','getprifil(0)');
h(74)=uimenu(h(70),'label','ASCII to screen','callback','ASCprint(1,2)');
h(75)=uimenu(h(70),'label','Screen,right','callback','ASCprint(1)');

% C-rods menu
%h(80)=uimenu('label','C-rods');
%h(81)=uimenu(h(80),'label','Average','callback','avcr');
%h(82)=uimenu(h(80),'label','Tip','callback','tipcr');
%h(83)=uimenu(h(80),'label','Top Node','callback','topcr');
%h(84)=uimenu(h(80),'label','Top 6','callback','top6');
%h(85)=uimenu(h(80),'label','Top 6','callback','top6');

% Shuffle menu
h(90)=uimenu('label','Shuffle7');
h(91)=uimenu(h(90),'label','BOC-File','callback','getfil(''plvec=defboc;'',''BOC-File:'');');
h(113)=uimenu(h(90),'label','Make poolfile','callback','getfil(''sfg2pool7;'',''sfgfile:'');');
h(93)=uimenu(h(90),'label','Poolfile','callback','getfil(''defpool;'',''poolfile:'');');
h(92)=uimenu(h(90),'label','Manual shuffle','callback','plvec=manshuffle;','enable','off');
h(100)=uimenu(h(90),'label','Autoshuffle','enable','off');
h(101)=uimenu(h(100),'label','Right','callback','autoshuffle(''right'')');
h(102)=uimenu(h(100),'label','Left','callback','autoshuffle(''left'')');
h(94)=uimenu(h(90),'label','Autopool','enable','off');
h(103)=uimenu(h(94),'label','Right','callback','autopool(''right'')');
h(104)=uimenu(h(94),'label','Left','callback','autopool(''left'')');
h(95)=uimenu(h(90),'label','Unload by spec.','callback','unloadspec','enable','off');
h(96)=uimenu(h(90),'label','Update from infil','callback','getfil(''plvec=updinfil;'',''Infil:'');','enable','off');
h(97)=uimenu(h(90),'label','Monitor','callback','getfil(''plvec=monitor;'',''Infil:'');','enable','off');
h(114)=uimenu(h(90),'label','Find','callback','getfil(''sok;'',''asyid:'');','enable','off');
h(99)=uimenu(h(90),'label','Help','callback','shuffhelp');

% Refuel menu
h(110)=uimenu('label','Refuel');
h(112)=uimenu(h(110),'label','polca7','callback','refuwin');

% Gui controls
h(9)=uicontrol('style','Pushbutton','position',[0 0 42 29],'string','File...','callback','getdisfil');
h(1)=uicontrol('style','edit','position',[42 0 300 29],'callback',...
'opfile');
set(h(1),'userdata','cmfil');
h(4)=axes('position',[0.90 0.12 0.09 0.8]);
h(5)=plot([0.1 0.1],'visible','off');
ud=str2mat('scale','new');
set(h(4),'userdata',ud);
h(2)=axes('position',[0.05 0.12 0.75 0.8]);
ud=str2mat('core','image  ','colormap(jett)','POWER','','mean','0','1','auto');
ud=str2mat(ud,'new','no ','no ','black','black','1:25','on ','off','off','no');
ud=str2mat(ud,'no');
set(h(2),'userdata',ud);
set(h(14),'userdata',0);
set(hfig,'userdata',h);
set(h(43),'userdata',[]);
set(h(50),'userdata',0)
if nargin>0,
  set(h(1),'string',distfile);
  opfile
  if nargin>1, 
     dnam=dist;
     if nargin>3,
       hM=get(h(6),'userdata');
       set(hM,'label',dist);
       dnam=['MATLAB:',dist];
       ud=str2mat(ud(1:3,:),dnam,distfile,ud(6:size(ud,1),:)); 
       set(h(2),'userdata',ud);
       init(dnam,matvar);
     else     
       dnam=upper(dnam);
       init(dnam);
     end
  else 
     ud=str2mat(ud(1:4,:),distfile,ud(6:size(ud,1),:)); 
     set(h(2),'userdata',ud);
  end
end
     
