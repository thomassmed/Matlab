function [iAhyd,jAhyd,xAhyd,iBhyd,jBhyd,xBhyd]=A_hydro;

%A_hydro
%[iAhyd,jAhyd,xAhyd,iBhyd,jBhyd,xBhyd]=A_hydro;
% 
%Builds the system matrix for the thermo
%hydraulics. 
%
%Input: See get_inp for more information
%
%Output: iAhyd,jAhyd,xAhyd,iBhyd,jBhyd,xBhyd are row and column
%indecies (iA,jA) and values (xA) in the system matrices A and B
%in the equation below
%
%   dx
% B -- = Ax 
%   dt
%
%@(#)   A_hydro.m 2.12   02/02/27     17:50:01

%T/H-nodes contains following parameters (see also page 13 in the book ISBN 3-905404-21-4)
%
%                1     2   3   4     5     6    7    8    9    10   11  12  13      
%
%              alfa    E   -   Wl  gamma  q'w   tl   tw   Wg   wg   S   jm  phi  P  Neig       
%
%d(alfa)/dt =                        V                    -1                         X
%d(E)/dt    =   X              hl         V/A             hg                     X   X
%  0        =   0  (free)
%  0        =   X              -1               X                   X   X        X
%  0        =   X                   -1          X    X                           X 
%  0        =                  X          -1    X    X                           X
%  0        =   X      X                       -1 
%  0        =                                       -1                           X
%  0        =   X                          X    X    X    -1   X                 X
%  0        =   X                                             -1    X   X
%  0        =   X                                                  -1
%  0        =                  X     X                     X           -A            X
%  0        =   0  (free)


global geom termo neu steady
global DRog_DP DRof_DP Dtsat_DP DCpl_DP DRol_DP DRol_Dtl

nin=geom.nin;
nout=geom.nout;
ncc=geom.ncc;
Dh=geom.Dh;
A=geom.A;
V=geom.V;
Hz=geom.Hz;
hx=geom.hx;
pbm=geom.pbm;
phm=geom.phm;

ihydr=termo.ihydr;
p=termo.p;
P=termo.P;
twophasekorr=termo.twophasekorr;
dc2corr=termo.dc2corr;
phcpump=termo.phcpump;
nhcpump=termo.nhcpump;
pump=termo.pump;
pk=termo.pk;
ptype=termo.ptype;

delta=neu.delta;
deltam=neu.deltam;
cmpfrc=neu.cmpfrc;

tl=steady.tl;
Iboil=steady.Iboil;
tc=steady.tc;
tw=steady.tw;
S=steady.S;
Wl=steady.Wl;
Wg=steady.Wg;
alfa=steady.alfa;
gammav=steady.gammav;
jm=steady.jm;
qprimw=steady.qprimw;
romum=steady.romum;
vhk=steady.vhk;
wg=steady.wg;
mg=steady.mg;

thsize = get_thsize;

ts1 = cor_tsat(p*1.001);
dp = p*1.001-p;
tsat=cor_tsat(P);
tsat0=tsat(1);
DRog_DP = (cor_rog(ts1)-cor_rog(tsat0))/dp;
DRof_DP = (cor_rof(ts1)-cor_rof(tsat0))/dp;

Dtsat_DP = (ts1-tsat0)/dp;
DCpl_DP = (cor_cpl(ts1)-cor_cpl(tsat0))/dp;
%Needs to be after power_void because tl is an input
[DRol_DP,DRol_Dtl]=fin_diff('cor_rol',P,tl);

iAhyd=[];
jAhyd=[];
xAhyd=[];
count=1;

%Get the nodes
tic,nv = get_varsize;
realnodes = get_realnodes;
realnodes(1) = 0; %Steam dome is dealed separately
Tsat = cor_tsat(P);
Tsat0 = Tsat;

%P, system pressure                                 (A.108)

[P_c,gammav_c,tl_c]=lin_P(P,gammav,tl,alfa,V);

iAhyd{count} = ones(1,thsize*2+1);
jAhyd{count} = [1,ind_tnk(5,nv),ind_tnk(7,nv)];
xAhyd{count} = [P_c;gammav_c;tl_c];
count=count+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%mg, steam mass                                     (A.111)
%void, this equation is the same as the original
%steam mass equation but the relation between mg and alfa
%is multiplied in to the B-matrix
ri = [ind_tnr(1,nv),ind_tnr(1,nv)];
ki = [ind_tnk(5,nv),ind_tnk(9,nv)];
l = find(Wg(1:nout(1)));
ctmp = [V.*(gammav>0).*realnodes];
ctmp(l) = zeros(length(l),1);  %Reduce dynamics by carry-under
ctmp1 = [-ones(thsize,1).*(Wg>0).*realnodes];
ctmp1(l) = zeros(length(l),1);
xi = [ctmp;ctmp1];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%grannarna
[rtmp,ktmp] = ind_thneig(1,9,nv);
j = get_thneig;
ri = rtmp;
ki = ktmp;
ctmp = ones(thsize,1).*(Wg>0).*realnodes;

%Ta bort kondenserings-grannar
ctmp(l) = zeros(length(l),1);
xi =ctmp(j); 
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Summering vid core-exit
%the first riser node is not made yet, because nin(6+ncc) is its neig
%which was deletet by multiplying with realnodes

rtmp = ind_tnr(1,nv);rtmp = rtmp(nin(6+ncc)+1)*ones(1,ncc);
ktmp = ind_tnk(9,nv);ktmp = ktmp(nout(5:(4+ncc))); %Ej bypasskanalen
ctmp = ones(ncc,1)*get_sym;
ri = rtmp;
ki = ktmp;
xi = ctmp;
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Rom_um, Energy                                   (A.89)
%B-coefficent V, generated with the B-matrix 
rtmp = ind_tnr(2,nv);
ri = [rtmp,rtmp,rtmp,rtmp,rtmp];
ki = [ind_tnk(1,nv),ind_tnk(2,nv),ind_tnk(4,nv),...
    ind_tnk(6,nv),ind_tnk(9,nv)];

Htc = termo.htc*ones(get_thsize,1);
[alfa_c,romum_c,Wl_c,qprimw_c,Wg_c] = lin_E(alfa,romum,Wl,Wg,tl,P,Tsat0,V,A,Htc,pbm,Hz);
rn = realnodes;
xi =[-alfa_c.*rn.*(alfa>0);-romum_c.*rn;-Wl_c.*rn;qprimw_c.*rn;-Wg_c.*rn];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;


%------------------Neighbours
[j,j0] = get_thneig;                   %All neighbours

%the first riser node is taken out and done in the next block
nn = find(j0==nin(6+ncc)+1);
j(nn) = [];j0(nn) = [];

%alfa
[rtmp,ktmp] = ind_thneig(2,1,nv);rtmp(nn)=[];ktmp(nn)=[];
ri = rtmp;
ki = ktmp;
xi = alfa_c(j).*(alfa(j)>0);
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%romum
[rtmp,ktmp] = ind_thneig(2,2,nv);rtmp(nn)=[];ktmp(nn)=[];
ri = rtmp;
ki = ktmp;
xi = romum_c(j);
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Wl
[rtmp,ktmp] = ind_thneig(2,4,nv);rtmp(nn)=[];ktmp(nn)=[];
ri = rtmp;
ki = ktmp;
xi = Wl_c(j);
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Wg
[rtmp,ktmp] = ind_thneig(2,9,nv);rtmp(nn)=[];ktmp(nn)=[];
ri = rtmp;
ki = ktmp;
xi = Wg_c(j).*(alfa(j)>0);
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%------------------qtriss_c, gamma heat in channel
[rneu,kneu] = get_neutnodes(2,6);
j = get_chnodes;j(1:ncc)=[];
tmp = (delta-deltam)/delta*cmpfrc*((hx/100)^2)./A(j);
cneu = A(j).*Hz(j).*(1-alfa(j)).*tmp;
cneu = set_coretransf(cneu);
cneu = set_th2ne(cneu,ihydr);

ri = rneu;
ki = kneu;
xi = cneu;
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Bypass channel, gamma heat
j = get_bneigs;rtmp = ind_tnr(2,nv);
rtmp = set_coretransf(rtmp(j));
rtmp = set_th2ne(rtmp,ihydr)';

cbyp = deltam/delta*cmpfrc*((hx/100)^2)./A(j);
cbyp = A(j).*Hz(j).*cbyp;
cbyp = set_coretransf(cbyp);
cbyp = set_th2ne(cbyp,ihydr);

ri = [rtmp];
ki = [kneu];
xi = [cbyp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%-----------------core exit
%Summering vid core-exit
j1 = nin(5+ncc+1)+1;
j = nout(5:(5+ncc));

rtmp = ind_tnr(2,nv);rtmp = rtmp(j1)*ones(1,ncc+1);
%alfa
ktmp = ind_tnk(1,nv);ktmp = ktmp(j);
ri = [rtmp];ki = [ktmp];xi =[alfa_c(j).*(alfa_c(j)>0)*get_sym];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%romum
ktmp = ind_tnk(2,nv);ktmp = ktmp(j);
ri = [rtmp];ki = [ktmp];xi =[romum_c(j)*get_sym];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Wl
ktmp = ind_tnk(4,nv);ktmp = ktmp(j);
ri = [rtmp];ki = [ktmp];xi =[Wl_c(j)*get_sym];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Wg
ktmp = ind_tnk(9,nv);ktmp = ktmp(j);
ri = [rtmp];ki = [ktmp];xi =[Wg_c(j)*get_sym];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Inlet nodes with d(DE)/dt = 0
j1 = nin(1:(5+ncc));
rtmp = ind_tnr(2,13);
ri = [rtmp(j1)];
ktmp = ind_tnk(2,13);ki = [ktmp(j1)];
xi =[ones(5+ncc,1)];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%alfa, Void                                   (A.90)
%This i used in the B-matrix. The algebraic equation is 
%reduced to the diff. eq. mg
xBhyd = lin_alfa(alfa,P,V);j1=find(xBhyd);
xBhyd(j1) = 1./xBhyd(j1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Wl, Mass flow, water                          (A.101)
    
rtmp = ind_tnr(4,nv);
ri = [rtmp,rtmp,rtmp,rtmp,rtmp];
ki = [ind_tnk(1,nv),ind_tnk(4,nv),ind_tnk(11,nv),ind_tnk(12,nv),ind_tnk(7,nv)];
[P_c,jm_c,alfa_c,S_c,tl_c]=lin_Wl(P,jm,alfa,S,tl,A,Wl);
ctmp = -ones(thsize,1);ctmp(1) = 0;
xi =[alfa_c;ctmp;S_c;jm_c;tl_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%qammav, Steam generation                      (A.102)

rtmp = ind_tnr(5,nv);
ri = [rtmp,rtmp,rtmp,rtmp,rtmp];
ki = [ind_tnk(1,nv),ind_tnk(5,nv),ind_tnk(6,nv),...
ind_tnk(7,nv),ones(1,thsize)];
[qprimw_c,P_c,tl_c,tw_c,alfa_c]=lin_gamv(qprimw,P,tl,tw,alfa,gammav,A);
xi =[alfa_c;-ones(thsize,1).*(gammav>0).*realnodes;qprimw_c;tl_c;P_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%qprimw, Heat                                   (A.105)

rtmp = ind_tnr(6,nv);
ri = [rtmp,rtmp,rtmp,rtmp];
ki = [ind_tnk(4,nv),ind_tnk(6,nv),ind_tnk(8,nv),ones(1,thsize)];
[P_c,Wl_c,tw_c]=lin_qprimw(P,Wl,tw,tl,A,phm,Dh,Htc,Iboil);
ctmp = zeros(thsize,1);ctmp(get_chnodes) = -ones(length(get_chnodes),1);
xi = [Wl_c;ctmp.*realnodes;tw_c;P_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%tl, Liquid temparature                         (A.106)
rtmp = ind_tnr(7,nv);
ri = [rtmp,rtmp,rtmp];
ki = [ind_tnk(2,nv),ind_tnk(1,nv),ind_tnk(7,nv)];
[alfa_c,P_c,tl_c,romum_c]=lin_tldiff(alfa,P,tl,romum,Tsat0);
xi =[romum_c;alfa_c;tl_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Junctions
j = nout;j(length(j))=[];
rtmp = ind_tnr(7,nv);
rtmp = rtmp(j+1);
ktmp = ind_tnk(7,nv);
ktmp = ktmp(j);
ctmp = -ones(length(j),1);
ri = [rtmp];
ki = [ktmp];
xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%tw, Wall temperature                           (A.107)
ri = [ind_tnr(8,nv),ind_tnr(8,nv),ind_tnr(8,nv)];
ki = [ind_tnk(8,nv),ones(1,thsize),ind_tnk(7,nv)];
[tw_c,tc_c,tl_c,P_c] = lin_tw(tw,tc,tl,P,Wl,A,Iboil,Dh);
xi =[tw_c;P_c;tl_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;


%Neutroniknoderna
[rneu,kneu,nneu] = get_neutnodes(8,12);

j = get_chnodes;j(1:ncc)=[];
tc_c=set_th2ne(tc_c,ihydr);

ri = rneu;
ki = kneu;
xi = tc_c;
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Wg, Mass flow, steam                           (A.100)

ri = [ind_tnr(9,nv),ind_tnr(9,nv),ind_tnr(9,nv),ind_tnr(9,nv)];
ki = [ind_tnk(1,nv),ind_tnk(9,nv),ind_tnk(10,nv),ones(1,thsize)];
[P_c,wg_c,alfa_c]=lin_Wg(P,wg,alfa,A);
xi =[alfa_c;-ones(thsize,1).*realnodes.*(Wg>0);wg_c;P_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%wg, velocity                                   (A.98)
ri = [ind_tnr(10,nv),ind_tnr(10,nv),ind_tnr(10,nv),ind_tnr(10,nv)];
ki = [ind_tnk(1,nv),ind_tnk(10,nv),ind_tnk(11,nv),ind_tnk(12,nv)];
[S_c,jm_c,alfa_c]=lin_vg(S,jm,alfa,wg);
xi =[alfa_c;-ones(thsize,1).*realnodes.*(alfa>0);S_c;jm_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%S, Slip                                        (A.96)
ri = [ind_tnr(11,nv),ind_tnr(11,nv),ind_tnr(11,nv)];
ki = [ind_tnk(1,nv),ind_tnk(11,nv),ones(1,thsize)];
[alfa_c,P_c] = lin_slip(alfa,P,'bmalnes');
xi =[alfa_c.*realnodes;-ones(thsize,1).*realnodes.*(alfa>0);P_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%jm, Mass flux                                   (A.91)
ri = ind_tnr(12,nv);
ki = ind_tnk(12,nv);
not_inlet = ones(thsize,1);
j1 = nin(5):(nin(5)+2*ncc+1);
not_inlet(j1) = zeros(2*(ncc+1),1);
ctmp = -A.*not_inlet;
ctmp(1) = 0;
xi =ctmp;
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Neighbours: jm is used for conections in junctions
[rtmp,ktmp] = ind_thneig(12,12,nv);
j1 = nin(5:(5+ncc));
not_nin = ones(thsize,1);
not_nin(j1) = zeros(ncc+1,1);
j = get_thneig;
ri = [rtmp];
ki = [ktmp];
xi =[A(j).*not_nin(j)];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Sum in first node: (AJm)0
rtmp = ind_tnr(12,nv);
rtmp = rtmp(nin(1))*ones(1,1+ncc);
ktmp = ind_tnk(12,nv);
ktmp = ktmp(nin(5:(ncc+5)));
ctmp = A(nin(5:(ncc+5)))*get_sym;
ri = [rtmp];ki = [ktmp];xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Sum in core-exit
rtmp = ind_tnr(12,nv);rtmp = rtmp(nin(5+ncc+1))*ones(1,ncc+1);
ktmp = ind_tnk(12,nv);ktmp = ktmp(nout(5:(5+ncc)));
ctmp = A(nout(5:(5+ncc)))*get_sym;
ri = [rtmp];ki = [ktmp];xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Sum in postions where who has no junctions
rtmp = ind_tnr(12,nv);rtmp = rtmp(nin(2:4));
ktmp = ind_tnk(12,nv);ktmp = ktmp(nin(2:4))-nv;
ctmp = A(nin(1:3));
ri = [rtmp];ki = [ktmp];xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Make Jm,core inlet-  equal to Jm,core inlet+
rtmp = ind_tnr(12,nv);rtmp = rtmp(nin(5:(5+ncc)));
ktmp = ind_tnk(12,nv);ktmp = ktmp(nin(5):(nin(5)+2*ncc+1));
ri = [rtmp,rtmp];
ki = [ktmp];
xi = [ones(ncc+1,1);-ones(ncc+1,1)];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%phi, Volume expansion                          (A.93) and neigbours
%
%phi(k) = gammav(k).*V(k).*(1./rog(k) - 1./rol(k)) + ...
%         Wg(k-1).*(1./(rog(k)-1./rog(k-1))) + ...
%         Wl(k-1).*(1./(rol(k)-1./rol(k-1)))
%
%Placed in eq. nr 12 to reduce the system

ri = [ind_tnr(12,nv),ind_tnr(12,nv),ind_tnr(12,nv)];
ki = [ind_tnk(5),ones(1,thsize),ind_tnk(7,nv)];
[gammav_c,P_c,tl_c] = lin_volexp(gammav,P,tl,A,Hz);
xi=[gammav_c;P_c;tl_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Neighbours 
%Wg
[rtmp1,ktmp1]=ind_thneig(12,9,nv);
[j1,j2]=get_thneig;
rog = cor_rog(cor_tsat(P));
ctmp1 = (Wg(j2)>0).*(1./rog(j2) - 1./rog(j1));

%Wl
[rtmp2,ktmp2]=ind_thneig(12,4,nv);
rol = cor_rol(P,tl);
ctmp2 = (1./rol(j2) - 1./rol(j1));

ri = [rtmp1,rtmp2];
ki = [ktmp1,ktmp2];
xi = [ctmp1;ctmp2];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Channel equations				(A.85)

%Mi, Impulse momentum balance
[Wl_c,Wg_c,wg_c,P_c,alfa_c,tl_c]=lin_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,dc2corr,twophasekorr);
[rtmp,ktmp,ctmp] = kan_koeff(Wl_c,4,nv);

ri = [rtmp];ki = [ktmp];xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

[slask,ktmp,ctmp] = kan_koeff(Wg_c,9,nv);
ri = [rtmp];ki = [ktmp];xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

[slask,ktmp,ctmp] = kan_koeff(wg_c,10,nv);
ri = [rtmp];ki = [ktmp];xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

[slask,ktmp,ctmp] = kan_koeff(alfa_c,1,nv);
ri = [rtmp];ki = [ktmp];xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

[slask,ktmp,ctmp] = kan_koeff(tl_c,7,nv);
ri = [rtmp];ki = [ktmp];xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%System prssure channelwise
P_c = kan_sum(P_c);
rtmp = (2+nv*thsize):(ncc+2+nv*thsize);
ktmp = ones(1,ncc+1);
ri = [rtmp];ki = [ktmp];
xi =[P_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%Recirc pumps
ri = [rtmp];
ki = [(4+ncc+nv*thsize)*ones(1,ncc+1)];
xi =[ones(ncc+1,1)];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Flow distribution model			(A.87)

[alfa_c,S_c,P_c,jm_c] = lin_M(alfa,S,P,jm,tl,Hz,A);

alfa_c = alfa_c.*(alfa>0);
S_c = S_c.*(alfa>0);

[slask,ktmp,ctmp] = kan_koeff(alfa_c,1,nv);
%Find the rows for the core inlet
rtmp1 = ind_tnr(12,nv);tmp = rtmp1(ncc+1+nin(5:(5+ncc)));
rtmp = (tmp'*ones(1,length(ktmp)/(ncc+1)))';rtmp=rtmp(:)';
ri = [rtmp];ki = [ktmp];xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

[slask,ktmp,ctmp] = kan_koeff(S_c,11,nv);
ri = [rtmp];ki = [ktmp];xi =[ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

P_c = kan_sum(P_c);
ri = tmp;
ki = [ones(1,ncc+1)];
xi =[P_c];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

[slask,ktmp,ctmp] = kan_koeff(jm_c,12,nv);
ri = [rtmp];
ki = [ktmp];
xi = [ctmp];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%I1,I2,...
ri = [rtmp1(nin(5:(5+ncc))+ncc+1)];
ki = [1+thsize*nv+(1:(ncc+1))];
xi = [-ones(ncc+1,1)];
iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ktmp = ind_tnk(4,nv);


if ~pump(16)

  %Pump dynamics, pump places in the first nod of lower plenum 1

  [Wl_c,P_c,tl_c,n_c]=lin_DnDt(Wl,P,tl,nhcpump,pump,pk,ptype);
  ri = [(3+ncc+nv*thsize)*ones(1,3)];
  ki = [ktmp(nin(3)+1),1,(3+ncc+nv*thsize)];
  xi =[Wl_c;P_c;n_c];
  iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

  [Wl_c,P_c,tl_c,phcpump_c]=lin_npump(Wl,P,tl,phcpump,pump,pk);
  ri = [(4+ncc+nv*thsize)*ones(1,4)];
  ki = [ktmp(nin(3)+1),1,(4+ncc+nv*thsize),(3+ncc+nv*thsize)];
  xi =[Wl_c;P_c;phcpump_c;-1];
  iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

else

  % jet pumps

  [Wl_c,Wd_c,phcpump_c]=lin_DWdDt(Wl,P,tl,pump);
  ri = [(3+ncc+nv*thsize)*ones(1,3)];
  ki = [ktmp(nin(3)+1),(3+ncc+nv*thsize),(4+ncc+nv*thsize)];
  xi = [Wl_c;Wd_c;phcpump_c];
  iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;

  [Wd_c,P_c,tl_c]=lin_phcpump(pump(25),P,tl,pump(1),pump,pk);
  ri = [(4+ncc+nv*thsize)*ones(1,3)];
  ki = [(3+ncc+nv*thsize),1,(4+ncc+nv*thsize)];
  xi = [Wd_c;P_c;-1];
  iAhyd{count}=ri;jAhyd{count}=ki;xAhyd{count}=xi;count=count+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

j1 = find(get_realnodes);
k1 = ind_tnk(1,nv)';k1 = k1(j1);
k2 = ind_tnk(2,nv)';k2 = k2(j1);
k3 = [1+thsize*nv+(1:(ncc+1)),3+ncc+nv*thsize]';

iBhyd = [1;k1;k2;k3];
jBhyd = [1;k1;k2;k3];
xBhyd = [1;xBhyd(j1).*ones(length(k1),1);V(j1).*ones(length(k2),1);ones(length(k3),1)]; 
iAhyd = cat(2,iAhyd{:})';
jAhyd = cat(2,jAhyd{:})';
xAhyd = cat(1,xAhyd{:});

clear global DRog_DP DRof_DP Dtsat_DP DCpl_DP DRol_DP DRol_Dtl
