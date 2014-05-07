function [An,Ant,Anf,Aqn,Aqt,Aqf]=A_neu(fue_new,Xsec,matr,lam,regio)

%[iA,jA,xA]=A_neu(lam,regio);
%
% Generates A-matrices corresponding to the neutronics:
%
% Eq. A34   fa2 = A2nm * fa1
% Eq. A36:  fa1 = A1nm * fa1 
% Eq. A39:    q = Aq   * fa1   = k1h0/keff * (sig1 + sig2 * A2nm) * fa1 
%
% Eq. A37: dfa1 = An * dfa1 + Anv * dalfa
% Eq. A40:   dq = Aq  * dfa1 + Aqv * dalfa
%
% Equation numbers taken from Dissertation Ph. Haenggi

% 
%%
if nargin<4,
    lam=-0.2+3j;
end
if nargin<5,
  regio=0;
end
%%
global msopt geom termo neu steady

distfile=msopt.DistFile;
mastfile=msopt.MasterFile;
neumodel=neu.NeuModel;

rol = cor_rol(termo.P,steady.tl);rol=rol(:);
rog = cor_rog(cor_tsat(termo.P));rog=rog(:);

hz=geom.hz;
hx=geom.hx;
kan=geom.kan;
kmax=geom.kmax;
ntot=geom.ntot;

fi_sc=matr.fi_sc;
q3_sc=matr.q3_sc;
nf=matr.nf;
ibas_f=1:nf:nf*ntot;
nt=matr.nt;
ibas_t=1:nt:kmax*ntot;

k1h0=neu.k1h0*q3_sc;

al=neu.al;
b=neu.b;
neig=neu.neig;
knum=geom.knum;
keff=steady.keff;
Ppower=steady.Ppower;
Pvoid=steady.Pvoid;
Pdens=steady.Pdens;
Tfm=steady.Tfm;
fa1=steady.fa1;
fa2=steady.fa2;


p=termo.p;


%-------------------------------------------------------
%% Preparing the distinction of spatial neighbours

[black,white]=chess(Ppower,geom.mminj);

bb=0*Ppower;
bw=0*Ppower;
iblack=find(black);
iwhite=find(white);
bl1=ones(size(iblack))';
wh1=ones(size(iwhite))';
for i=1:2:kmax,
  bb(i,iblack)=bl1;
  bw(i,iwhite)=wh1;
end
for i=2:2:kmax,
  bb(i,iwhite)=wh1;
  bw(i,iblack)=bl1;
end    
blvec=bb(:,knum(:,1));blvec=blvec(:);  
whvec=bw(:,knum(:,1));whvec=whvec(:);  

%% X-sec
%-------------------------------------------------------
% Calculating equations A18-A21 


switch upper(neumodel)
    case 'POLCA7'
        rol = matstab2polca(rol);
        rog = matstab2polca(rog);
        [d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
            xsec2mstab7(distfile,mastfile,Pdens,Tfm,knum);
        [a11,a21,a22,cp]=read_alb7;
    case 'POLCA4'
        [d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
        xsec2mstab(distfile,Ppower,Pvoid,mastfile,knum);
        [a11,a21,a22,cp]=read_alb;
    case 'SIM3'
        ny=Xsec.ny;
        d1=Xsec.d1;
        d2=Xsec.d2;
        sigr=Xsec.sigr;
        siga1=Xsec.siga1;
        siga2=Xsec.siga2;
        usig1=Xsec.usig1;
        usig2=Xsec.usig2;
        [a11,a21,a22,cp]=read_alb7(fue_new);
end

[X1nm0,Y1nm0,X2nm0,Y2nm0]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigr,siga2,a11,a21,a22,fa1,fa2,cp);

%-------------------------------------------------------
% Calculate dqdfa1

%-------------------------------------------------------
%% Aqn

% Equation A39
A2nm0=A_f12(X2nm0,Y2nm0,neig,siga2,sigr,regio);  
Aqn=spdiags(usig2./ny,0,ntot,ntot)*A2nm0;
Aqn=Aqn+spdiags(usig1./ny,0,ntot,ntot);
Aqn=Aqn*k1h0/keff;
Aqn=Aqn*fi_sc/q3_sc;
%-------------------------------------------------------
%% An

% Calulate fa2c in fa2c = A2nm * fa1 (eq. 34) (fa2c is now complex, fa2 is real)
[X1nm,Y1nm,X2nm,Y2nm]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigr,siga2,a11,a21,a22,fa1,fa2,cp,al,b,lam);
A2nm=A_f12(X2nm,Y2nm,neig,siga2,sigr,regio);  
fa2c=A2nm*fa1;

