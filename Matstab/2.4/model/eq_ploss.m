function p=eq_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,dc2corr,korrtype)
%p=eq_ploss
%
%p=eq_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,dc2korr,korrtype)
% Calculates the total pressure dropp for all nodes
%
%vhk: Pressure drop coefficient (se eq_prestr)
%dh:  Hydraulic diameter
%Hz:  Node height
%Ekv. 4.4.104


wl = Wl./A./cor_rol(P,tl)./(1-alfa);
p = -eq_pacc(Wl,Wg,wl,wg,A) - eq_pelev(P,alfa,tl,Hz,dc2corr)...
    - eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,korrtype)...
    - eq_prestr(Wl,Wg,P,tl,A,vhk); 
