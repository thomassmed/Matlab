%function [d1,d2,sigr,siga1,siga2,usig1,usig2,ny,d1d,d2d,sigrd,siga1d,siga2d,...
%usig1d,usig2d,nyd,sigrt,siga1t,siga2t,usig2t]=...
%xsec2mstab(disfil,f_master,Pdens,Tfm,knum)

function [d1,d2,sigr,siga1,siga2,usig1,usig2,ny,d1d,d2d,sigrd,siga1d,siga2d,...
usig1d,usig2d,nyd,sigrt,siga1t,siga2t,usig2t]=...
xsec2mstab(disfil,Pdens,Tfm,knum)

global geom msopt

kmax=geom.kmax;
crcovr=geom.crcovr;

if nargin<3, Tfm=0; end

[dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(disfil);

if ~isempty(msopt.MasterFile) & exist(msopt.MasterFile,'file')
	czmesh=mast2mlab7(msopt.MasterFile,163,'F');
else
	height=geom.src_size_height;
	zmesh=geom.src_zmesh_zmesh;
	czmesh(1:zmesh(1))=10E-3*(height(1)/zmesh(1));
	czmesh=czmesh';
end

wcr=get_wcr(konrod,mminj,czmesh,crcovr);

ramcof=readdist7(disfil,'ramcof');
nramon=size(ramcof,1)/kmax;  %No. of RAMONA XS coeff
basr=0:nramon:(kmax*nramon-1);

[ref, D1, D2, s1, s2, n1, n2, sg, nu] = rcof2mcof(nramon);


dens=ramcof(ref(1)+basr,:);
if max(max(Pdens))<2,   
  voidref=ramcof(ref(5)+basr,:);
  raal=739.3094; % Density of water at 70.5 Bar
  raag=36.8209;  % Density of steam at 70.5 Bar
  ddens=(raag-raal)*(Pdens-voidref);
else
  ddens=Pdens-dens;
end
ddens2=ddens.*ddens;
wef=2*wcr./(3-wcr);
pow7=ramcof(basr+ref(4),:);
tfref=ramcof(ref(2)+basr,:);
if length(Tfm)==1, 
  dtf=sqrt(tfref+273.13+Tfm)-sqrt(tfref+273.13);
else
  dtf=sqrt(Tfm+273.13)-sqrt(tfref+273.13);
end

d1=ramcof(D1(1)+basr,:)+ramcof(D1(2)+basr,:).*ddens+ramcof(D1(3)+basr,:).*ddens2+...
   wef.*(ramcof(D1(6)+basr,:)+ramcof(D1(7)+basr,:).*ddens+ramcof(D1(8)+basr,:).*ddens2);
d1d=ramcof(D1(2)+basr,:)+2*ramcof(D1(3)+basr,:).*ddens+...
    wef.*(ramcof(D1(7)+basr,:)+2*ramcof(D1(8)+basr,:).*ddens);
d1dd=2*ramcof(D1(3)+basr,:)+2*wef.*ramcof(D1(8)+basr,:);

d2=ramcof(D2(1)+basr,:)+ramcof(D2(2)+basr,:).*ddens+ramcof(D2(3)+basr,:).*ddens2+...
   wef.*(ramcof(D2(6)+basr,:)+ramcof(D2(7)+basr,:).*ddens+ramcof(D2(8)+basr,:).*ddens2);
d2d=ramcof(D2(2)+basr,:)+2*ramcof(D2(3)+basr,:).*ddens+...
    wef.*(ramcof(D2(7)+basr,:)+2*ramcof(D2(8)+basr,:).*ddens);
d2dd=2*ramcof(D2(3)+basr,:)+2*wef.*ramcof(D2(8)+basr,:);

siga1=ramcof(s1(1)+basr,:)+ramcof(s1(2)+basr,:).*ddens+ramcof(s1(3)+basr,:).*ddens2+...  
wef.*(ramcof(s1(6)+basr,:)+ramcof(s1(7)+basr,:).*ddens+ramcof(s1(8)+basr,:).*ddens2)+...
dtf.*(ramcof(s1(11)+basr,:)+ddens.*ramcof(s1(12)+basr,:)+ddens2.*ramcof(basr+s1(13),:)+...
wef.*ramcof(basr+s1(16),:));

siga1d=ramcof(s1(2)+basr,:)+2*ramcof(s1(3)+basr,:).*ddens+...
    wef.*(ramcof(s1(7)+basr,:)+2*ramcof(s1(8)+basr,:).*ddens)+...
    dtf.*(ramcof(s1(12)+basr,:)+2*ddens.*ramcof(s1(13)+basr,:));
siga1dd=2*ramcof(s1(3)+basr,:)+2*wef.*ramcof(s1(8)+basr,:)+2*dtf.*ramcof(s1(13)+basr,:);
siga1dt=ramcof(s1(12)+basr,:)+2*ddens.*ramcof(s1(13)+basr,:);

siga1t=ramcof(s1(11)+basr,:)+ddens.*ramcof(s1(12)+basr,:)+ddens2.*ramcof(basr+s1(13),:)+wef.*ramcof(basr+s1(16),:);

siga2=ramcof(s2(1)+basr,:)+ramcof(s2(2)+basr,:).*ddens+ramcof(s2(3)+basr,:).*ddens2+...
wef.*(ramcof(s2(6)+basr,:)+ramcof(s2(7)+basr,:).*ddens+ramcof(s2(8)+basr,:).*ddens2)+...
dtf.*(ramcof(s2(11)+basr,:)+ddens.*ramcof(s2(12)+basr,:)+ddens2.*ramcof(s2(13)+basr,:));

siga2d=ramcof(s2(2)+basr,:)+2*ramcof(s2(3)+basr,:).*ddens+...
    wef.*(ramcof(s2(7)+basr,:)+2*ramcof(s2(8)+basr,:).*ddens)+...
    dtf.*(ramcof(s2(12)+basr,:)+2*ddens.*ramcof(s2(13)+basr,:));

siga2t=ramcof(s2(11)+basr,:)+ddens.*ramcof(s2(12)+basr,:)+ddens2.*ramcof(s2(13)+basr,:);

usig1=ramcof(n1(1)+basr,:)+ramcof(n1(2)+basr,:).*ddens+ramcof(n1(3)+basr,:).*ddens2+...
   wef.*(ramcof(n1(6)+basr,:)+ramcof(n1(7)+basr,:).*ddens+ramcof(n1(8)+basr,:).*ddens2);
usig1d=ramcof(n1(2)+basr,:)+2*ramcof(n1(3)+basr,:).*ddens+...
    wef.*(ramcof(n1(7)+basr,:)+2*ramcof(n1(8)+basr,:).*ddens);

usig2=ramcof(n2(1)+basr,:)+ramcof(n2(2)+basr,:).*ddens+ramcof(n2(3)+basr,:).*ddens2+...  
wef.*(ramcof(n2(6)+basr,:)+ramcof(n2(7)+basr,:).*ddens+ramcof(n2(8)+basr,:).*ddens2)+...
dtf.*(ramcof(n2(11)+basr,:)+ddens.*ramcof(n2(12)+basr,:)+ddens2.*ramcof(n2(13)+basr,:));

usig2d=ramcof(n2(2)+basr,:)+2*ramcof(n2(3)+basr,:).*ddens+...
    wef.*(ramcof(n2(7)+basr,:)+2*ramcof(n2(8)+basr,:).*ddens)+...
    dtf.*(ramcof(n2(12)+basr,:)+2*ddens.*ramcof(n2(13)+basr,:));

usig2t=ramcof(n2(11)+basr,:)+ddens.*ramcof(n2(12)+basr,:)+ddens2.*ramcof(n2(13)+basr,:);

sigr=ramcof(sg(1)+basr,:)+ramcof(sg(2)+basr,:).*ddens+ramcof(sg(3)+basr,:).*ddens2+...
wef.*(ramcof(sg(6)+basr,:)+ramcof(sg(7)+basr,:).*ddens+ramcof(sg(8)+basr,:).*ddens2)+...
dtf.*(ramcof(sg(11)+basr,:)+ddens.*ramcof(sg(12)+basr,:)+ddens2.*ramcof(sg(13)+basr,:));


sigrd=ramcof(sg(2)+basr,:)+2*ramcof(sg(3)+basr,:).*ddens+...
    wef.*(ramcof(sg(7)+basr,:)+2*ramcof(sg(8)+basr,:).*ddens)+...
    dtf.*(ramcof(sg(12)+basr,:)+2*ddens.*ramcof(sg(13)+basr,:));

sigrt=ramcof(sg(11)+basr,:)+ddens.*ramcof(sg(12)+basr,:)+ddens2.*ramcof(sg(13)+basr,:);

ny=ramcof(nu(1)+basr,:)+ramcof(nu(2)+basr,:).*ddens+ramcof(nu(3)+basr,:).*ddens2+...
   wef.*(ramcof(nu(6)+basr,:)+ramcof(nu(7)+basr,:).*ddens+ramcof(nu(8)+basr,:).*ddens2);

nyd=ramcof(nu(2)+basr,:)+2*ramcof(nu(3)+basr,:).*ddens+...
    wef.*(ramcof(nu(7)+basr,:)+2*ramcof(nu(8)+basr,:).*ddens);


% Take care of dens > dth
dth=ramcof(ref(7)+basr,:);
d1=d1.*(1-(dens>dth));
d1d=d1d.*(1-(dens>dth));
d1=d1+(dens>dth).*(ramcof(D1(4)+basr,:)+ddens.*ramcof(D1(5)+basr,:)+...
                wef.*(ramcof(D1(9)+basr,:)+ddens.*ramcof(D1(10)+basr,:)));
d1d=d1d+(dens>dth).*(ramcof(D1(5)+basr,:)+...
                wef.*ramcof(D1(10)+basr,:));
		
d2=d2.*(1-(dens>dth));
d2d=d2d.*(1-(dens>dth));
d2=d2+(dens>dth).*(ramcof(D2(4)+basr,:)+ddens.*ramcof(D2(5)+basr,:)+...
                wef.*(ramcof(D2(9)+basr,:)+ddens.*ramcof(D2(10)+basr,:)));
d2d=d2d+(dens>dth).*(ramcof(D2(5)+basr,:)+...
                wef.*ramcof(D2(10)+basr,:));

siga1=siga1.*(1-(dens>dth));
siga1d=siga1d.*(1-(dens>dth));
siga1t=siga1t.*(1-(dens>dth));

siga1=siga1+(dens>dth).*(ramcof(s1(4)+basr,:)+ddens.*ramcof(s1(5)+basr,:)+...
                wef.*(ramcof(s1(9)+basr,:)+ddens.*ramcof(s1(10)+basr,:))+...
dtf.*(ramcof(basr+s1(14),:)+ramcof(basr+s1(15),:).*ddens+wef.*ramcof(basr+s1(16),:)));

siga1d=siga1d+(dens>dth).*(ramcof(s1(5)+basr,:)+...
                wef.*ramcof(s1(10)+basr,:)+dtf.*ramcof(basr+s1(15),:));
siga1t=siga1t+(dens>dth).*(ramcof(basr+s1(14),:)+ramcof(basr+s1(15),:).*ddens+wef.*ramcof(basr+s1(16),:));

siga2=siga2.*(1-(dens>dth));
siga2d=siga2d.*(1-(dens>dth));
siga2t=siga2t.*(1-(dens>dth));

siga2=siga2+(dens>dth).*(ramcof(s2(4)+basr,:)+ddens.*ramcof(s2(5)+basr,:)+...
                wef.*(ramcof(s2(9)+basr,:)+ddens.*ramcof(s2(10)+basr,:))+...
		dtf.*(ramcof(s2(14)+basr,:)+ramcof(s2(15)+basr,:).*ddens));
siga2d=siga2d+(dens>dth).*(ramcof(s2(5)+basr,:)+...
                wef.*ramcof(s2(10)+basr,:)+dtf.*ramcof(s2(15)+basr,:));
siga2t=siga2t+(dens>dth).*(ramcof(s2(14)+basr,:)+ramcof(s2(15)+basr,:).*ddens);


usig1=usig1.*(1-(dens>dth));
usig1d=usig1d.*(1-(dens>dth));
usig1=usig1+(dens>dth).*(ramcof(n1(4)+basr,:)+ddens.*ramcof(n1(5)+basr,:)+...
                wef.*(ramcof(n1(9)+basr,:)+ddens.*ramcof(n1(10)+basr,:)));
usig1d=usig1d+(dens>dth).*(ramcof(n1(5)+basr,:)+...
                wef.*ramcof(n1(10)+basr,:));

usig2=usig2.*(1-(dens>dth));
usig2d=usig2d.*(1-(dens>dth));
usig2t=usig2t.*(1-(dens>dth));
usig2=usig2+(dens>dth).*(ramcof(n2(4)+basr,:)+ddens.*ramcof(n2(5)+basr,:)+...
                wef.*(ramcof(n2(9)+basr,:)+ddens.*ramcof(n2(10)+basr,:))+...
		dtf.*(ramcof(n2(14)+basr,:)+ramcof(n2(15)+basr,:).*ddens));
usig2d=usig2d+(dens>dth).*(ramcof(n2(5)+basr,:)+...
                wef.*ramcof(n2(10)+basr,:)+dtf.*ramcof(n2(15)+basr,:));
usig2t=usig2t+(dens>dth).*(ramcof(n2(14)+basr,:)+ramcof(n2(15)+basr,:).*ddens);

sigr=sigr.*(1-(dens>dth));
sigrd=sigrd.*(1-(dens>dth));
sigrt=sigrt.*(1-(dens>dth));
sigr=sigr+(dens>dth).*(ramcof(sg(4)+basr,:)+ddens.*ramcof(sg(5)+basr,:)+...
                wef.*(ramcof(sg(9)+basr,:)+ddens.*ramcof(sg(10)+basr,:))+...
		dtf.*(ramcof(sg(14)+basr,:)+ramcof(sg(15)+basr,:).*ddens));
sigrd=sigrd+(dens>dth).*(ramcof(sg(5)+basr,:)+...
                wef.*ramcof(sg(10)+basr,:))+dtf.*ramcof(sg(15)+basr,:);
sigrt=sigrt+(dens>dth).*(ramcof(sg(14)+basr,:)+ramcof(sg(15)+basr,:).*ddens);

ny=ny.*(1-(dens>dth));
nyd=nyd.*(1-(dens>dth));
ny=ny+(dens>dth).*(ramcof(nu(4)+basr,:)+ddens.*ramcof(nu(5)+basr,:)+...
                wef.*(ramcof(nu(9)+basr,:)+ddens.*ramcof(nu(10)+basr,:)));
nyd=nyd+(dens>dth).*(ramcof(nu(5)+basr,:)+...
                wef.*ramcof(nu(10)+basr,:));

%return

hz=czmesh(1);
handle=0.115;

hsa2=0.00651;
hnsf2=0.00231;
hsigr=-0.00091;

%
% If bottom node and CR inserted: subtract diff. handle built into "base" XS
%
hfrac=handle/hz;
siga2(1,:)=siga2(1,:)-(wcr(1,:)>0.001)*hfrac*hsa2;
usig2(1,:)=usig2(1,:)-(wcr(1,:)>0.001)*hfrac*hnsf2;
sigr(1,:)=sigr(1,:)-(wcr(1,:)>0.001)*hfrac*hsigr;

%
% Partial CR presence plus partial CR handle presence:
%
dhand=min((1-wcr)*hz,handle);
hfrac=dhand/hz;
pcr=(wcr>0.001).*(wcr<0.999).*hfrac;
siga2=siga2+pcr*hsa2;
usig2=usig2+pcr*hnsf2;
sigr=sigr+pcr*hsigr;

d2hand=(wcr(2:kmax,:)==0&wcr(1:kmax-1,:)>0.001).*(handle-dhand(1:kmax-1,:));
hfrac=d2hand/hz;
siga2(2:kmax,:)=siga2(2:kmax,:)+hfrac*hsa2;

% Take care of dt/dsqrt(t):
sigrt=sigrt./sqrt(Tfm+273.13)/2;
siga1t=siga1t./sqrt(Tfm+273.13)/2;
siga2t=siga2t./sqrt(Tfm+273.13)/2;
usig2t=usig2t./sqrt(Tfm+273.13)/2;



%Discontinuity factors
% Epithermal
df1=1+(wcr>0.5)*0.1;
d1=d1./df1;
d1d=d1d./df1;
sigr=sigr./df1;
sigrd=sigrd./df1;
sigrt=sigrt./df1;
siga1=siga1./df1;
siga1d=siga1d./df1;
siga1t=siga1t./df1;
usig1=usig1./df1;
usig1d=usig1d./df1;
% Thermal
df2=1+(wcr>0.5)*0.25;
d2=d2./df2;
d2d=d2d./df2;
siga2=siga2./df2;
siga2d=siga2d./df2;
siga2t=siga2t./df2;
usig2=usig2./df2;
usig2d=usig2d./df2;
usig2t=usig2t./df2;


if nargin>3,
  d1=d1(:,knum(:,1));d1=d1(:);
  d2=d2(:,knum(:,1));d2=d2(:);
  ny=ny(:,knum(:,1));ny=ny(:);
  siga1=siga1(:,knum(:,1));siga1=siga1(:);
  siga2=siga2(:,knum(:,1));siga2=siga2(:);
  usig1=usig1(:,knum(:,1));usig1=usig1(:);
  usig2=usig2(:,knum(:,1));usig2=usig2(:);
  sigr=sigr(:,knum(:,1));sigr=sigr(:);
  d1d=d1d(:,knum(:,1));d1d=d1d(:);
  d2d=d2d(:,knum(:,1));d2d=d2d(:);
  nyd=nyd(:,knum(:,1));nyd=nyd(:);
  siga1d=siga1d(:,knum(:,1));siga1d=siga1d(:);
  siga2d=siga2d(:,knum(:,1));siga2d=siga2d(:);
  usig1d=usig1d(:,knum(:,1));usig1d=usig1d(:);
  usig2d=usig2d(:,knum(:,1));usig2d=usig2d(:);
  sigrd=sigrd(:,knum(:,1));sigrd=sigrd(:);
  siga1t=siga1t(:,knum(:,1));siga1t=siga1t(:);
  siga2t=siga2t(:,knum(:,1));siga2t=siga2t(:);
  usig2t=usig2t(:,knum(:,1));usig2t=usig2t(:);
  sigrt=sigrt(:,knum(:,1));sigrt=sigrt(:);
end

%@(#)   xsec2mstab7.m 1.1   02/06/03     14:57:39
