function [S_c,jm_c,alfa_c]=lin_vg(S,jm,alfa,wg)
%lin_vg
%
%[S_c,jm_c,alfa_c]=lin_vg(S,jm,alfa,wg)
%Linjäriserar eq_vg

%@(#)   lin_vg.m 2.3   02/02/27     12:10:03

global termo

c15=termo.css(:,4);

if 0
  [S_c,jm_c,alfa_c] = fin_diff('eq_vg',S,jm,alfa);
else
  x=1+alfa.*(S-1);
  S_c=(jm-wg.*alfa)./x;
  jm_c=S./x;
  alfa_c=(-c15-wg.*(S-1))./x;
end


S_c(1) = 0;
alfa_c(1) = 0;
c = get_realnodes.*(alfa>0);
S_c = S_c.*c;
jm_c = jm_c.*c;
alfa_c =alfa_c.*c;
