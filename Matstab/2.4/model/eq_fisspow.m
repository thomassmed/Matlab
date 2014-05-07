function pow=eq_fisspow(fa1,fa2,sigf1,sigf2,hx,hz)
% pow=eq_fisspow(fa1,fa2,sigf1,sigf2,hx,hz)
% Due to scaling, the typical call would be:
% pow=eq_fisspow(fa1./rho,fa2./rho,usig1./ny1,usig2./ny2,hx,hz);
% 
K1=3.2041e-11; % Joules per fission, see Wulff et. al p 55 200 MeV/fission
pow=K1*(fa1.*sigf1+fa2.*sigf2)*hx^2*hz;
%@(#)   eq_fisspow.m 1.3   97/09/22     10:29:28
