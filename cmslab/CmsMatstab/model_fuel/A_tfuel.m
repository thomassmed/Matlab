function [Af,Bf,Afq,Afj,Aft] =A_tfuel(matr)

% [iA,jA,xA,iB,jB,xB] = A_tfuel(matr);
%
% INDATA : tfm		- Br„nsletemperatur
%	   qtrissf	- Nodeffekt/m3
%	   tcm		- Kapslingstemperaturen
%	   tl		- Vattentemperaturen
%	   rocf 	- Volymetriska v„rmekapaciteten
%	   rf 		- Kutssradie
%	   e1 		- Termisk konduktivitets parameter 1
% 	   e2 		- Termisk konduktivitets parameter 2
%	   hz		- Nodh÷jd (axiell)
%	   gca0		- Termisk konduktivitetsfaktor parameter 1 f÷r gasgap
%	   gca1		- Termisk konduktivitetsfaktor parameter 2 f÷r gasgap
%	   gca2		- Termisk konduktivitetsfaktor parameter 3 f÷r gasgap
%	   gcamx 	- Maximala termiska konduktiviteten f÷r gasgapet
%	   rlca 	- Termisk konduktivitet f÷r kapslingen
%	   rca 		- Kapslingsradie
%	   drca 	- Kapslingstjocklek
%	   rcca 	- Volymetriska v„rmekapaciteten f÷r kapslingen
%          ihydr	- Transformationsvektor f÷r kanalerna
%	   P            - Systemtrycket
%  	   tw		- V„ggtemperaturen
%	   Wl		- Vattenmassfl÷det
%	   A            - Nodarea
%	   Iboil 	- Kokarvektor
% 	   Dh		- Hydraulisk diameter
%          tw_c         - Koefficienter i från lin_tw
%          tc_c         -            -  "  -                   
%          lam          - Eigenvalue to approximate to


