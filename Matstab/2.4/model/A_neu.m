function [iA,jA,xA]=A_neu(lam,regio);

%[iA,jA,xA]=A_neu(lam,regio);
%
% Generates A-matrices corresponding to the neutronics:
%
% Eq. A34   fa2 = A2nm * fa1
% Eq. A36:  fa1 = A1nm * fa1 
% Eq. A39:    q = Aq   * fa1   = k1h0/keff * (sig1 + sig2 * A2nm) * fa1 
%
% Eq. A37: dfa1 = Anm * dfa1 + Anv * dalfa
% Eq. A40:   dq = Aq  * dfa1 + Aqv * dalfa
%
% Equation numbers taken from Dissertation Ph. Haenggi


global msopt geom termo neu steady

distfile=msopt.DistFile;

rol = cor_rol(termo.P,steady.tl);
rol = matstab2polca(rol);
rog = cor_rog(cor_tsat(termo.P));
rog = matstab2polca(rog);

hz=geom.hz;
hx=geom.hx;
kan=geom.kan;
kmax=geom.kmax;
ntot=geom.ntot;
r=geom.r;
k=geom.k;

nhyd=termo.nhyd;

ibas=neu.ibas;
n_neu_tfuel=neu.n_neu_tfuel;
k1h0=neu.k1h0;

al=neu.al;
b=neu.b;
neig=neu.neig;
ihydr=termo.ihydr;
knum=geom.knum;
keff=steady.keff;
Ppower=steady.Ppower;
Pvoid=steady.Pvoid;
Pdens=steady.Pdens;
Tfm=steady.Tfm;
fa1=steady.fa1;
fa2=steady.fa2;

if nargin<2
  regio=0;
end

%-------------------------------------------------------
% Preparing the distinction of spatial neighbours

[black,white]=chess(distfile);

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


%-------------------------------------------------------
% Calculating equations A18-A21 

[d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
xsec2mstab7(distfile,Pdens,Tfm,knum);
[a11,a21,a22,cp]=read_alb7;

[X1nm,Y1nm,X2nm,Y2nm]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigr,siga2,a11,a21,a22,fa1,fa2,cp,al,b,lam);


%-------------------------------------------------------
% Calculate dqdfa1

%-------------------------------------------------------
% Creating Aq

% Equation A39
A2nm=A_f12(X2nm,Y2nm,neig,siga2,sigr);  
Aq=spdiags(usig2./ny,0,ntot,ntot)*A2nm;
Aq=Aq+spdiags(usig1./ny,0,ntot,ntot);
Aq=Aq*k1h0/keff;

[iAq,jAq,xAq]=find(Aq);
iAq=[(ibas+6);(ibas(iAq)+6)];
jAq=[(ibas+6);(ibas(jAq)+1)];
xAq=[-ones(ntot,1);xAq];

%-------------------------------------------------------
% Creating Anm

% Calulate fa20 in fa20 = A2nm * fa1 (eq. 34)
fa20=A2nm*fa1;

% Calculate X1nm,X2nm,Y1nm,Y2nm with fa20 rather than fa2
[X1nm,Y1nm,X2nm,Y2nm]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigr,siga2,a11,a21,a22,fa1,fa20,cp,al,b,lam);

% Equation 36
Anm=eq_A1nm(neig,X1nm,Y1nm,X2nm,Y2nm,usig2,usig1,siga1,sigr,siga2,...
keff,al,b,lam,regio);

[iAn,jAn,xAn]=find(Anm);
iAn=ibas(iAn)+1;
jAn=(jAn-1)*n_neu_tfuel+nhyd+1;



%-------------------------------------------------------
% Create Aqv and Anv

dqdv0=k1h0*(usig1./ny.*fa1+usig2./ny.*(A2nm*fa1))/keff;

% Disturbe the void
delta=0.0001;
Pdens_bl=Pdens+delta*bb.*(rog-rol);
[d1,d2,sigrbl,siga1,siga2bl,usig1,usig2,ny]=...
xsec2mstab7(distfile,Pdens_bl,Tfm,knum);

[X1bl,Y1bl,X2bl,Y2bl]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrbl,siga2bl,a11,a21,a22,fa1,fa20,cp,al,b,lam);

blA1nm=eq_A1nm(neig,X1bl,Y1bl,X2bl,Y2bl,usig2,usig1,siga1,sigrbl,siga2bl,...
keff,al,b,lam,regio);


dqdvbl=k1h0*(usig1./ny.*fa1+usig2./ny.*(A2nm*fa1))/keff;

Pdens_wh=Pdens+delta*bw.*(rog-rol);
[d1,d2,sigrwh,siga1,siga2wh,usig1,usig2,ny]=...
xsec2mstab7(distfile,Pdens_wh,Tfm,knum);


[X1wh,Y1wh,X2wh,Y2wh]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrwh,siga2wh,a11,a21,a22,fa1,fa20,cp,al,b,lam);

whA1nm=eq_A1nm(neig,X1wh,Y1wh,X2wh,Y2wh,usig2,usig1,siga1,sigrwh,siga2wh,...
keff,al,b,lam,regio);

dqdvwh=k1h0*(usig1./ny.*fa1+usig2./ny.*(A2nm*fa1))/keff;

void=(Pvoid>0); 
void=void(:,knum(:,1));void=void(:);


diablAnv_neig=((blA1nm-Anm)*(fa1.*whvec)).*blvec/delta; % dfi1m/dvn in eq. fin
diawhAnv_neig=((whA1nm-Anm)*(fa1.*blvec)).*whvec/delta;

