%@(#)   cyenv7.m 1.4	 06/01/12     13:52:03
%
function cyenv7(min_max)
hval=get(gcf,'userdata');
hpar=hval(length(hval));
dlist=get(hval(1),'string');
v=get(hval(1),'value');
distname=dlist(v,:);
load sim/simfile;
if strcmp(distname,'SDM     ')|strcmp(distname,'SDM3D   ')
  filenames=sdmfiles;
else
  s=size(filenames);
  if length(bocfile)<s(2),bocfile=[bocfile setstr(32*ones(1,s(2)-length(bocfile)))];end
  if length(bocfile)>s(2),filenames=[filenames setstr(32*ones(s(1),length(bocfile)-s(2)))];end
  filenames=[bocfile; filenames];
end
s=size(filenames);
[env,ivec,symme]=envelop7(filenames,distname,min_max);
figure(hpar);
str=sprintf('%s%s','MATLAB:env',distname);
setprop(4,str);
ccplot(env);
if strcmp(min_max,'min'),e=min(env); else e=max(env);end
i=find(env==e);
j=ivec(i(1));
[asyid,mminj,konrod,bb,hy,mz,ks,asytyp]=readdist7(bocfile,'asyid');
if ~strcmp(distname,'SDM     ')&~strcmp(distname,'SDM3D   ')
  [right,left]=knumhalf(mminj);
  f=find(i(1)==left);
  if ~isempty(f)
    if env(i(1))==env(right(f))
      i(1)=right(f);
    end
  end
  [d,order]=sort(env);
  if strcmp(min_max,'max'),order=fliplr(order);end
  rightorder=findint(order,right);
  rightorder=right(rightorder(find(rightorder)));
  fprintf('\n');
  for k=1:9
    if symme==3
      efph=min(readdist7(filenames(ivec(rightorder(k)),:),'efph'));
      bun=asytyp(rightorder(k),:);
      bui=asyid(rightorder(k),:);
      yx=knum2cpos(rightorder(k),mminj);
      text(yx(2)+.2,yx(1)+.5,sprintf('%i',k),'color','bla','fontan','italic');
      fprintf('%2i (%2i,%2i): %8.3f  %5.0f  %4s  %16s\n',k,yx(1),yx(2),env(rightorder(k)),efph,bun,bui);
    else
      efph=min(readdist7(filenames(ivec(rightorder(k)),:),'efph'));
      bun=asytyp(order(k),:);
      bui=asyid(order(k),:);
      yx=knum2cpos(order(k),mminj);
      text(yx(2)+.2,yx(1)+.5,sprintf('%i',k),'color','bla','fontan','italic');
      fprintf('%2i (%2i,%2i): %8.3f  %5.0f  %4s  %16s\n',k,yx(1),yx(2),env(order(k)),efph,bun,bui);
    end
  end
else
  [d,order]=sort(env);
  if strcmp(min_max,'max'),order=fliplr(order);end
  fprintf('\n');
  for k=1:9
    yx=knum2cpos(crpos2knum(crnum2crpos(order(k),mminj),mminj),mminj);
    fprintf('%2i (%2i,%2i)   %5i   %5.2f\n',k,yx(1,1),yx(1,2),blist(ivec(order(k))),env(order(k)))
    text(yx(1,2)+.5,yx(1,1)+1,sprintf('%i',k),'color','bla','fontan','italic');
  end
end