% Calculate X1nm,X2nm,Y1nm,Y2nm with fa2c rather than fa2
[X1nm,Y1nm,X2nm,Y2nm]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigr,siga2,a11,a21,a22,fa1,fa2c,cp,al,b,lam);

% Equation 36
An=eq_A1nm(neig,X1nm,Y1nm,X2nm,Y2nm,usig2,usig1,siga1,sigr,siga2,...
keff,al,b,lam,regio);

%-------------------------------------------------------
%% Prepare for Aqt and Ant

dqdv0=k1h0*(usig1./ny.*fa1+usig2./ny.*(A2nm0*fa1))/keff;

%% Disturbe the void, black nodes
delta=0.0001;
switch upper(neumodel)
    case 'POLCA7'
        Pdens_bl=Pdens+delta*bb.*(rog-rol);
        [d1,d2,sigrbl,siga1,siga2bl,usig1,usig2,ny]=...
            xsec2mstab7(distfile,mastfile,Pdens_bl,Tfm,knum);
     case 'POLCA4'
        alfa_bl=Pvoid+delta*bb;
        [d1,d2,sigrbl,siga1,siga2bl,usig1,usig2,ny]=...
            xsec2mstab(distfile,Ppower,alfa_bl,mastfile,knum);
    case 'SIM3'
        d1=Xsec.d1+delta*blvec.*Xsec.d1d;
        d2=Xsec.d2+delta*blvec.*Xsec.d2d;
        sigrbl=Xsec.sigr+delta*blvec.*Xsec.sigrd;
        siga1=Xsec.siga1+delta*blvec.*Xsec.siga1d;
        siga2bl=Xsec.siga2+delta*blvec.*Xsec.siga2d;
        usig1=Xsec.usig1+delta*blvec.*Xsec.usig1d;
        usig2=Xsec.usig2+delta*blvec.*Xsec.usig2d;
end
% First, the complex X1,Y1,X2,Y2 for use in the fa1-equation
[X1bl,Y1bl,X2bl,Y2bl]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrbl,siga2bl,a11,a21,a22,fa1,fa2c,cp,al,b,lam);
% Then, the real X1,Y1,X2,Y2 for use in the other equations
[X1bl0,Y1bl0,X2bl0,Y2bl0]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrbl,siga2bl,a11,a21,a22,fa1,fa2,cp);

blA1nm=eq_A1nm(neig,X1bl,Y1bl,X2bl,Y2bl,usig2,usig1,siga1,sigrbl,siga2bl,...
keff,al,b,lam,regio);


dqdvbl=k1h0*(usig1./ny.*fa1+usig2./ny.*(A2nm0*fa1))/keff;

%% Disturbe the void, white nodes
switch upper(neumodel)
    case 'POLCA7'
        Pdens_wh=Pdens+delta*bw.*(rog-rol);
        [d1,d2,sigrwh,siga1,siga2wh,usig1,usig2,ny]=...
            xsec2mstab7(distfile,mastfile,Pdens_wh,Tfm,knum);
    case 'POLCA4'
        alfa_wh=Pvoid+delta*bw;
        [d1,d2,sigrwh,siga1,siga2wh,usig1,usig2,ny]=...
        xsec2mstab(distfile,Ppower,alfa_wh,mastfile,knum);
    case 'SIM3'
        d1=Xsec.d1+delta*whvec.*Xsec.d1d;
        d2=Xsec.d2+delta*whvec.*Xsec.d2d;
        sigrwh=Xsec.sigr+delta*whvec.*Xsec.sigrd;
        siga1=Xsec.siga1+delta*whvec.*Xsec.siga1d;
        siga2wh=Xsec.siga2+delta*whvec.*Xsec.siga2d;
        usig1=Xsec.usig1+delta*whvec.*Xsec.usig1d;
        usig2=Xsec.usig2+delta*whvec.*Xsec.usig2d;
end
% First, the complex X1,Y1,X2,Y2 for use in the fa1-equation
[X1wh,Y1wh,X2wh,Y2wh]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrwh,siga2wh,a11,a21,a22,fa1,fa2c,cp,al,b,lam);
% Then, the real X1,Y1,X2,Y2 for use in the other equations
[X1wh0,Y1wh0,X2wh0,Y2wh0]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrwh,siga2wh,a11,a21,a22,fa1,fa2,cp);

