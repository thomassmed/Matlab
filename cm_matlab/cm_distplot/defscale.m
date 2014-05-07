%@(#)   defscale.m 1.2	 95/10/15     17:39:12
%
%function defscale(hfig,min,max)
function defscale(hfig,min,max)
figure(hfig);
distname=setprop(4);
setprop(7,min);
setprop(8,max);
setprop(9,'yes');
defa=setprop;
evstr=['save ' distname ' defa'];
eval(evstr);
goplot;
