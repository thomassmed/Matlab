%@(#)   cyenv.m 1.13	 98/10/26     10:38:56
%
function cyenv(min_max)
hmat=get(gcf,'userdata');
hvec=hmat(1,:);
ll=length(hvec)-2;
hpar=hvec(ll+1);
hand=get(hpar,'userdata');
refdist=get(hand(51),'userdata');
for i=1:ll
  j(i)=get(hvec(i),'value');
end
i=find(j);
distname=refdist(i,:);
load('simfile');
s=size(filenames);
if length(bocfile)<s(2),bocfile=[bocfile setstr(32*ones(1,s(2)-length(bocfile)))];end
if length(bocfile)>s(2),filenames=[filenames setstr(32*ones(s(1),length(bocfile)-s(2)))];end
s=size(filenames);
filenames=[bocfile; filenames];
[env,ivec,symme]=envelop(filenames,distname,min_max);
figure(hpar);
str=sprintf('%s%s','MATLAB:env',distname);
setprop(4,str);
ccplot(env);
if strcmp(min_max,'min'),e=min(env); else e=max(env);end
i=find(env==e);
j=ivec(i(1));
[buidnt,mminj,konrod,bb,hy,mz,ks,buntyp]=readdist(bocfile,'buidnt');
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
    efph=min(readdist(filenames(ivec(rightorder(k)),:),'efph'));
    bun=buntyp(rightorder(k),:);
    bui=buidnt(rightorder(k),:);
    yx=knum2cpos(rightorder(k),mminj);
    text(yx(2)+.2,yx(1)+.5,sprintf('%i',k),'color','bla','fontan','italic');
    fprintf('%2i%s%2i%s%2i%2s%9.3f%7.0f%7s%8s\n',k,'  (',yx(1),',',yx(2),'): ',env(rightorder(k)),efph,bun,bui);
  else
    efph=min(readdist(filenames(ivec(rightorder(k)),:),'efph'));
    bun=buntyp(order(k),:);
    bui=buidnt(order(k),:);
    yx=knum2cpos(order(k),mminj);
    text(yx(2)+.2,yx(1)+.5,sprintf('%i',k),'color','bla','fontan','italic');
    fprintf('%2i%s%2i%s%2i%2s%9.3f%7.0f%7s%8s\n',k,'  (',yx(1),',',yx(2),'): ',env(order(k)),efph,bun,bui);
  end
end
