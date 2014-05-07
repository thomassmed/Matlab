function [y,J] = sysf_I(Wl,Wg,wg,P,alfa,tl,mg,romum,qprimw,tw,chflow,flowb,Eci,Wbyp,Wfw,fwpos,vhk,Dh,A,V,Hz,dc2corr,twophasekorr)
%[y,J] = sysf_I(Wl,Wg,wg,P,alfa,tl,mg,romum,qprimw,tw,chflow,flowb,Eci,Wbyp,Wfw,fwpos,vhk,Dh,A,V,Hz,dc2corr,twophasekorr);
%
%Gives the seach direction for the impulse momentum balance, J.
%y is the pressure loss over each channel

%@(#)   sysf_I.m 1.4   02/02/27     12:15:52

global geom
ncc=geom.ncc;

%Derivatives
ploss = eq_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,dc2corr,twophasekorr);
phcpump = eq_ppump(ploss);
y = kan_sum(ploss)+phcpump;
y(ncc+1)=[];

%Finite differences
if nargout>1,
h = 1+1e-1;

[alfa1,S1,Wl1,wl1,Wg1,wg1,jm1,gammav1,tl1]=sysalg0(mg,romum,qprimw,tw,chflow*h,flowb,Wbyp,Wfw,fwpos,P,A,V,Hz);
ploss1 = eq_ploss(Wl1,Wg1,wg1,P,alfa1,tl1,vhk,Dh,Hz,A,dc2corr,twophasekorr);

%Jacobian for each channel
k = get_corenodes;
dy = zeros(get_thsize,1);
dy(k) = ploss1(k)-ploss(k);
dy = kan_sum(dy);dy(ncc+1)=[];

%Jacobian search direction
J = dy./(chflow*h-chflow);
end




