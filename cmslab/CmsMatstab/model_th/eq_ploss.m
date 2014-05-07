function p=eq_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,korrtype,amdt,bmdt)
%p=eq_ploss
%
%p=eq_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,korrtype)
% Calculates the total pressure dropp for all nodes
%
%vhk: Pressure drop coefficient (se eq_prestr)
%dh:  Hydraulic diameter
%Hz:  Node height
%Ekv. 4.4.104


wl = Wl./A./cor_rol(P,tl)./(1-alfa);

amdflag=true;
if ~exist('amdt','var'), amdflag=false;end
if isempty(amdt), amdflag=false;end

if amdflag,
    p = -eq_pacc(Wl,Wg,wl,wg,A) - eq_pelev(P,alfa,tl,Hz)...
    - eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,korrtype,amdt,bmdt)...
    - eq_prestr(Wl,Wg,P,tl,A,vhk);
else
    p = -eq_pacc(Wl,Wg,wl,wg,A) - eq_pelev(P,alfa,tl,Hz)...
    - eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,korrtype)...
    - eq_prestr(Wl,Wg,P,tl,A,vhk); 
end