function [e_lp,E_lp,lpeig,nlp,lpnr,axpos,kpunkt,cfft]=mvm(matfil,harmonics,alldet);
% [e_lp,E_lp,lpeig,nlp,lpnr,axpos,kpunkt,cfft]=mstab_vs_meas(matfil,harmonics,alldet);
%

if nargin<3,alldet=0;end
if nargin<2,harmonics=0;end
if length(matfil)>0,
  load(matfil,'msopt')
  disfil=msopt.DistFile;
else
  disfil=setprop(5);
  mstab=0;
end

[tmp,MATLAB_HOME]=unix('echo $MATLAB_HOME');
MATLAB_HOME(length(MATLAB_HOME))=[];
[dum,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist(disfil);
T=0.1;
casename=strip(disfil);
if findstr(casename,'c7');
  load('bc7',casename(1:12),'nlp','lpnr','axpos','apnr')
  eval(['c=' casename(1:12) ';']);
else
  load bc10
  eval(['c=' casename(1:11) ';']);
end
lpnr_meas=lpnr;
if alldet,
  lpnr=1:length(detpos);
  axpos=4*ones(1,length(detpos));
end

%MEASUREMENT

lpeig=tt2ev(c(:,apnr(1)),c(:,nlp),T);
lpeig=lpeig.';

%MATSTAB

[efi1,evoid,efi2,vfi1,vfi2]=f_matstab2dist(matfil,harmonics);
e_lp=e_mstab(efi2,disfil,lpnr,axpos);

%SCALING

ilm=1;
sca=2;

if alldet
   E_lp=e_lp/e_lp(lpnr_meas(ilm))*sca;
else
   E_lp=e_lp/e_lp(ilm)*sca;
end
lpeig=lpeig/lpeig(ilm)*sca;

%DISPLAY

distplot(disfil,'abs(efi2)','upleft',-abs(efi2).*sign(angle(efi2)));

ij=knum2cpos(detpos(lpnr),mminj);
x=ij(:,2)'+1;
y=ij(:,1)'+1;
x=[x;x+real(E_lp)];y=[y;y-imag(E_lp)];
h=line(x,y);
set(h,'color','bla','LineWidth',2.0);
text(x(1,:)-.2,y(1,:),'X');

ij=knum2cpos(detpos(lpnr_meas),mminj);
x=ij(:,2)'+1;
y=ij(:,1)'+1;
x=[x;x+real(lpeig)];y=[y;y-imag(lpeig)];
h=line(x,y);
set(h,'color','w','LineWidth',2.0);

