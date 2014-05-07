function reg=region(T,P)
%---------------------------------------------------------------------
% region(T,P)	Funktion för att bestämma region som används vid 
%		beräkning av entalpi för underkylt vatten (h_v).
%
%		Temperatur och tryck ges i Kelvin resp. Pa
%
%		Stefan Ahlinder/FTTP - 19950710
%---------------------------------------------------------------------
PKRIT=221.2;
TKRIT=647.3;
TABS=273.15;
TETA1=9.626911787e-1;
TETA2=1.333462073;
L0=1.574373327e1;
L1=-3.417061978e1;
L2=1.931380707e1;
p=P/1e5;
beta=p/PKRIT;
teta=T/TKRIT;
betal=L0+L1*teta+L2*teta.^2;
pk=t2p(T)/1e5;
betak=pk/PKRIT;
if teta<=TETA1
	if beta<betak
		reg=2;
	elseif beta>betak
		reg=1;
	else	
		reg=6;
	end
elseif teta<1
	if beta<=betal
		reg=2;
	elseif beta<betak
		reg=3;
	elseif beta>betak
		reg=4;
	else 
		reg=5;
	end
elseif teta<TETA2
	if beta<=betal
		reg=2;
	else
		reg=3;
	end
else
	reg=2;
end
return
