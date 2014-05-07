function x=polriser(x0,Wl,Wg,rol,rog,A);
%x=polriser(x0,Wl,Wg,rol,rog,A);
%Calculates the void in the riser
%
%X0 = newtons('polriser',0.75,1e-3,Wl,Wg,rol,rog,A);

%@(#)   polriser.m 1.3   02/02/27     12:15:18

global geom termo

c15 = termo.css(:,4);
maxss = termo.css(:,1);

k = geom.nin(6+geom.ncc);
x = maxss(k)*Wl(k)/(A(k)*(1-x0)*rol(k)) - Wg(k)/(A(k)*x0*rog(k)) + c15(k);
