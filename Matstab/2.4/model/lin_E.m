function [alfa_c,romum_c,Wl_c,qprimw_c,Wg_c,tl_c,P_c] = lin_E(alfa,romum,Wl,Wg,tl,P,Tsat0,V,A,Htc,pbm,Hz);
%eq_E
% 
%[alfa_c,romum_c,Wl_c,qprimw_c,Wg_c,tl_c,P_c] = lin_E(alfa,romum,Wl,Wg,tl,P,Tsat0,V,A,Htc,pbm,Hz);
%Linearisation of the internal energy E in [Ws/m3].
%
%  d(romum(k))
% ------------V(k) = hg(k-1)*Wg(k-1)+hl(k-1)*Wl(k-1) -
%      dt
%                  - hg(k)*Wg(k) - hl(k)*Wl(k) + (q'w(k) + A*(1-alfa)*q''')*Hz - pbm*Htc*Hz*(tl-tlbyp)
%
%                   + A*Jm(k-1)*P - A*Jm(k)*P 
%
%                    (and q''' term added in and add_alfa_c) 
%                   
%                     tlbyp neglected
%
% hg = cor_hg(P,tl,Tsat0);
% hl = (romum(k)*V(k) - mg(k)*hg(k))/(V(k)-mg(k)/rog(k))/rol(k)
% Ekvation 4.4.79, revised from the code

%@(#)   lin_E.m 2.3   02/02/27     12:06:02

global geom

ncc=geom.ncc;

[alfa_c,romum_c,Wl_c,Wg_c,tl_c,P_c] = fin_diff('eq_E',alfa,romum,Wl,Wg,tl,P,Tsat0,V,A);

c1 = ones(get_thsize,1);c1(1)=0;
c2 = (alfa>0);
j1 = get_chnodes;
c3 = c1;
c3(j1) = c3(j1);

alfa_c = alfa_c.*c1.*c2;
romum_c = romum_c.*c1;
Wl_c = Wl_c.*c1;
Wg_c = Wg_c.*c1.*c2;
tl_c = tl_c.*c1 - pbm.*Htc.*Hz;
P_c = P_c.*c1;

j1(1:ncc)=[];
qprimw_c = zeros(get_thsize,1);
qprimw_c(j1) = V(j1)./A(j1);


