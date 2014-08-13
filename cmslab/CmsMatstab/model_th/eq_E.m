function y = eq_E(Wl,Wg,tl,P,Tsat0)
%eq_E
% 
%y = eq_E(alfa,romum,Wl,Wg,tl,P,Tsat0,V,A)
%
%Internal energy d(romum)/dt in [Ws/m3/s].
%
%  d(romum(k))
% ------------V(k) = hg(k-1)*Wg(k-1)+hl(k-1)*Wl(k-1) -
%     dt
%                  - hg(k)*Wg(k) - hl(k)*Wl(k) + (q'w(k) + A*(1-alfa)*q''')*Hz 
%
%                  + A*Jm(k-1)*P - A*Jm(k)*P This is wrong (Pak 2014-06-24
%                  on the phone)
%
%                    (q'w and q''' term added in add_alfa_c and A_hydro) 
%
% hg = cor_hg(P,tl,Tsat0);
% hl = (romum(k)*V(k) - mg(k)*hg(k))/(V(k)-mg(k)/rog(k))/rol(k)
% hl =cpl (Tl-tsat), same thing but simpler

% Ekvation 4.4.79, revised from the code

%@(#)   eq_E.m 2.1   96/08/21     07:56:31

tsat = cor_tsat(P);

hg = cor_hg(P,tl,Tsat0);

hl = cor_cpl(tsat)*(tl-tsat);
%jm = eq_jm(Wl,Wg,P,tl,A);

y = hg.*Wg + hl.*Wl;% + A.*jm.*P;

