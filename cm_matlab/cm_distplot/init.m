%@(#)   init.m 1.5	 97/11/03     12:10:50
%
function  hpl=init(dname,matvar)
handles=get(gcf,'userdata');
if nargin==0
  hf=gcbo;
  dname=get(hf,'label');
end
hfil=handles(1);
hpl=handles(2); if gca~=hpl, axes(hpl);end
ud=get(hpl,'userdata');
distfile=ud(5,:);
if size(ud,1)==0|strcmp(ud(10,1:3),'new')|~strcmp(dname(1:3),ud(4,1:3))
  ncol=get(handles(26),'userdata');
  ncolstr=sprintf('%i',round(ncol));
  clmap=['colormap(jett)'];
  if size(ud,1)==0|strcmp(ud(3,1:3),'new')
    axtyp='core';
    plottyp='image  ';
    option='mean';
    cmax=0;
    cmin=1.80;
    cminstr=num2str(cmin);
    cmaxstr=num2str(cmax);
    rescale='auto';
    axiss='new';
    bunstr='no ';
    crfiltstr='no ';
    crods='black';
    sdmval='black';
    nodplan='1:25';
    superc='on ';
    pinfo='off';
    ginfo='off';
    tippo='no';
    axpl='no';
    ud=str2mat(axtyp,plottyp,clmap,dname,distfile,option,cminstr,...
     cmaxstr,rescale,axiss);
    ud=str2mat(ud,bunstr,crfiltstr,crods,sdmval,nodplan,superc,...
     pinfo,ginfo,tippo,axpl);
  else
    ud=str2mat(ud(1:2,:),clmap,dname,ud(5:8,:),'auto',ud(10:size(ud,1),:));
  end
  fchstr=sprintf('%6s%4s',dname,'.mat');
  i=find(fchstr==' ');fchstr(i)='';
  z=fopen(fchstr);
  if z~=-1
    i=fclose(z);
  end
  if z>2
    load(remblank(dname));
    i=find(distfile==' ');distfile(i)='';
    if size(ud,1)==0|strcmp(ud(3,1:3),'new')
      ud=str2mat(defa(1:4,:),distfile,defa(6:size(ud,1),:));
    else
      ud=str2mat(defa(1:4,:),distfile,defa(6:9,:),ud(10:size(ud,1),:));
    end
  end
set(hpl,'Userdata',ud);
else
  if length(dname)>size(ud,2),
    ud=str2mat(ud(1:3,:),dname,ud(5:size(ud,1),:));
  else
    ud(4,1:length(dname))=dname;
  end
  set(hpl,'Userdata',ud);
end
if nargin==2,
 ccplot(matvar);
else
 ccplot;
end
