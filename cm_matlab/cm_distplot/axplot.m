%@(#)   axplot.m 1.4	 05/12/08     08:32:55
%
function h=axplot(fig)
curf=gcf;
handles=get(gcf,'userdata');
if nargin==1,
  if max(size(fig))==1
    figure(fig);
  else
    h=figure('position',fig);
  end
else,
  p=get(gcf,'position');
  pnew=p;
  pnew=[5 p(2) 540 420];
  if (p(1)+p(3))<600, pnew(1)=580;end
  h=figure('position',pnew);
end
hpl=handles(2);
ud=get(hpl,'userdata');
dname=ud(4,:);
distfile=ud(5,:);
i=find(distfile==' ');distfile(i)='';
option=ud(6,:);
cminstr=ud(7,:);
cmaxstr=ud(8,:);
cmin=str2num(cminstr);
cmax=str2num(cmaxstr);
bunstr=(ud(11,:));
crfiltstr=(ud(12,:));
crods=(ud(13,:));
Nod=(ud(15,:));
if strcmp(dname(1:7),'MATLAB:')
  [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfile);
  hM=get(handles(6),'userdata');
  dist=get(hM,'userdata');
else
  [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfile,deblank(dname));
end
if strcmp(ud(11,1:3),'yes')
  temp=get(handles(22),'userdata');
  bunfiltmap=vec2core(temp(1,:),mminj);
else
  bunfiltmap=ones(length(mminj));
end
if strcmp(ud(12,1:3),'yes')
  temp=get(handles(21),'userdata');
  crfiltmap=vec2core(temp,mminj);
else
  crfiltmap=ones(length(mminj));
end
filtmap=bunfiltmap.*crfiltmap;
filtvec=cor2vec(filtmap,mminj);
antal=sum(filtvec);
if size(dist,1)>1
  for i=1:mz(11)
    dist(i,:)=dist(i,:).*filtvec;
  end
  if strcmp(ud(6,1:4),'mean')
    dist=dist.*(mz(14)/antal);
  end
  i=find(Nod==' ');Nod(i)='';
  evno=['nod=(',Nod,');'];
  eval(evno);
  evpl=['plot(',ud(6,:),'(dist(',Nod,',:)'')'',nod)'];eval(evpl);
  rubrik=sprintf('%s%14s%s%20s%s%17s%s',dname(1:6),'option:',option(1:4),'buntypfilter:',bunstr(1:3),'cr-filter:',crfiltstr(1:3));
  title(rubrik)
  grid
  set(gcf,'name',distfile)
  set(gcf,'numbertitle','off')
else
  disp('Axplot not meaningful for this 2-d distribution');
end
figure(curf);
