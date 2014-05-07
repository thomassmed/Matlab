%@(#)   MATLABvar.m 1.5	 98/04/08     12:59:41
%
function MATLABvar
curf=gcf;
pos=get(gcf,'position');
handles=get(gcf,'userdata');
hfil=handles(1);
hplott=handles(2);
h1=handles(6);
hmatlab=get(h1,'userdata');
varstring=get(hmatlab,'label');
ud=get(hplott,'userd');
eval(ud(3,:));
if strcmp(varstring,'MATLAB')
  varstring='';
end
hMATL=figure('position',[pos(1:2)+pos(3:4)-[600 200],350,150]);
figure(hMATL);
ledtext=['MATLAB-variable:'];
hdum=uicontrol('style','text','string',ledtext,'units','normalized',...
'position',[0.05 0.5 0.35 0.25]);
hmat=uicontrol('style','edit','string',varstring,'units','normalized',...
'position',[0.42 0.5 0.5 0.25]);
hand=[hmat;curf;hplott;h1;hfil];
set(hMATL,'userdata',hand);
happly=uicontrol('style','Pushbutton','units','normalized',...
'position',[0.1 0.2 0.30 0.15],'callback','matvarapply;matvarread;',...
'string','Apply');
hcancel=uicontrol('style','Pushbutton','units','normalized','position',...
[0.6 0.2 0.30 0.15],'callback',...
'hand=get(gcf,''userdata'');delete(gcf);figure(hand(2));','string','Cancel');
