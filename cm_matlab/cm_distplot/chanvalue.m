%@(#)   chanvalue.m 1.2	 94/01/25     12:42:11
%
function chanvalue
handles=get(gcf,'userdata');
hpl=handles(2);
if gca~=hpl, axes(hpl);end
ud=get(hpl,'userdata');
cminstr=ud(7,:);
cmaxstr=ud(8,:);
cmin=str2num(cminstr);
cmax=str2num(cmaxstr);
epsi=1.0d-4*(cmax-cmin);
cmax=cmax+epsi;
cmin=cmin-epsi;
hinstr=text('String','left button to select','Position',[0.8 0.95],'color','black','units','normalized');
hinstr1=text('String','right to quit','Position',[0.8 0.975],'color','black','units','normalized');
button=1;
plmat=get(handles(3),'cdata');
disp(sprintf('\n'));
ncol=get(handles(26),'userdata');
if cmin<=0,
  i=find(plmat==-1);
end
plmat=(cmax-cmin)/ncol*(plmat-2)+cmin;
if cmin<=0,
  plmat(i)=zeros(size(i));
end
while button==1
 [xx,yy,button]=ginput(1);
  if button==1
    nx=fix(xx);
    ny=fix(yy);
    co=plmat(ny,nx);
    if abs(co)<epsi/2, co=0;end
    disp(['(',sprintf('%2i',ny),',',sprintf('%2i',nx),'): ',sprintf('%8.4g',co)]);
  end
end
disp(sprintf('\n'));
delete(hinstr);
delete(hinstr1);