%@(#)   A_tfuel.m 1.22   02/02/27     17:36:33

%%
global geom steady termo fuel neu 

P_sc=matr.P_sc;
q3_sc=matr.q3_sc;
nAI=matr.nAI;
nt=matr.nt;
ibas_t=matr.ibas_t;

kan=geom.kan;
kmax=geom.kmax;
ntot=geom.ntot;
hz=geom.hz;
A=geom.A;
Dh=termo.Dh;
hx=geom.hx;

Iboil=steady.Iboil;
tw=steady.tw;
tw=steady.tw_dyn;
Wl=steady.Wl;
tfm=steady.tfm;
tcm=steady.tcm;
tl=steady.tl;
tc=tcm(:,2);
tc=reshape(tc,kmax,kan);
power=steady.power;

P=termo.P;

mm=fuel.mm;
mmc=fuel.mmc;
rf=fuel.rf;
rca=fuel.rca;
drca=fuel.drca;
nrods=fuel.nrods;
rocf=fuel.rocf;
rcca=fuel.rcca;
e1=fuel.e1;
e2=fuel.e2;
gcamx=fuel.gcamx;
gca0=fuel.gca0;
gca1=fuel.gca1;
gca2=fuel.gca2;
rlca=fuel.rlca;

delta=neu.delta;
deltam=neu.deltam;
cmpfrc=neu.cmpfrc;
qtherm=termo.Qtot/get_sym;

qprimw = (1-delta)*power*qtherm/ntot./(hz/100);
qtrissf=power*qtherm/ntot/(hx/100)^2/(hz/100);
q3l = (delta-deltam)*qtrissf*(hx/100)^2./A;

%%

[tw_c,tc_c,tl_c,P_c] = fin_diff(@eq_tw,tw,tc,tl,P,Wl,A,Iboil,Dh);

%%

hh = 0.1;  % Steg„ndringen f÷r br„nsle- och kapslingstemperaturen
hq = 1;    % Steg„ndringen f÷r effekten
hl = 0.1;  % Steg„ndringen f÷r vattentemperaturen
hp = 100;  % Steg„ndringen f÷r systemtrycket
ht = 0.1;  % Steg„ndringen f÷r tw
hw = 1;    % Steg„ndringen f÷r vattenmassfl÷det

iAfjcount=1;
istammc=1:ntot*(mm+mmc);
len=0;
 
row=zeros(ntot*(mm+mmc),1);
col=zeros(ntot*(mm+mmc),1);


ibasf = 1:(mm+mmc):(mm+mmc)*ntot;
ibasf=ibasf-1;

for i=1:mm+mmc
  row((i-1)*ntot+1:i*ntot)=ibasf+i;
  col((i-1)*ntot+1:i*ntot)=ibasf;
end

iAtf = zeros((mm+mmc)*ntot*(mm+mmc),1);
jAtf = zeros((mm+mmc)*ntot*(mm+mmc),1);
xAtf = zeros((mm+mmc)*ntot*(mm+mmc),1);
 
%% Reference
y0=eq_DtfDt(tfm,qtrissf(:),tcm,tl(:),rocf,rf,e1,e2,gca0,gca1,gca2,...
   gcamx,rlca,rca,drca,rcca,P(:),tw(:),Wl(:),A(:),Iboil(:),Dh(:),hx,cmpfrc,nrods);

%% Fuel temperature finite differences
for i = 1:mm
  tfm(:,i) = tfm(:,i) + hh;
  y2=eq_DtfDt(tfm,qtrissf(:),tcm,tl(:),rocf,rf,e1,e2,gca0,gca1,gca2,...
     gcamx,rlca,rca,drca,rcca,P(:),tw(:),Wl(:),A(:),Iboil(:),Dh(:),hx,cmpfrc,nrods);
  tfm(:,i) = tfm(:,i) - hh;
  lint = (y2-y0)/hh;

  iAtf(istammc+len) = row;
  jAtf(istammc+len) = col+i;
  xAtf(istammc+len) = reshape(lint,ntot*(mm+mmc),1); 
  len=len+ntot*(mm+mmc);
end
%% Cladding temperature
for i = 1+mm:mm+mmc
  tcm(:,i-mm) = tcm(:,i-mm) + hh;
  y2=eq_DtfDt(tfm,qtrissf(:),tcm,tl(:),rocf,rf,e1,e2,gca0,gca1,gca2,...
     gcamx,rlca,rca,drca,rcca,P(:),tw(:),Wl(:),A(:),Iboil(:),Dh(:),hx,cmpfrc,nrods);
  tcm(:,i-mm) = tcm(:,i-mm) - hh;
  lint = (y2 - y0)/hh;

  iAtf(istammc+len) = row;
  jAtf(istammc+len) = col+i;
  xAtf(istammc+len) = reshape(lint,ntot*(mm+mmc),1); 
  len=len+ntot*(mm+mmc);
end
%% Wall temperature
tw = tw(:) + ht;
y2 = eq_DtfDt(tfm,qtrissf(:),tcm,tl(:),rocf,rf,e1,e2,gca0,gca1,gca2,...
	gcamx,rlca,rca,drca,rcca,P(:),tw(:),Wl(:),A(:),Iboil(:),Dh(:),hx,cmpfrc,nrods);
tw = tw(:) - ht;
%%
lint = (y2 - y0)/ht;

tw_cc=lint(:,6);
% iAtf(len+(1:ntot))=ibasf+(mm+mmc);
% jAtf(len+(1:ntot))=ibasf+(mm+mmc+1);
% xAtf(len+(1:ntot))=tw_cc;
% len=len+ntot;
% iAft=ibasf+(mm+mmc);
% jAft=ibas_t+7;
% xAft=tw_cc;
%%{
piv = lint(:,mm+mmc)./tw_c(:);
lint(:,mm+mmc) = -piv.*tc_c(:); %Add coefficient to tc-equation to reduce tw
iAtf(istammc+len) = row;
jAtf(istammc+len) = col+6;
xAtf(istammc+len) = reshape(lint,ntot*(mm+mmc),1); 
len = len + ntot*(mm+mmc);
%%}
%% tw equation
% iAtf((1:2*ntot)+len)=[ibasf'+7;ibasf'+7];
% %                       tw         tc      
% jAtf((1:2*ntot)+len)=[ibasf'+7;ibasf'+6];
% xAtf((1:2*ntot)+len)=[tw_c(:);tc_c(:)];
% len=len+2*ntot;
% % In original matstab, dtwdWl is left out, thus 0* for the time beeing!!
iAft=ibasf+6;
jAft=ibas_t+1;
xAft=-tw_cc(:)'.*tl_c(:)'./tw_c(:)'; %This one has no impact, just for completeness
% iAfj{iAfjcount}=ibasf'+6;
% jAfj{iAfjcount}=nAI*ones(ntot,1);
% xAfj{iAfjcount}=-tw_cc(:)./tw_c(:).*P_c(:)*P_sc;  
% iAfjcount=iAfjcount+1;
%% System pressure
P = P + hp;
y2=eq_DtfDt(tfm,qtrissf(:),tcm,tl(:),rocf,rf,e1,e2,gca0,gca1,gca2,...
      gcamx,rlca,rca,drca,rcca,P(:),tw(:),Wl(:),A(:),Iboil(:),Dh(:),hx,cmpfrc,nrods);
P = P - hp;

lintP = (y2 - y0)/hp;

lintP(:,mm+mmc) = lintP(:,mm+mmc);
%lintP(:,mm+mmc) = lintP(:,mm+mmc) - piv.*P_c(:);
iAfj{iAfjcount} = ibasf+6;
jAfj{iAfjcount} = ones(ntot,1)*nAI;
xAfj{iAfjcount} = (reshape(lintP(:,mm+mmc),ntot,1)-tw_cc(:)./tw_c(:).*P_c(:))*P_sc; 
iAfjcount=iAfjcount+1;
%% Power
qtrissf = qtrissf + hq;
y2=eq_DtfDt(tfm,qtrissf(:),tcm,tl(:),rocf,rf,e1,e2,gca0,gca1,gca2,...
	gcamx,rlca,rca,drca,rcca,P(:),tw(:),Wl(:),A(:),Iboil(:),Dh(:),hx,cmpfrc,nrods);
qtrissf = qtrissf - hq;

lint = (y2 - y0)/hq;
iAfq = row;
jAfq = [(1:ntot)';(1:ntot)';(1:ntot)';(1:ntot)';(1:ntot)';(1:ntot)'];
xAfq = reshape(lint,ntot*(mm+mmc),1)*q3_sc; 

%%
Af=sparse(iAtf,jAtf,xAtf,(mm+mmc)*ntot,(mm+mmc)*ntot);
% iBf=[ibasf+1 ibasf+2 ibasf+3 ibasf+4 ibasf+5 ibasf+6];
% xBf=ones(1,ntot*(mm+mmc));
Bf=speye((mm+mmc)*ntot);
iAfj=cat(1,iAfj{:});
jAfj=cat(1,jAfj{:});
xAfj=cat(1,xAfj{:});
Afj=sparse(iAfj,jAfj,xAfj,(mm+mmc)*ntot,nAI+5);
Afq=sparse(iAfq,jAfq,xAfq,(mm+mmc)*ntot,ntot);
%iAft=cat(2,iAft{:});
%jAft=cat(2,jAft{:});
%xAft=cat(2,xAft{:});
%Aft=sparse(iAft,jAft,xAft,(mm+mmc)*ntot,nt*ntot+2*kan);
Aft=sparse(iAft,jAft,xAft,(mm+mmc)*ntot,nt*ntot+2*kan);



