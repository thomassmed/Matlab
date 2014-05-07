%@(#)   updinfil.m 1.2	 10/09/09     10:44:41
%
%
%function plvec=updinfil(infil,curfil,dumbun,dumburn);
function plvec=updinfil(infil,curfil,dumbun,dumburn);
hand=get(gcf,'userdata');   
if nargin<1,
  infil=get(hand(2),'string');
  delete(gcf);
  figure(hand(1));
end
if nargin<2,
  curfil=setprop(5);
end
handles=get(gcf,'userdata');
[to,buidnt,lline,cr]=sfg2mlab(infil);
bocfil=get(handles(91),'userdata');
poolfil=get(handles(93),'userdata');
[buid,mminj,konrod,bb,hy,mz,ks,buntyp]=readdist7(curfil,'asyid');
burn=readdist7(curfil,'burnup');
j=strmatch('vat',buid(:,1:3));		%Har lagt till ett mellanslag
if length(j)>0,
  jdum=j(1);
  dumbun=buntyp(jdum,:);
  dumburn=mean(burn(:,jdum));
elseif nargin<4,
  [burnboc,mminj,konrod,bb,hy,mz,ks,bunboc]=readdist7(bocfil,'burnup');
  [burnboc,ibu]=sort(burnboc);
  defbun=bunboc(ibu(length(ibu)-10),:);
  if nargin<3,
    istr=['Give dummy BUNTYP (default=',defbun,'): '];
    dubun=input(istr,'s');
    if length(dubun)>0 dubun=remblank(dubun);end
    if length(dubun)>0,
      dumbun=dubun;
    else
      dumbun=defbun;
    end
  end
  defburn=45000;
  duburn=input('Dummy average burnup (default=45000)','s');
  if length(duburn)>0,  duburn=remblank(duburn);end
  if length(duburn)>0,
    dumburn=str2num(duburn);
  else
    dumburn=45000;
  end
end
updatbp(curfil,buidnt(find(cr==0),:),to(find(cr==0),:),bocfil,dumbun,dumburn);
if length(remblank(poolfil))>0,
  updatpo(poolfil,buidnt(find(cr==0),:),lline(find(cr==0),:));
end
OK=ones(1,mz(14));
plvec=dramap(curfil,bocfil,OK);
ccplot(plvec);
hM=get(handles(6),'userdata');
set(hM,'userdata',plvec);

