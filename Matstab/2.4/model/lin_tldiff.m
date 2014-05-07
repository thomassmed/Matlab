function [alfa_c,P_c,tl_c,romum_c] = lin_tldiff(alfa,P,tl,romum,tsat0)
%[alfa_c,P_c,tl_c,romum_c] = lin_tldiff(alfa,P,tl,romum,tsat0)
%
% Linearization of eq_tldiff

global geom
nin=geom.nin;

[alfa_c,P_c,tl_c]=fin_diff('eq_tldiff',alfa,P,tl,romum,tsat0);
% romum is perturbed with addition insted of relative perturbation 
romum_c = eq_tldiff(alfa,P,tl,romum+1,tsat0)-eq_tldiff(alfa,P,tl,romum,tsat0);

c = get_realnodes;
c(1) = 0;

alfa_c = alfa_c.*c.*(alfa>0);
P_c = P_c.*c;
romum_c = romum_c.*c;
tl_c = tl_c.*c;
tl_c(nin) = ones(length(nin),1);
