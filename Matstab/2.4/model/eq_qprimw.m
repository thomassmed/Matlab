function y = eq_qprimw(P,Wl,tw,tl,A,phm,Dh,Htc,Iboil)
%
% y = eq_qprimw(P,Wl,tw,tl,A,phm,Dh,Htc,Iboil)
%
% INDATA : systemtrycket,vattenmassfl�det,v�ggtemperaturen,vattentemperaturen,
%          arean,heated perimeter,hydraulisk diameter,v�rmegenomg�ngstal
%          f�r bypass,kokningsvektor och heated perimeter f�r bypass,
%
% UTDATA : Endimensionella v�rmeledningsfl�det.
%
% Ekvation 4.4.5

%@(#)   eq_qprimw.m 2.1   96/08/21     07:56:49

% q'w = (phm*hc)*(tw - tfl) 

hc = eq_haac(P,tw,Wl,A,Iboil,Dh);
tsat = cor_tsat(P);
j = find(Iboil);
tfl = tl;
tfl(j) = tsat(j);

ch = get_chnodes;
y=zeros(get_thsize,1);
y(ch) = phm(ch).*hc(ch).*(tw(ch)-tfl(ch));
y = y.*get_realnodes;


