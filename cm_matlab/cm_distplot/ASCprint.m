%@(#)   ASCprint.m 1.4	 05/12/08     08:32:55
%
function ASCprint(pri,lr)
if pri==0,
  hand=get(gcf,'userdata');   
  prifil=get(hand(2),'string');
  delete(gcf);
  figure(hand(1));
end
if nargin==0, pri=1;end
if nargin<2, lr=0;end
dname=setprop(4);
distfile=setprop(5);
pltyp=setprop(6);
cminstr=setprop(7);
cmaxstr=setprop(8);
bunon=setprop(11);
cron=setprop(12);
cmin=str2num(cminstr);
cmax=str2num(cmaxstr);
epsi=1.0d-4*(cmax-cmin);
cmax=cmax+epsi;
cmin=cmin-epsi;
if strcmp(dname(1:3),'MAT')
  [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfile);
else
  [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfile,dname);
end
CROD=0;
if mz(69)==size(dist,2), CROD=1;end
handles=get(gcf,'userdata');
plmat=get(handles(3),'cdata');
ncol=get(handles(26),'userdata');
core=(plmat-2)*(cmax-cmin)/ncol+cmin;
%if strcmp(bunon(1:2),'ye')
%  temp=get(handles(22),'userdata');  
%  bunfiltmap=temp((size(bunref,1)+1):size(temp,1),:);
%else
%  bunfiltmap=ones(length(mminj));
%end
%if strcmp(cron(1:2),'ye')
%  crfiltmap=get(handles(21),'userdata');
%else
%  crfiltmap=ones(length(mminj));
%end
minfilt=ones(30);
i=find(core<cmin);minfilt(i)=zeros(size(i));
maxfilt=ones(30);
i=find(core>cmax);maxfilt(i)=zeros(size(i));
%filtmap=crfiltmap.*bunfiltmap.*minfilt.*maxfilt;
filtmap=minfilt.*maxfilt;
core=core.*filtmap;
dis2d=cor2vec(core,mminj);
filtvec1=get(handles(21),'userdata');
fi=get(handles(22),'userdata');
filtvec2=fi(1,:);
filtvec3=get(handles(24),'userdata');
filtvec=filtvec1.*filtvec2.*(filtvec3>0);
dis2d=dis2d.*filtvec;
ntot=sum(sum(filtmap));
avd=sum(dis2d)/ntot;
i=find(abs(dis2d)>10*epsi);dissc=dis2d(i);
[md,isc]=max(dissc);
imax=i(isc);
[mind,isc]=min(dissc);
imin=i(isc);
if isempty(i),imax=0;imin=0;end
maxd=md;
comax=knum2cpos(imax,mminj);
comin=knum2cpos(imin,mminj);
if CROD==1,
  comax=fix((comax+1)/2);
  comin=fix((comax+1)/2);
  dis2d=core2cr(core,mminj);
end
md=abs(md);
if abs(mind)>md, md=abs(mind);end
sca=1;
isc=0;
if md>1000
  while md>1000,md=md/10;isc=isc+1;sca=sca*0.1;end
elseif md<100
  while md<100,md=md*10;isc=isc-1;sca=sca*10;end
end
dis2d=round(dis2d*sca);
if pri==0
  fid=fopen(prifil,'w');
  fprintf(fid,'\n');
  fprintf(fid,'%s',' ',distfile,'   ',pltyp,'   ',dname,'  Scal power = ');
  fprintf(fid,'%i',isc);
  fprintf(fid,'\n');
  fprintf(fid,'%s%8g%s%i%s%i%s',' Max: ',maxd,' at (',comax(1),',',comax(2),')');
  fprintf(fid,'%s%8g%s%i%s%i%s%g%s%i','   Min: ',mind,' at (',comin(1),',',comin(2),')  Mean: ',avd,'  Number of bundles: ',ntot);
  fprintf(fid,'\n');
  fprintf(fid,'\n');
  if lr==2,
    if CROD==1,
      cr2fil(dis2d,mminj,fid);
    else
      hcor2fil(dis2d,mminj,lr,fid);
    end
    fprintf(fid,'\n');
  end
  if CROD==1,
    cr2fil(dis2d,mminj,lr,fid);
  else
    hcor2fil(dis2d,mminj,0,fid);
  end
  if lr==2,
    fprintf(fid,'\n');
    fprintf(fid,'%s',' ',distfile,'   ',pltyp,'   ',dname,'  Scal power = ');
    fprintf(fid,'%i',isc);
    fprintf(fid,'\n');
    fprintf(fid,'%s%8g%s%i%s%i%s',' Max: ',maxd,' at (',comax(1),',',comax(2),')');
    fprintf(fid,'%s%8g%s%i%s%i%s%g%s%i','   Min: ',mind,' at (',comin(1),',',comin(2),')  Mean: ',avd,'  Number of bundles: ',ntot);
    fprintf(fid,'\n');
    fprintf(fid,'\n');
  end
  fclose(fid);
else
  fprintf('\n');
  fprintf('%s',' ',distfile,'   ',pltyp,'   ',dname,'  Scal power = ');
  fprintf('%i',isc);
  fprintf('\n');
  fprintf('%s%8g%s%i%s%i%s',' Max: ',maxd,' at (',comax(1),',',comax(2),')');
  fprintf('%s%8g%s%i%s%i%s%g%s%i','   Min: ',mind,' at (',comin(1),',',comin(2),')  Mean: ',avd,'  Number of bundles: ',ntot);
  fprintf('\n');
  fprintf('\n');
  if lr==2, 
    if CROD==1,
      cr2scr(dis2d,mminj);
    else
      hcor2scr(dis2d,mminj,lr);
    end
    fprintf('\n');
  end
  if CROD==1,
    cr2scr(dis2d,mminj)
  else
    hcor2scr(dis2d,mminj)
  end
  if lr==2,
    fprintf('\n');
    fprintf('%s',' ',distfile,'   ',pltyp,'   ',dname,'  Scal power = ');
    fprintf('%i',isc);
    fprintf('\n');
    fprintf('%s%8g%s%i%s%i%s',' Max: ',maxd,' at (',comax(1),',',comax(2),')');
    fprintf('%s%8g%s%i%s%i%s%g%s%i','   Min: ',mind,' at (',comin(1),',',comin(2),')  Mean: ',avd,'  Number of bundles: ',ntot);
    fprintf('\n');
    fprintf('\n');
  end
end
