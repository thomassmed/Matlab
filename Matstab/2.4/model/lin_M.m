function [alfa_c,S_c,P_c,jm_c,tl_c] = lin_M(alfa,S,P,jm,tl,Hz,A)
%[alfa_c,S_c,P_c,jm_c,tl_c] = lin_M(alfa,S,P,jm,tl,Hz,A)
%
% Linearization of momentum equation, eq_M


% y=Gm.*Hz.*Lrsr   ,fin_diff does not work because off the structure of Lrsr
% following relation is used: y'= (Gm.*Hz)'.*Lrsr+Gm.*Hz.*L'

[alfa_c,S_c,P_c,jm_c,tl_c] = fin_diff('eq_M',alfa,S,P,jm,tl,Hz,A,-1);
Lrsr = eq_M(alfa,S,P,jm,tl,Hz,A,0);
alfa_c = alfa_c.*Lrsr;
S_c = S_c.*Lrsr;
P_c = P_c.*Lrsr;
jm_c = jm_c.*Lrsr;
tl_c = tl_c.*Lrsr;

%Korrigera för riser-outlet
[alfa_l,S_l,P_l,jm_l,tl_l] = fin_diff('eq_M',alfa,S,P,jm,tl,Hz,A,0);
Gmhz = eq_M(alfa,S,P,jm,tl,Hz,A,-1);

%L(xk)' is zero, but L(xout)' apears in all risernodes, ergo the sum
j1 = get_risernodes;j1(1)=[];j2 = j1(length(j1));
alfa_c(j2) = alfa_c(j2)+sum(Gmhz(j1)*alfa_l(j2));
S_c(j2) = S_c(j2)+sum(Gmhz(j1)*S_l(j2));
P_c(j2) = P_c(j2)+sum(Gmhz(j1)*P_l(j2));
jm_c(j2) = jm_c(j2)+sum(Gmhz(j1)*jm_l(j2));
tl_c(j2) = tl_c(j2)+sum(Gmhz(j1)*tl_l(j2));






