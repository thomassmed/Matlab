function [iAtf,jAtf,xAtf,iBtf,jBtf,xBtf] = A_tfuel(lam)

% INDATA : tfm		- Br„nsletemperatur
%	   qtrissf	- Nodeffekt/m3
%	   tcm		- Kapslingstemperaturen
%	   tl		- Vattentemperaturen
%	   rf 		- Kutssradie
%	   hz		- Nodh÷jd (axiell)
%	   rca 		- Kapslingsradie
%	   drca 	- Kapslingstjocklek
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




global geom steady termo fuel neu 

kan	= geom.kan;
kmax	= geom.kmax;
ntot 	= geom.ntot;
nvn	= geom.nvn;
A	= geom.A;
Dh	= geom.Dh;
hx	= geom.hx;

Iboil	= steady.Iboil;
tw	= steady.tw;
Wl	= steady.Wl;
tfm	= steady.tfm;
tcm	= steady.tcm;
tfM 	= steady.tfM;
tc0	= steady.tc0;
qtrissf	= steady.qtrissf;
tl	= steady.tl;
tc	= steady.tc;

ihydr	= termo.ihydr;
P	= termo.P;

cmpfrc	= neu.cmpfrc;
ibas	= neu.ibas;

mm	= fuel.mm;
mmc	= fuel.mmc;
rf	= fuel.rf;
rca	= fuel.rca;
drca	= fuel.drca;
drc 	= drca/mmc;
nrods	= fuel.nrods;
 
[tw_c,tc_c,tl_c,P_c] = lin_tw(tw,tc,tl,P,Wl,A,Iboil,Dh);

P 	= set_th2ne(P,ihydr);
tw 	= set_th2ne(tw,ihydr);
Wl 	= set_th2ne(Wl,ihydr);
A 	= set_th2ne(A,ihydr);
Iboil 	= set_th2ne(Iboil,ihydr);
Dh 	= set_th2ne(Dh,ihydr);
tl 	= set_th2ne(tl,ihydr);
tw_c 	= set_th2ne(tw_c,ihydr);
tc_c 	= set_th2ne(tc_c,ihydr);
P_c 	= set_th2ne(P_c,ihydr);

hh = 0.1;  % Steg„ndringen f÷r br„nsle- och kapslingstemperaturen
hq = 1;    % Steg„ndringen f÷r effekten
hl = 0.1;  % Steg„ndringen f÷r vattentemperaturen
hp = 100;  % Steg„ndringen f÷r systemtrycket
ht = 0.1;  % Steg„ndringen f÷r tw
hw = 1;    % Steg„ndringen f÷r vattenmassfl÷det

istammc	= 1:ntot*(mm+mmc);
len	= 0;
 
row	= zeros(ntot*(mm+mmc),1);
col	= zeros(ntot*(mm+mmc),1);
[rn,kn]	= get_neutnodes;
ineu	= rn-1;
kk	= zeros(ntot*(mm+mmc),1);

ibasf 	= kn-1;
nneu	= nvn-mm-mmc;

for i=1:mm+mmc
  row((i-1)*ntot+1:i*ntot)	= ibasf+i+nneu;
  col((i-1)*ntot+1:i*ntot)	= ibasf+nneu;
  kk((i-1)*ntot+1:i*ntot)	= ineu;
end

iAtf 	= zeros((mm+mmc)*ntot*(mm+mmc+5),1);
jAtf 	= zeros((mm+mmc)*ntot*(mm+mmc+5),1);
xAtf 	= zeros((mm+mmc)*ntot*(mm+mmc+5),1);

 
%Reference

y0 = eq_DtfDt(tfm,tfM,qtrissf,tc0,tcm,rf,drca,tw,hx,cmpfrc,nrods);


%Fuel temperature
for i = 1:mm
  tfm(:,i) = tfm(:,i) + hh;
    
  y2 = eq_DtfDt(tfm,tfM,qtrissf,tc0,tcm,rf,drca,tw,hx,cmpfrc,nrods);
    
  tfm(:,i) = tfm(:,i) - hh;
  lint = (y2-y0)/hh;

  iAtf(istammc+len) = row;
  jAtf(istammc+len) = col+i;
  xAtf(istammc+len) = reshape(lint,ntot*(mm+mmc),1); 
  len=len+ntot*(mm+mmc);
end

%Cladding temperature
for i = 1+mm:mm+mmc
  tcm(:,i-mm) = tcm(:,i-mm) + hh;
    
  y2 = eq_DtfDt(tfm,tfM,qtrissf,tc0,tcm,rf,drca,tw,hx,cmpfrc,nrods);
  
  tcm(:,i-mm) = tcm(:,i-mm) - hh;
  lint = (y2 - y0)/hh;

  iAtf(istammc+len) = row;
  jAtf(istammc+len) = col+i;
  xAtf(istammc+len) = reshape(lint,ntot*(mm+mmc),1); 
  len=len+ntot*(mm+mmc);
end

%Wall temperature
tw = tw + ht;

y2 = eq_DtfDt(tfm,tfM,qtrissf,tc0,tcm,rf,drca,tw,hx,cmpfrc,nrods);
	
tw = tw - ht;
lint = (y2 - y0)/ht;

piv = lint(:,mm+mmc)./tw_c;
lint(:,mm+mmc) = -piv.*tc_c; %Add coefficient to tc-equation to reduce tw 	
iAtf(istammc+len) = row;
jAtf(istammc+len) = col+6;
xAtf(istammc+len) = reshape(lint,ntot*(mm+mmc),1); 
len = len + ntot*(mm+mmc);


%System pressure

P = P + hp;

y2 = eq_DtfDt(tfm,tfM,qtrissf,tc0,tcm,rf,drca,tw,hx,cmpfrc,nrods);		% egentligen onödig, ger 0 derivata...
										% derivatan kommer in då den inre derivatan av tw
										% map P adderas
P = P - hp;

lintP = (y2 - y0)/hp;

lintP(:,mm+mmc) = lintP(:,mm+mmc) - piv.*P_c;					
iAtf(istammc+len) = row;
jAtf(istammc+len) = ones(ntot*(mm+mmc),1);
xAtf(istammc+len) = reshape(lintP,ntot*(mm+mmc),1); 
len=len + ntot*(mm+mmc);


%Power
qtrissf = qtrissf + hq;

y2 = eq_DtfDt(tfm,tfM,qtrissf,tc0,tcm,rf,drca,tw,hx,cmpfrc,nrods);
	
qtrissf = qtrissf - hq;

lint = (y2 - y0)/hq;
iAtf(istammc+len) = row;
jAtf(istammc+len) = col;
xAtf(istammc+len) = reshape(lint,ntot*(mm+mmc),1); 
len=len+ntot*(mm+mmc);


j1=find(~xAtf);iAtf(j1)=[];jAtf(j1)=[];xAtf(j1)=[];

iBtf=row;jBtf=iBtf;xBtf=ones(size(iBtf));