whA1nm=eq_A1nm(neig,X1wh,Y1wh,X2wh,Y2wh,usig2,usig1,siga1,sigrwh,siga2wh,...
keff,al,b,lam,regio);

dqdvwh=k1h0*(usig1./ny.*fa1+usig2./ny.*(A2nm0*fa1))/keff;

void=(Pvoid>0); 
void=void(:,knum(:,1));void=void(:);


%% Anv
diablAnv_neig=((blA1nm-An)*(fa1.*whvec)).*blvec/delta; % dfi1m/dvn in eq. fin
diawhAnv_neig=((whA1nm-An)*(fa1.*blvec)).*whvec/delta;

nodiablAnvm=spdiags(blvec,0,ntot,ntot)*(whA1nm-An)*spdiags(fa1.*whvec,0,ntot,ntot)/delta;
nodiawhAnvm=spdiags(whvec,0,ntot,ntot)*(blA1nm-An)*spdiags(fa1.*blvec,0,ntot,ntot)/delta;

Anv=nodiablAnvm+nodiawhAnvm+spdiags(diablAnv_neig+diawhAnv_neig,0,ntot,ntot);
Anv=Anv*spdiags(void,0,ntot,ntot);

[iAnt,jAnt,xAnt]=find(Anv);
jAnt=ibas_t(jAnt);
Ant=sparse(iAnt,jAnt,xAnt/fi_sc,ntot,ntot*nt+2*kan);


%% Aqt
dA2dv=eq_dA2dv(neig,fa1,delta,X2nm0,Y2nm0,sigr,siga2,...
      X2bl0,Y2bl0,sigrbl,siga2bl,blvec,X2wh0,Y2wh0,sigrwh,siga2wh,whvec);

Aqv=spdiags(void.*(dqdvbl+dqdvwh-dqdv0-dqdv0)/delta,0,ntot,ntot);
Aqv=Aqv+k1h0*spdiags(usig2./ny,0,ntot,ntot)*dA2dv;

[iAqt,jAqt,xAqt]=find(Aqv);
jAqt=ibas_t(jAqt);
Aqt=sparse(iAqt,jAqt,xAqt/q3_sc,ntot,ntot*nt+2*kan);

%% Disturbe the temperature, black nodes
Dt=5;
DPdt=0.007;
switch upper(neumodel)
    case 'POLCA7'
        Tfmbl=Tfm+Dt*bb;
        [d1,d2,sigrbl,siga1,siga2bl,usig1,usig2,ny]=...
        xsec2mstab7(distfile,mastfile,Pdens,Tfmbl,knum);
    case 'POLCA4'
        Ppowerbl=DPdt*Dt*bb+Ppower;
        [d1,d2,sigrbl,siga1,siga2bl,usig1,usig2,ny]=...
            xsec2mstab(distfile,Ppowerbl,Pvoid,mastfile,knum);
    case 'SIM3'
        d1=Xsec.d1+Dt*blvec.*Xsec.d1t;
        d2=Xsec.d2+Dt*blvec.*Xsec.d2t;
        sigrbl=Xsec.sigr+Dt*blvec.*Xsec.sigrt;
        siga1=Xsec.siga1+Dt*blvec.*Xsec.siga1t;
        siga2bl=Xsec.siga2+Dt*blvec.*Xsec.siga2t;
        usig1=Xsec.usig1+Dt*blvec.*Xsec.usig1t;
        usig2=Xsec.usig2+Dt*blvec.*Xsec.usig2t;
end
% First, the complex X1,Y1,X2,Y2 for use in the fa1-equation
[X1nmtb,Y1nmtb,X2nmtb,Y2nmtb]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrbl,siga2bl,a11,a21,a22,fa1,fa2c,cp,al,b,lam);
% Then, the real X1,Y1,X2,Y2 for use in the other equations
[X1nmtb0,Y1nmtb0,X2nmtb0,Y2nmtb0]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrbl,siga2bl,a11,a21,a22,fa1,fa2,cp);

A1nmtb=eq_A1nm(neig,X1nmtb,Y1nmtb,X2nmtb,Y2nmtb,usig2,usig1,siga1,sigrbl,siga2bl,...
keff,al,b,lam,regio);
dqdtb=k1h0*(usig1./ny.*fa1+usig2./ny.*(A2nm0*fa1))/keff;

