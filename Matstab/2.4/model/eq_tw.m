function y = eq_tw(tw,tc,tl,P,Wl,A,Iboil,Dh);

global termo fuel

mmc	= fuel.mmc;
ihydr 	= termo.ihydr;

tcN	= set_th2ne(tw,ihydr);

%-----------------------------------
% Har ändrat beräkning av kcN
%	Emma Lundgren 050930
%-----------------------------------

kcN 	= cor_pinmprop(tcN,6);

DRca 	= set_ntohvec(fuel.drca,termo.ihydr);
drc	= DRca/mmc;
kcN 	= set_ntohvec(kcN,termo.ihydr);
j 	= find(kcN>0);
hc 	= eq_haac(P,tw,Wl,A,Iboil,Dh);
i 	= find(Iboil);
tfl 	= tl;
tfl(i) 	= cor_tsat(P(i)); 

y 	= zeros(get_thsize,1);

y(j) 	= -tw(j) + tfl(j)  - (tfl(j)-tc(j))./(0.5*drc(j).*hc(j)./kcN(j)+1);

y 	= y.*get_realnodes;