nodiablAnvm=spdiags(blvec,0,ntot,ntot)*(whA1nm-Anm)*spdiags(fa1.*whvec,0,ntot,ntot)/delta;
nodiawhAnvm=spdiags(whvec,0,ntot,ntot)*(blA1nm-Anm)*spdiags(fa1.*blvec,0,ntot,ntot)/delta;


Anv=nodiablAnvm+nodiawhAnvm+spdiags(diablAnv_neig+diawhAnv_neig,0,ntot,ntot);
Anv=Anv*spdiags(void,0,ntot,ntot);

dA2dv=eq_dA2dv(neig,fa1,delta,X2nm,Y2nm,sigr,siga2,...
      X2bl,Y2bl,sigrbl,siga2bl,blvec,X2wh,Y2wh,sigrwh,siga2wh,whvec);

Aqv=spdiags(void.*(dqdvbl+dqdvwh-dqdv0-dqdv0)/delta,0,ntot,ntot);
Aqv=Aqv+k1h0*spdiags(usig2./ny,0,ntot,ntot)*dA2dv;

% Disturbe the temperature
Dt=5;
DPdt=0.007;
Tfmbl=Tfm+Dt*bb;
[d1,d2,sigrbl,siga1,siga2bl,usig1,usig2,ny]=...
xsec2mstab7(distfile,Pdens,Tfmbl,knum);


[X1nmtb,Y1nmtb,X2nmtb,Y2nmtb]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrbl,siga2bl,a11,a21,a22,fa1,fa20,cp,al,b,lam);


A1nmtb=eq_A1nm(neig,X1nmtb,Y1nmtb,X2nmtb,Y2nmtb,usig2,usig1,siga1,sigrbl,siga2bl,...
keff,al,b,lam,regio);
dqdtb=k1h0*(usig1./ny.*fa1+usig2./ny.*(A2nm*fa1))/keff;

Tfmbl=Tfm+Dt*bw;
[d1,d2,sigrwh,siga1,siga2wh,usig1,usig2,ny]=...
xsec2mstab7(distfile,Pdens,Tfmbl,knum);

[X1nmtw,Y1nmtw,X2nmtw,Y2nmtw]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,...
siga1,sigrwh,siga2wh,a11,a21,a22,fa1,fa20,cp,al,b,lam);


A1nmtw=eq_A1nm(neig,X1nmtw,Y1nmtw,X2nmtw,Y2nmtw,usig2,usig1,siga1,sigrwh,siga2wh,...
keff,al,b,lam,regio);
dqdtw=k1h0*(usig1./ny.*fa1+usig2./ny.*(A2nm*fa1))/keff;

dA2dt=eq_dA2dv(neig,fa1,1,X2nm,Y2nm,sigr,siga2,...
      X2nmtb,Y2nmtb,sigrbl,siga2bl,blvec,X2nmtw,Y2nmtw,sigrwh,siga2wh,whvec);


xAqtf0=dqdtw+dqdtb-dqdv0-dqdv0+k1h0;
Aqtf=spdiags(dqdtw+dqdtb-dqdv0-dqdv0,0,ntot,ntot)+k1h0*spdiags(usig2./ny,0,ntot,ntot)*dA2dt;
Aqtf=Aqtf/Dt;

diablAftf_neig=((A1nmtb-Anm)*(fa1.*whvec)).*blvec; % dfi1m/dvn in eq. fin
diawhAftf_neig=((A1nmtw-Anm)*(fa1.*blvec)).*whvec;

nodiablAftfm=spdiags(blvec,0,ntot,ntot)*(A1nmtb-Anm)*spdiags(fa1.*whvec,0,ntot,ntot);
nodiawhAftfm=spdiags(whvec,0,ntot,ntot)*(A1nmtw-Anm)*spdiags(fa1.*blvec,0,ntot,ntot);


Aftf=nodiablAftfm+nodiawhAftfm+spdiags(diablAftf_neig+diawhAftf_neig,0,ntot,ntot);
%Aftf=spdiags(diablAftf_neig+diawhAftf_neig,0,ntot,ntot);
Aftf=Aftf/Dt/4;


[iAtf,jAtf,xAtf]=find(Aftf);
jAtf=ibas(jAtf);
jAnf=[jAtf+7;jAtf+8;jAtf+9;jAtf+10];
iAtf=ibas(iAtf)+1;
iAnf=[iAtf;iAtf;iAtf;iAtf];
xAnf=[xAtf;xAtf;xAtf;xAtf];

[iAqtf,jAqtf,xAqtf]=find(Aqtf);
xAqtf=xAqtf/4;
iAqtf=ibas(iAqtf)+6;
iAqf=[iAqtf;iAqtf;iAqtf;iAqtf];
jAqtf=ibas(jAqtf);
jAqf=[jAqtf+7;jAqtf+8;jAqtf+9;jAqtf+10];
xAqf=[xAqtf;xAqtf;xAqtf;xAqtf];


[iAnv,jAnv,xAnv]=find(Anv);
jAnv=r(jAnv)';
iAnv=ibas(iAnv)+1;

[iAqv,jAqv,xAqv]=find(Aqv);
jAqv=r(jAqv)';
iAqv=ibas(iAqv)+6;


% Merge the matrices
iA=[iAn;iAq;iAnv;iAqv;iAnf;iAqf];
jA=[jAn;jAq;jAnv;jAqv;jAnf;jAqf];
xA=[xAn;xAq;xAnv;xAqv;xAnf;xAqf];


ii=find(jA<(n_neu_tfuel*kmax*kan+1+nhyd));
iA=iA(ii);jA=jA(ii);xA=xA(ii);
%@(#)   A_neu.m 1.4   98/04/06     07:52:38

