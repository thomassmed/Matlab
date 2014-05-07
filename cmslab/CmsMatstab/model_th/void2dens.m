function dens=void2dens(void,P,tl)
% dens=void2dens(void,P,tl)

rog = cor_rog(cor_tsat(P));
rol=cor_rol(P,tl);

dens=(1-void).*rol+void.*rog;
