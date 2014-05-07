%@(#)   tippos.m 1.6	 06/02/06     08:40:03
%
handles=get(gcf,'userdata');
hpl=handles(2);
if gca~=hpl, axes(hpl);end
ud=get(hpl,'userdata');
distfile=ud(5,:);
tippo=ud(19,:);
colvec=[tippo(1:3);tippo(4:6);tippo(7:9);tippo(10:12)];
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfile);
nsond=max(detpos);
i=1:nsond;
detpos=findint(i,detpos);
cpos=knum2cpos(detpos,mminj);
i=find(staton==' ');staton(i)=[];
subfil=[staton,'sond.mat'];
fid=fopen(subfil,'r');
if fid==(-1)
  ld=length(detpos);
  tdo=zeros(ld,1);
  for i=1:ld,tdo(i)='o';end
  htip=text(cpos(:,2)+0.85,cpos(:,1)+0.92,setstr(tdo),'color',tippo(1:3));
else
  load(subfil)
  lt=length(ia);
  tdo=zeros(lt,1);
  for i=1:lt,tdo(i)='o';end
  cpos=knum2cpos(detpos(ia),mminj);
  ha=text(cpos(:,2)+0.85,cpos(:,1)+0.92,setstr(tdo),'color',colvec(1,:));
  haa=text('String','Ao','Position',[.02 0.03],'units','normalized','color',colvec(1,:));
  lt=length(ib);
  tdo=zeros(lt,1);
  for i=1:lt,tdo(i)='x';end
  cpos=knum2cpos(detpos(ib),mminj);
  hb=text(cpos(:,2)+0.85,cpos(:,1)+0.92,setstr(tdo),'color',colvec(2,:));
  hbb=text('String','Bx','Position',[0.08 0.03],'units','normalized','color',colvec(2,:));
  lt=length(ic);
  tdo=zeros(lt,1);
  for i=1:lt,tdo(i)='+';end
  cpos=knum2cpos(detpos(ic),mminj);
  hc=text(cpos(:,2)+0.85,cpos(:,1)+0.92,setstr(tdo),'color',colvec(3,:));
  hcc=text('String','C+','Position',[0.13 0.03],'units','normalized','color',colvec(3,:));
  lt=length(id);
  tdo=zeros(lt,1);
  for i=1:lt,tdo(i)='*';end
  cpos=knum2cpos(detpos(id),mminj);
  hd=text(cpos(:,2)+0.85,cpos(:,1)+1.08,setstr(tdo),'color',colvec(4,:));
  hdd=text('String','D*','Position',[0.18 0.03],'units','normalized','color',colvec(4,:));
  htip=[ha;haa;hb;hbb;hc;hcc;hd;hdd];
end
set(handles(37),'userdata',htip);
set(hpl,'Userdata',ud);
