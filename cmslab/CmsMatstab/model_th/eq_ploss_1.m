function p=eq_ploss_1(alfa,tl,Wg,Wl,P,vhk,Dh,Hz,A,korrtype,amdt,bmdt)
%p=eq_ploss
%
%p=eq_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,korrtype)
% Calculates the total pressure dropp for all nodes
%
%vhk: Pressure drop coefficient (se eq_prestr)
%dh:  Hydraulic diameter
%Hz:  Node height
%Ekv. 4.4.104

if ~exist('korrtype','var'), korrtype='mnelson'; end

if ~exist('amdt','var'), 
    p = -eq_pelev(P,alfa,tl,Hz)...
    - eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,korrtype)...
    - eq_prestr(Wl,Wg,P,tl,A,vhk); 
else
    p = -eq_pelev(P,alfa,tl,Hz)...
    - eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,korrtype,amdt,bmdt)...
    - eq_prestr(Wl,Wg,P,tl,A,vhk);
end
