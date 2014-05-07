function [tw,iboil] =eq_tw0(P,qkw,htc,pbm,phm,tlb,tl,Wl,Wg,Dh,A)

% tw = eq_tw0(P,qprimw,htc,pbm,phm,tlb,tl,Wl,Wg,Dh,A)
%
% calculates steady state wall-temperature for the boiling region
%
%
% [tw,Iboil] = eq_tw0(P,power,qtherm,delta,htc,pbm,phm,dzz,tlp,tl,Wl,Wg,Dh,A);
% 
% calculates tw, and Iboil for the whole core
% 

% Philipp Haenggi, Leibstadt 6.8.96
% 4.4.5 solved for tw
% oppotsite to ramona, the bypass-term is included.
% to switch of the byp-term, set htc=0;

%TODO: work with Gerardo on this!

global geom

ntot=geom.ntot;
kmax=geom.kmax;
kan=geom.kan;

tsat=cor_tsat(P);
tw=zeros(size(qkw));
tw_b=tw;
tw_nb=tw;
iboil=tw;



%hc=1.266*(exp(P*1.61e-7));
hc=2.555*(exp(P*6.45e-7));                % NUCLEATE BOILING  haac=hc*(tw-tsat)

%qbyp=htc*pbm.*(tsat-tlb);
qbyp=0;
tw=tsat+sqrt(sqrt((qkw+qbyp)./phm./hc));

if nargin > 6
  qbyp=htc*pbm.*(tsat-tlb);
%  tw_b=tsat+sqrt(sqrt((qkw+qbyp)./phm./hc));
  tw_b=tsat+sqrt(sqrt(qkw./phm./hc));
  cpl = cor_cpl(tsat);
  kl = cor_kl(tsat);
  myl = cor_myl(tsat); 
  Nre = eq_Nre(Wl,Wg,Dh,P,A);
  Npr = myl.*cpl./kl;
  hc=0.023*kl./Dh.*(Nre.^0.8).*(Npr.^0.4);
  tw_nb=tl+(qkw+(tl-tlb)*htc.*pbm)./phm./hc;
  tw_nb=tl+qkw./phm./hc;
  tw=min(tw_b,tw_nb);
  i=find(tw~=tw_nb);
  iboil(i)=ones(size(i));
%  akb=1.266*exp(1.61E-7.*P);         %constants of Jens correlation
%  aknb=eq_rknb(Wl./A,Dh);
%  i=find(tw>tsat);
%  qboil(i)=(akb(i).*(tw(i)-tsat(i))).^4;
%  i=find(tw>tl);
%  qnoboi(i)=aknb(i).*(tw(i)-tl(i));
%  i=find(qboil>qnoboi);
%  iboil(i)=ones(length(i),1);
end



