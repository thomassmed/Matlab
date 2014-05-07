function steady_state

global msopt polcadata geom termo neu fuel steady 

distfile=msopt.DistFile;

nin=geom.nin;
ncc=geom.ncc;
hz=geom.hz;
hx=geom.hx;
Hz=geom.Hz;
Dh=geom.Dh;
A=geom.A;
knum=geom.knum;

p=termo.p;
P=termo.P;
ihydr=termo.ihydr;
twophasekorr=termo.twophasekorr;
dc2corr=termo.dc2corr;
pump=termo.pump;
pk1=termo.pk1;
pk2=termo.pk2;

delta=neu.delta;
b=neu.b;
betacorr=neu.betacorr;
al=neu.al;

mmc=fuel.mmc;
rf=fuel.rf;
rca=fuel.rca;
drca=fuel.drca;
nrods=fuel.nrods;
ntot = geom.ntot;

[Ppower,Pvoid,Pfi1,Pfi2,powr,qtherm,qtrissf,qprimw,keff, ...
fa1,fa2,tw,Iboil,alfa,Wl,Wg,tl,gammav,mg,romum,S,wl,wg, ...
jm,vhk,Pdens,Tfm] = power_void;

% Delayed neutrons

switch neu.NeuModel

case 'POLCA4'
  burnup=readdist(distfile,'burnup');
  burnup=burnup(:,knum(:,1));burnup=burnup(:);

%  void=Pvoid(:,knum(:,1));void=void(:);
  void=readdist(distfile,'void');
  void=void(:,knum(:,1));void=void(:);
% slut test
  vhist=readdist(distfile,'vhist');
  vhist=vhist(:,knum(:,1));vhist=vhist(:);
  corr=betacorr*[ones(size(burnup)) burnup/1e3 burnup.^2/1e6 void vhist]';
  b=b*corr/b(4);
  al=al*ones(size(burnup))';
case 'POLCA7'
  [speed,b_tmp,al_tmp]=delay2mstab7(distfile,Pdens);

  %check if delay2mstab was successful, else use correlation
  if any(any(b_tmp))
    disp('Using beta from dist file')
    b=b_tmp;
    al=al_tmp;
    neu.betacorr=[]; % set to empty to make it clear that betacorr was not used
  else
    %use correlation
    burnup=readdist(distfile,'burnup');
    burnup=burnup(:,knum(:,1));burnup=burnup(:);
    void=Pvoid(:,knum(:,1));void=void(:);
    dnshis=readdist7(distfile,'dnshis');
    dnshis=dnshis(:,knum(:,1));dnshis=dnshis(:);
    raal=739.3094; % Density of water at 70.5 Bar
    raag=36.8209;  % Density of steam at 70.5 Bar
    vhist=(raal-dnshis)/(raal-raag);
    corr=betacorr*[ones(size(burnup)) burnup burnup.^2 void vhist]';
    b=b*corr/b(4);
    al=al*ones(size(burnup))';
  end
end

neu.b=b;
neu.betasum=sum(b);
neu.al=al;





%Fuel and cladding temperatures 
%---------------------------------------------------------------

pbm=geom.pbm;
phm=geom.phm;
tlp=termo.tlp;
htc=termo.htc;

%---------------------------------------------------------------
% Gör ny beräkning av tw baserad på senaste powr
%	Emma Lundgren 050930
%---------------------------------------------------------------

[tw,Iboil] =eq_tw0(P,powr,qtherm,delta,htc,pbm,phm,hz,tlp,tl,Wl,Wg,Dh,A);

%---------------------------------------------------------------
% Gör ny beräkning av qtrissf baserad på senaste powr
%	Emma Lundgren 050930
%---------------------------------------------------------------

qtrissf = powr*qtherm/ntot/(hx/100)^2/(hz/100);


[tfm,tcm,tfM,tc0] = eq_tftc(tw,qtherm,powr,hz,rf,rca,drca,p,delta,nrods);
	
%---------------------------------------------------------------





tc = set_ntohvec(tcm(:,mmc),ihydr);

ploss = eq_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,dc2corr,twophasekorr);
phcpump = eq_ppump(ploss);

j = nin(3) + 1;
nhcpump = eq_npump(Wl(j),P(j),tl(j),phcpump,pump,pk1,pk2);

termo.phcpump=phcpump;
termo.nhcpump=nhcpump;

vhk(nin(5+ncc)+ncc+1)=-650;

steady.Wl=Wl;
steady.tl=tl;
steady.Iboil=Iboil;
steady.qtrissf=qtrissf;
steady.keff=keff;
steady.Ppower=Ppower;
steady.Pvoid=Pvoid;
steady.Pdens=Pdens;
steady.Tfm=Tfm;
steady.fa1=fa1;
steady.fa2=fa2;
steady.tfm=tfm;
steady.tcm=tcm;
steady.tfM=tfM;
steady.tc0=tc0;
steady.tw=tw;
steady.tc=tc;
steady.S=S;
steady.Wg=Wg;
steady.alfa=alfa;
steady.gammav=gammav;
steady.jm=jm;
steady.qprimw=qprimw;
steady.romum=romum;
steady.wg=wg;
steady.mg=mg;
steady.ploss=ploss;
steady.vhk=vhk;


% eq_bpinlet needs to be calculated with the steady structure
ktmp = fzero('eq_bpinlet',vhk(nin(5+ncc)+ncc+1),optimset('TolX',0.01));	           %bypass pressure drop
if ktmp>0,error('Pressuredrop for byp.inlet positive!'),end
vhk(nin(5+ncc)+ncc+1) = ktmp;

%ploss once again for the bypass
ploss = eq_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,dc2corr,twophasekorr);

steady.ploss=ploss;
steady.vhk=vhk;


save('-append',msopt.MstabFile,'msopt','polcadata','geom','steady','termo','neu','fuel')  
