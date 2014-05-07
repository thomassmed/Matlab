function [y,ploss]=lin_dP_core(alfa,tl,Wg,Wl,P,A,hz,flowb,vhk,Dh,twophasekorr)
Hz=ones(size(alfa))*hz/100;
if ~exist('twophasekorr','var'), twophasekorr='mnelson'; end
Wl(1,:)=Wl(1,:)+flowb;
ploss = - eq_pelev(P,alfa,tl,Hz)...
    - eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,twophasekorr)...
    - eq_prestr(Wl,Wg,P,tl,A,vhk); 
dP=-sum(ploss);
y=dP;
ploss=-ploss;