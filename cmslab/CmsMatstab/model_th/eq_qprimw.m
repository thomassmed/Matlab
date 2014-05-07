function y = eq_qprimw(tl,Wl,tw,P,A,phm,pbm,Dh,Iboil,htc,tlp)
%
% qprimw = eq_qprimw(tl,Wl,tw,P,A,phm,pbm,Dh,Iboil,tsat,htc,tlp)
%
% This function is used for FD in linearization
% Equation 4.4.5

% q'w = (phm*hc)*(tw - tl) - htc*pbm*(tl-tl_bypass) Forced convection
% q'w= hc*phm*(tw-tsat)^4 Nucleate boiling

tsat=cor_tsat(P(1));
cpl = cor_cpl(tsat);   % Forced convection
kl = cor_kl(tsat);
myl = cor_myl(tsat); 
Nre=Wl.*Dh./A/myl;
Npr = myl.*cpl./kl;
hc_nb=0.023*kl./Dh.*(Nre.^0.8).*(Npr.^0.4);
qp_nb=(1-Iboil).*phm.*hc_nb.*(tw-tl);%-htc*pbm.*(tl-tlp);

hc=2.555*(exp(P*6.45e-7));                % NUCLEATE BOILING
qp_b=hc.*Iboil.*phm.*(tw-tsat).^4;

y=qp_nb+qp_b;
