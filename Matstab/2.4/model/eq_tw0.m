function [tw,iboil] =eq_tw0(P,power,qtherm,delta,htc,pbm,phm,dzz,tlp,tl,Wl,Wg,Dh,A)

% tw = eq_tw0(P,power,qtherm,delta,htc,pbm,phm,dzz,tlp);
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

global geom termo 

ntot=geom.ntot;
kmax=geom.kmax;
kan=geom.kan;
ihydr=termo.ihydr;

tsat=cor_tsat(P);
tw=zeros(get_thsize,1);
tw_b=zeros(get_thsize,1);
tw_nb=zeros(get_thsize,1);
iboil=zeros(get_thsize,1);
qkw=power*qtherm*(1-delta)/ntot/(dzz/100);
qkw=set_ntohvec(qkw,ihydr);

tlb=tlp:(tsat(1)-tlp)/kmax:tsat(1);
tlb(1)=[];
tlb=tlb'*ones(1,kan);
tlb=tlb(:);
tlb=set_ntohvec(tlb,ihydr);

qbyp=htc*pbm.*(tsat-tlb);
hc=2.555*(exp(P*6.45e-7));                % NUCLEATE BOILING  haac=hc*(tw-tsat)

tmp=find(qkw);
tw(tmp)=tsat(tmp)+sqrt(sqrt((qkw(tmp)+qbyp(tmp))./phm(tmp)./hc(tmp)));

if nargin > 9
  tlb=tl(get_bnodes);
  tlb(1)=[];
  tlb=tlb*ones(1,kan);
  tlb=tlb(:);
  tlb=set_ntohvec(tlb,ihydr);
  qbyp=htc*pbm.*(tsat-tlb);
  tw_b(tmp)=tsat(tmp)+sqrt(sqrt((qkw(tmp)+qbyp(tmp))./phm(tmp)./hc(tmp)));
  cpl = cor_cpl(tsat);
  kl = cor_kl(tsat);
  myl = cor_myl(tsat); 
  Nre = eq_Nre(Wl,Wg,Dh,P,A);
  Npr = myl.*cpl./kl;
  hc=0.023*kl./Dh.*(Nre.^0.8).*(Npr.^0.4);
  tw_nb(tmp)=tl(tmp)+(qkw(tmp)+(tl(tmp)-tlb(tmp))*htc.*pbm(tmp))./phm(tmp)./hc(tmp);
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



