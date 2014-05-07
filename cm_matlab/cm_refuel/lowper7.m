%@(#)   lowper7.m 1.1	 00/11/23     10:09:05
%
function lowper7
xm=[];
ym=[];
h=get(gcf,'userdata');
hpar=h(length(h));
hus=get(hpar,'userdata');
ud=get(hus(2),'userdata');
bocfile=remblank(ud(5,:));
fr=get(h(9),'string');
bockhot=readdist7(bocfile,'khot');
[bocbunt,mminj]=readdist7(bocfile,'asytyp');
[right,left]=knumhalf(mminj);
sym=get(h(8),'string');
mmat=get(h(14),'userdata');
vec=randvec(mminj);
randpos=find(vec==1);
i=mbucatch(bocbunt,fr);
perfr=find(i'.*vec==1);
[khot,k]=sort(bockhot);
if isempty(perfr)
  bockhot(randpos)=bockhot(randpos)+1;
  [khot,k]=sort(bockhot);
  randpos=find(vec==2);
  i=mbucatch(bocbunt,fr);
  perfr=find(i'.*vec==2);
end
if ~isempty(perfr)
  j=find(findint(k,randpos));
  khot(j)='';
  k(j)='';
  centpos=k(1:length(perfr));
  if strcmp(sym,'3')
    j=find(findint(perfr,left));
    perfr(j)='';
    j=find(findint(centpos,left));
    centpos(j)='';
    j=find(findint(k,left));
    k(j)='';
    l=length(perfr);
    centpos=k(1:l);
  end
  figure(hpar)
  for i=1:length(perfr)
    yx=knum2cpos(perfr(i),mminj);
    xm=[xm 0 yx(2)];
    ym=[ym 0 yx(1)];
    X=[yx(2) yx(2)+.5 yx(2)+1];
    Y=[yx(1)+1 yx(1)+.5 yx(1)+1];
    patch(X,Y,[1 1 1]*0)
    if strcmp(sym,'3')
      yx=knum2cpos(size(bocbunt,1)+1-perfr(i),mminj);
      X=[yx(2) yx(2)+.5 yx(2)+1];
      Y=[yx(1)+1 yx(1)+.5 yx(1)+1];
      patch(X,Y,[1 1 1]*0)
    end
    yx=knum2cpos(centpos(i),mminj);
    xm=[xm yx(2)];
    ym=[ym yx(1)];
    X=[yx(2) yx(2)+.5 yx(2)+1];
    Y=[yx(1)+1 yx(1)+.5 yx(1)+1];
    patch(X,Y,[1 1 1]*1)
    if strcmp(sym,'3')
      yx=knum2cpos(size(bocbunt,1)+1-centpos(i),mminj);
      X=[yx(2) yx(2)+.5 yx(2)+1];
      Y=[yx(1)+1 yx(1)+.5 yx(1)+1];
      patch(X,Y,[1 1 1]*1)
    end
  end
end
temp=[xm;ym];
mmat=[mmat temp];
set(h(14),'userdata',mmat);
