%@(#)   power_void.m 1.9   03/08/13     13:22:50
function [Ppower,Pvoid,Pfi1,Pfi2,powr,qtherm,qtrissf,qprimw,keff,fa1,fa2,tw,Iboil,alfa,Wl,Wg,tl,...
gammav,mg,romum,S,wl,wg,jm,vhk,Pdens,Tfm]= power_void

global msopt polcadata geom termo neu fuel 

nin=geom.nin;

k = get_corenodes;
[kn,k0]=get_thneig(k);

dispmode=msopt.PowerVoidThDisp;
maxiter=msopt.PowerVoidThMaxiter;

isym=msopt.CoreSym;
distfile=msopt.DistFile;

mminj=polcadata.mminj;
distlist=polcadata.distlist;

ncc=geom.ncc;
kan=geom.kan;
kmax=geom.kmax;
ntot=geom.ntot;
knum=geom.knum;
nfw=geom.nfw;
Dh=geom.Dh;
A=geom.A;
V=geom.V;
Hz=geom.Hz;
hz=geom.hz;
pbm=geom.pbm;
phm=geom.phm;

ihydr=termo.ihydr;
p=termo.p;
P=termo.P;
htc=termo.htc;

twophasekorr=termo.twophasekorr;
vh=termo.vh;
avhspx=termo.avhspx;
arhspx=termo.arhspx;
zsp=termo.zsp;
ispac=termo.ispac;
dc2corr=termo.dc2corr;

delta=neu.delta;
deltam=neu.deltam;
cmpfrc=neu.cmpfrc;
neig=neu.neig;

mmc=fuel.mmc;
rf=fuel.rf;
rca=fuel.rca;
drca=fuel.drca;
nrods=fuel.nrods;


% tolerances and iteration parameters
tol_pv=msopt.PowerVoidTol;
nitr=msopt.PowerVoidMaxiter;
w_powervoid=msopt.PowerVoidW;   %Relaxation by node plane
w_fa=msopt.PowerVoidWFa;        %Relaxation by iteration no

power=readdist(distfile,'power');
Ppower = power;
power=power(:,knum(:,1));power=power(:);
Pvoid = readdist(distfile,'void');

[a11,a21,a22,cp]=read_alb7; 		%POLCA albedos
chflow=readdist7(distfile,'chflow');
flowb=readdist7(distfile,'flwwc');  	% flwwc corresponds approx. to flowb
chflow=chflow+flowb; 			% Use Polca4 definition of chflow


% dist2mstab
Mvoid=Pvoid(:,knum(:,1));Mvoid=Mvoid(:);
alfa=set_ntohvec(Mvoid,ihydr);

chflow=chflow(knum(:,1))';
chflosum=sum(chflow);
flowb=flowb(knum(:,1))';

% Other preparations
Wbyp = termo.Wtot/get_sym - sum(chflow-flowb);
Wfw = termo.Wfw;
Wl=alfa*0+1;
Htc = htc*ones(get_thsize,1);
tlp=termo.tlp;
hx=geom.hx;
qtherm=termo.Qtot/get_sym;
qtrissl = zeros(get_thsize,1);
kc = get_chnodes;kc(1:ncc)=[];
kb = get_bnodes;kb(1)=[];
jn = get_nnodes;
kbo=zeros(ntot,1);kup=zeros(ntot,1);
kbo(1:kmax:ntot)=ones(kan,1);
kup(kmax:kmax:ntot)=ones(kan,1);

romum_lp = eq_romum(0,P(1),tlp,cor_tsat(P(1))); 
Eci = ones(ncc+1,1)*romum_lp;

keff=neu.keffpolca;keffpolca=keff;
dt0=(283.7963-tlp)/4;
tl0 = [tlp,tlp+dt0,tlp+2*dt0,tlp+3*dt0,283.7963,285.2436,285.9591,286.2996,286.4711,286.5717,...
	286.6528,286.7132,286.7572,286.7856,286.8033,286.8145,286.7791,286.7409,286.7171,286.6895,...
	286.6543,286.5985,286.5102,286.3726,286.1417];

tl = tlp*ones(get_thsize,1);
kc =get_chnodes;kc(1:ncc)=[];
tl(kc) = reshape(ones(ncc,1)*tl0,kmax*ncc,1);


[tw,Iboil] =eq_tw0(P,power,qtherm,delta,htc,pbm,phm,hz,tlp);


Tfm=[]; % Tfm is not used for POLCA4 but causes problems if not initiated

densm=void2dens(alfa,P,tl);
densmc=set_th2ne(densm,ihydr);
Pdens(:,knum(:,1)) = reshape(densmc,kmax,kan);
  
[tfm,tcm,tfM,tc0] = eq_tftc(tw,qtherm,power,hz,rf,rca,drca,p,delta,nrods);
  
tfmm=mean(tfm')';
Tfm(:,knum(:,1))=reshape(tfmm,kmax,kan);
for ii=2:get_sym,
  Tfm(:,knum(:,ii))=Tfm(:,knum(:,1));
end
[d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
xsec2mstab7(distfile,Pdens,Tfm,knum);

fa1=8.5e11*power./(usig1./ny+usig2./ny.*sigr./siga2);
fa2=fa1.*sigr./siga2;
[keff,fa1,fa2,pow]=solv_fi(keff,fa1,fa2,qtherm,neig,usig1,usig2,siga1,sigr,...
siga2,ny,ny,d1,d2,hx,hz,a11,a21,a22,cp);
power=pow/mean(pow);
Ppower(:,knum(:,1))=reshape(power,kmax,kan);
for ii=2:get_sym,
  Ppower(:,knum(:,ii))=Ppower(:,knum(:,1));
end

disp('Power-Void Iteration:')
disp('It. nr    Rel. Err. neu    Rel. Err. th   Keff         Abs. Err th')
disp('-------+----------------+---------------+-----------+-------------')

rog = cor_rog(cor_tsat(P));
rof = cor_rof(cor_tsat(P));

res = 1;
maxv = 1;
res_scale = rog(nin(5)).*V(nin(5));

n=0;
if ~strcmp(dispmode,'off')
  disp('T/H Solution:')
  disp('It. nr   Rel. Step length   Max rel. Error')
  disp('-------+------------------+---------------')
end
alfa = alfa.*(alfa>0);
mg = alfa.*cor_rog(cor_tsat(P)).*V;
romum = eq_romum(alfa,P,tl,cor_tsat(P)); 
qprimw = set_ntohvec((1-delta)*power*qtherm/ntot./(hz/100),ihydr);
qtrissf=power*qtherm/ntot/(hx/100)^2/(hz/100);
qtrissl(kc) = (delta-deltam)*qtrissf(jn)*(hx/100)^2./A(kc);
qtrissl(kb) = deltam*sum(reshape(qtrissf,ncc,kmax))'*(hx/100)^2./A(kb);
[alfa,S,Wl,wl,Wg,wg,jm,gammav,tl,phi,romum] = sysalg0(mg,romum,qprimw,tw,chflow,flowb,Wbyp,Wfw,nfw,P,A,V,Hz,1);
vhk = set_pkoeff(vh,avhspx,arhspx,zsp,ispac,Wl,Wg,Dh,P,A,Hz);

x = [mg(k0);romum(k0)];
x0 = x;
sx = length(x);
k1 = sx/2;
jv = 1:k1;	%Void vector
je = (k1+1):sx;	%Energy vector
Jscale =1e10;

w_powervoid=spdiags(w_powervoid,0,kmax,kmax)*ones(size(Ppower)); %Node plane wise relaxation parameter
errth=1;
j1_old=0;j1=[1 2];
for n=1:nitr,
  pow_old=power;
  fa1_old=fa1;
  fa2_old=fa2;
  Wl_old=Wl;
  tw_old=tw;

  alfa = alfa.*(alfa>0);
  mg = alfa.*cor_rog(cor_tsat(P)).*V;
  romum = eq_romum(alfa,P,tl,cor_tsat(P)); 
  qprimw = set_ntohvec((1-delta)*power*qtherm/ntot./(hz/100),ihydr);
  qtrissf=power*qtherm/ntot/(hx/100)^2/(hz/100);
  qtrissl(kc) = (delta-deltam)*qtrissf(jn)*(hx/100)^2./A(kc);
  qtrissl(kb) = deltam*sum(reshape(qtrissf,ncc,kmax))'*(hx/100)^2./A(kb);
  xOld=x;
  x = [mg(k0);romum(k0)];

  if n==1, nimax=1; else nimax=3; end
  %Three steps in the T/H
  for ni=1:nimax,
    xold=x;
    if abs(errth)>msopt.ThJacUpdateLimit|(n==1&ni==1),
     [y,J]=sysf(x,qprimw,tw,P,chflow,flowb,Eci,Wbyp,Wfw,nfw,Dh,A,V,Hz,pbm,Htc,qtrissl,Jscale);
      j1_old=j1;
      j1=find(y);
      [l,u]=lu(J(j1,j1));
      dx = u\(l\y(j1));
    else
      y=sysf(x,qprimw,tw,P,chflow,flowb,Eci,Wbyp,Wfw,nfw,Dh,A,V,Hz,pbm,Htc,qtrissl);
      j1test=find(y);
      if length(j1test)~=length(j1),
        Jacwarning=1;
      elseif max(abs(j1test-j1))>0,
        Jacwarning=1;
      else
        Jacwarning=0;
      end
      if Jacwarning==1,
         warning(['Jacobian needs to be updated!' 10 'Recommendation: set msopt.ThJacUpdateLimit to a smaller number']);
      end
      dx = u\(l\y(j1));
    end
    maxv = max(abs(y(jv)).*(x(jv)>0))/res_scale;
    res = max(abs(xold(jv)-x(jv)))/res_scale;
    DX=0*x;
    DX(j1)=dx;
    DX(je)=DX(je)*Jscale;
    if ni==1&n==1, DX=DX/3; end
    x = x - DX;
    j11 = find(x(jv)<0);
    x(jv(j11)) = zeros(length(j11),1);
    [mg,romum] = getstate(x,Eci);
 
    [alfa,S,Wl,wl,Wg,wg,jm,gammav,tl]=sysalg0(mg,romum,qprimw,tw,chflow,flowb,Wbyp,Wfw,nfw,P,A,V,Hz,1);
    vhk = set_pkoeff(vh,avhspx,arhspx,zsp,ispac,Wl,Wg,Dh,P,A,Hz);
    if ni==1&(n-1)/2==round((n-1)/2),
      [yi,Ji] = sysf_I(Wl,Wg,wg,P,alfa,tl,mg,romum,qprimw,tw,chflow,flowb,Eci,Wbyp,Wfw,nfw,vhk,Dh,A,V,Hz,dc2corr,twophasekorr);
    else
      yi= sysf_I(Wl,Wg,wg,P,alfa,tl,mg,romum,qprimw,tw,chflow,flowb,Eci,Wbyp,Wfw,nfw,vhk,Dh,A,V,Hz,dc2corr,twophasekorr);
    end
    dc=-yi./Ji;
    dc=min(dc,1);
    dc=max(dc,-1);
    chflow=chflow+dc;
    chflow=chflow*chflosum/sum(chflow);

    if ~strcmp(dispmode,'off')
      disp(sprintf('%4.0f %14.3f %16.3f',n,res,maxv))
    end
  end
  
  
  [tw,Iboil] =eq_tw0(P,power,qtherm,delta,htc,pbm,phm,hz,tlp,tl,Wl,Wg,Dh,A);
  

  if n>1,
    Pdens_old=Pdens;
  end
  densm=void2dens(alfa,P,tl);
  densmc=set_th2ne(densm,ihydr);

  void_old=Pvoid;
  Tsat0 = cor_tsat(P);
  hl=cor_hl(mg,romum,tl,P,Tsat0,V);
  hfg=cor_hfg(P(1));
  xe=0.724*hl/hfg;                           % Polca eq 192:3:97
  %Find the corenodes
  j2 = get_chnodes;
  ixe=find(alfa(j2)<=0);
  % alfaD and Pvoid is used for the XS calc in Polca4 and can be <0, 
  % alfa is used for TH calc and should never be <0
  alfaD=alfa;
  alfaD(j2(ixe))=xe(j2(ixe));
  Mvoid=set_th2ne(alfaD,ihydr);
  Pvoid(:,knum(:,1)) = reshape(Mvoid,kmax,kan);
  Pdens(:,knum(:,1)) = reshape(densmc,kmax,kan);
  for ii=2:get_sym,
    Pdens(:,knum(:,ii))=Pdens(:,knum(:,1));
    Pvoid(:,knum(:,2))=Pvoid(:,knum(:,1));
  end
  if n>1,
    Pdens=w_powervoid.*Pdens+(1-w_powervoid).*Pdens_old; 
  end
  Pvoid=w_powervoid.*Pvoid+(1-w_powervoid).*void_old; 

  [tfm,tcm,tfM,tc0] = eq_tftc(tw,qtherm,power,hz,rf,rca,drca,p,delta,nrods);

  tfmm=mean(tfm')';
  Tfm(:,knum(:,1))=reshape(tfmm,kmax,kan);
  for ii=2:get_sym,
    Tfm(:,knum(:,ii))=Tfm(:,knum(:,1));
  end
  [d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
  xsec2mstab7(distfile,Pdens,Tfm,knum);


  [keff,fa1,fa2,pow]=solv_fi(keff,fa1,fa2,qtherm,neig,usig1,usig2,siga1,sigr,...
  siga2,ny,ny,d1,d2,hx,hz,a11,a21,a22,cp);
  fa1=(1-w_fa(n))*fa1_old+w_fa(n)*fa1;
  fa2=(1-w_fa(n))*fa2_old+w_fa(n)*fa2;
  power=pow/mean(pow);
  Ppow_old=Ppower;
  Ppower(:,knum(:,1))=reshape(power,kmax,kan);
  for ii=2:get_sym,
    Ppower(:,knum(:,ii))=Ppower(:,knum(:,1));
  end
  Ppower=w_powervoid.*Ppower+(1-w_powervoid).*Ppow_old;
  power=Ppower(:,knum(:,1));power=power(:);
  [errne,pone]=max(abs(pow_old-power));
   not0=find(Wl~=0);
  [errth,poth]=max(abs(Wl_old(not0)-Wl(not0))./Wl(not0));
  err=max([errne errth]);
  sx=length(y);
  ls=norm(y(1:sx/2))/norm(x(1:sx/2))+norm(y(sx/2+1:sx))/norm(x(sx/2+1:sx));
  disp(sprintf('%4i %15.5f %15.5f %12.5f %15.6f',n,power(pone)-pow_old(pone),(Wl_old(not0(poth))-Wl(not0(poth)))./Wl(not0(poth)),keff,ls))
  if err<tol_pv
     break
  end
  if n==maxiter,error('No convergence!'),end
end

%------------------------------------------------------------------------------------------------------------
% Problem uppstår i nedanstående test om de voidfria noderna föregås av flera void-noder,
% Då plockas enbart den nod vilken direkt följs av en voidfri nod bort...
% Har ändrat så att samtliga void-noder i en kanal, vilka följs av voidfria noder, plockas bort
%	Emma Lundgren, eml, 051222
%------------------------------------------------------------------------------------------------------------ 
%eliminate void in nodes followed by void free nodes
%	k=get_ch(1:ncc);
%	alfacore=reshape(alfa(k),kmax+1,ncc);
%	ialfa=find([zeros(1,ncc);diff(alfacore~=0)<0]);
%	alfacore(ialfa-1)=0; % set void to zero in these nodes
% 	alfa(k)=alfacore(:);

k = get_ch(1:ncc);
alfacore = reshape(alfa(k),kmax+1,ncc);
ialfa=find([zeros(1,ncc);diff(alfacore~=0)<0]);

antal_nollade_noder = 0;
for ii = 1:size(ialfa,1)
  kolumn = floor((ialfa(ii)-1)/(kmax+1)) +1;
  rad_2  = ialfa(ii) - (kolumn-1)*(kmax+1) -1;
  
  % kolumn och rad pekar på den voidnod som följs av en voidfri nod
  % vill plocka bort den och samtliga voidnoder innan den.
  
  alfa_kolumn = alfacore(1:rad_2,kolumn);
  rad_1 = find(alfa_kolumn==0,1,'last')+1;
  if size(rad_1,1) == 0
    rad_1 = 1;
  end
  
  % noder i alfacore på plats (rad_1:rad_2,kolumn) ska nollas!!!
  
  antal_nollade_noder = antal_nollade_noder + rad_2-rad_1 + 1;
  alfacore(rad_1:rad_2,kolumn) = 0;
end 
alfa(k) = alfacore(:);
%------------------------------------------------------------------------------------------------------------

mg = alfa.*cor_rog(cor_tsat(P)).*V;

[alfa,S,Wl,wl,Wg,wg,jm,gammav,tl]=sysalg0(mg,romum,qprimw,tw,chflow,flowb,Wbyp,Wfw,nfw,P,A,V,Hz,1);

powr=pow/mean(pow);
Ppower(:,knum(:,1))=reshape(powr,kmax,kan);
Pfi1=0*Ppower;Pfi2=Pfi1;
Pfi1(:,knum(:,1))=reshape(fa1,kmax,kan);
Pfi2(:,knum(:,1))=reshape(fa2,kmax,kan);
for ii=2:get_sym,
  Ppower(:,knum(:,ii)) =   Ppower(:,knum(:,1));
  Pfi1(:,knum(:,ii))   =   Pfi1(:,knum(:,1));
  Pfi2(:,knum(:,ii))   =   Pfi2(:,knum(:,1));
end
fprintf(1,'          keff      PLOWP      PUTLOWP    PUTCOR     PUPPLE       dPcore     dPin       Bypass\n');
fprintf(1,'POLCA:   %7.5f',keffpolca);
%	hy=polcadata.hy;			% Eliminerar samtliga läsningar direkt ur "polca-vektorer"
						% hy(2)		finns redan ! som parameter termo.Wtot
						% hy(61)(56)	läses in i get_polcadata som parameter termo.dpcore
						% hy(62)(57)	läses in i get_polcadata som parameter termo.plowp
						% hy(63)(58)	läses in i get_polcadata som parameter termo.putcor
						% hy(64)(59)	läses in i get_polcadata som parameter termo.putlowp
						% hy(67)(62)	läses in i get_polcadata som parameter termo.pupple
						% hy(73)(68)	läses in i get_polcadata som parameter termo.dpavin
						% hy(121)(151) 	läses in i get_polcadata som parameter termo.spltot
						% Emma Lundgren, 05-12-09
						
%	fprintf(1,' %10i',round([hy([62 64 63 67 61 73]);hy(2)*hy(121)]));

fprintf(1,' %10i',round([termo.plowp; termo.putlowp; termo.putcor; termo.pupple; ...
				termo.dpcore; termo.dpavin; termo.Wtot*termo.spltot]));
fprintf(1,'\n');

ploss = eq_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,dc2corr,twophasekorr);
[P,dpcore,dpin,dput]=get_P(ploss,P(1));
lp1=get_lp1nodes;
lp2=get_lp2nodes;
risnod=get_risernodes;
PUTLOWP=P(lp2(length(lp2)));
PLOWP=P(lp1(1));
PUTCOR=P(risnod(1));
PUPPLE=P(risnod(length(risnod)));
dPsepa=ploss(risnod(length(risnod)));


dPcore=PUTLOWP-PUTCOR;matprin=[PLOWP PUTLOWP PUTCOR PUPPLE  -mean(dpcore) -mean(dpin)  Wbyp*get_sym];
fprintf(1,'MATSTAB: %7.5f',keff);
fprintf(1,' %10i',round(matprin));
fprintf(1,'\n');

% Gör utskrift av antal nollade noder om några noder nollats
if antal_nollade_noder>0
  fprintf(1,'Warning, void in %i nodes have been eliminated, since they were followed by void free nodes.\n',...
  		antal_nollade_noder);
end		




