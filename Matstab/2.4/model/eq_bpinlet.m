function p=eq_bpinlet(k)
%p=eq_bpinlet
%
%k=eq_bpinlet(k)
% Calculates the total pressure drop over bypass channel
% using pressure drop coefficient k for the inlet

global geom steady termo 

nin=geom.nin;
ncc=geom.ncc;
A=geom.A;
Hz=geom.Hz;
Dh=geom.Dh;

Wl=steady.Wl;
Wg=steady.Wg;
wg=steady.wg;
alfa=steady.alfa;
tl=steady.tl;
vhk=steady.vhk;

P=termo.P;
solvbpkorr=termo.twophasekorr;
dc2corr=termo.dc2corr;

vhk(nin(5+ncc)+ncc+1) = k;

p = eq_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,dc2corr,solvbpkorr);

j = get_kanj(ncc+1);
p = eq_ppump(p) + sum(p(j));
