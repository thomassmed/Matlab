function press=t2p(T)
%---------------------------------------------------------------
% function press=t2p(T)
% Funktion för beräkning av mättnadstryck (Pa) vid
% given temperatur (Kelvin)
%
% Giltighetsområde: 0.000611 =< p =< 22.1 MPa
%			273.16 =< T =< 647.3 K
%
% Stefan Ahlinder/FTTP 1995-01-05
%
% Ref:  Steam and Gas Tables with Computer Equations
%       Thomas F., Irvine, Jr.
%       Peter E. Liley
%       Academic Press Inc., 1984
%
%---------------------------------------------------------------

%          K O N S T A N T E R  
%
if (T<273.16)|(T>647.3)
	disp('Indata utanför giltigt område i t2p !')
end
if T<600
	A=0.426776e2;
	B=-0.389270e4;
	C=-0.948654e1;
else
	A=-0.387592e3;
	B=-0.125875e5;
	C=-0.152578e2;
end
%
%          B E R Ä K N I N G
%
press=1e6*exp(-C+(T-A).\B);
return