%% Disturbe the temperature, white nodes

switch upper(neumodel)
    case 'POLCA7'
        Tfmwh=Tfm+Dt*bw;
        [d1,d2,sigrwh,siga1,siga2wh,usig1,usig2,ny]=...
            xsec2mstab7(distfile,mastfile,Pdens,Tfmwh,knum);
    case 'POLCA4'
        Ppowerwh=DPdt*Dt*bw+Ppower;
        [d1,d2,sigrwh,siga1,siga2wh,usig1,usig2,ny]=...
            xsec2mstab(distfile,Ppowerwh,Pvoid,mastfile,knum);
    case 'SIM3'
        d1=Xsec.d1+Dt*whvec.*Xsec.d1t;
        d2=Xsec.d2+Dt*whvec.*Xsec.d2t;
        sigrwh=Xsec.sigr+Dt*whvec.*Xsec.sigrt;
        siga1=Xsec.siga1+Dt*whvec.*Xsec.siga1t;
        siga2wh=Xsec.siga2+Dt*whvec.*Xsec.siga2t;
        usig1=Xsec.usig1+Dt*whvec.*Xsec.usig1t;
        usig2=Xsec.usig2+Dt*whvec.*Xsec.usig2t;
end
% First, the complex X1,Y1,X2,Y2 for use in the fa1-equation
[X1nmtw,Y1nmtw,X2nmtw,Y2nmtw]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrwh,siga2wh,a11,a21,a22,fa1,fa2c,cp,al,b,lam);
% Then, the real X1,Y1,X2,Y2 for use in the other equations
[X1nmtw0,Y1nmtw0,X2nmtw0,Y2nmtw0]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrwh,siga2wh,a11,a21,a22,fa1,fa2,cp);

A1nmtw=eq_A1nm(neig,X1nmtw,Y1nmtw,X2nmtw,Y2nmtw,usig2,usig1,siga1,sigrwh,siga2wh,...
keff,al,b,lam,regio);
dqdtw=k1h0*(usig1./ny.*fa1+usig2./ny.*(A2nm0*fa1))/keff;

%% Aqf
dA2dt=eq_dA2dv(neig,fa1,1,X2nm0,Y2nm0,sigr,siga2,...
      X2nmtb0,Y2nmtb0,sigrbl,siga2bl,blvec,X2nmtw0,Y2nmtw0,sigrwh,siga2wh,whvec);

Aqf=spdiags(dqdtw+dqdtb-dqdv0-dqdv0,0,ntot,ntot)+k1h0*spdiags(usig2./ny,0,ntot,ntot)*dA2dt;
Aqf=Aqf/Dt/4;

[iAqf,jAqf,xAqf]=find(real(Aqf));
xAqf=xAqf/4;
iAqf=[iAqf;iAqf;iAqf;iAqf];
jAqf=ibas_f(jAqf)';
jAqf=[jAqf;jAqf+1;jAqf+2;jAqf+3];
xAqf=[xAqf;xAqf;xAqf;xAqf];

Aqf=sparse(iAqf,jAqf,xAqf/q3_sc,ntot,nf*ntot);

%% Anf

diablAftf_neig=((A1nmtb-An)*(fa1.*whvec)).*blvec; % dfi1m/dvn in eq. fin
diawhAftf_neig=((A1nmtw-An)*(fa1.*blvec)).*whvec;

nodiablAftfm=spdiags(blvec,0,ntot,ntot)*(A1nmtb-An)*spdiags(fa1.*whvec,0,ntot,ntot);
nodiawhAftfm=spdiags(whvec,0,ntot,ntot)*(A1nmtw-An)*spdiags(fa1.*blvec,0,ntot,ntot);


Anf=nodiablAftfm+nodiawhAftfm+spdiags(diablAftf_neig+diawhAftf_neig,0,ntot,ntot);
%Aftf=spdiags(diablAftf_neig+diawhAftf_neig,0,ntot,ntot);
Anf=Anf/Dt/4;

[iAnf,jAnf,xAnf]=find(real(Anf));
iAnf=[iAnf;iAnf;iAnf;iAnf];
jAnf=ibas_f(jAnf)';
jAnf=[jAnf;jAnf+1;jAnf+2;jAnf+3];
xAnf=[xAnf;xAnf;xAnf;xAnf]/fi_sc;

Anf=sparse(iAnf,jAnf,xAnf,ntot,nf*ntot);


