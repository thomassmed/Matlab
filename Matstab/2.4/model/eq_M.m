function y = eq_M(alfa,S,P,jm,tl,Hz,A,calctype)
% eq_M
%
% y = eq_M(alfa,S,P,jm,tl,Hz,A,calctype)
% Calculates momentum balance for the nodes (calctype==1)
% If calctypes==0 the flow inertia is calculated
% If calctype==1 Gm.*Hz is calculated 

% Eq. 4.4.120

%@(#)   eq_M.m 2.2   02/02/27     11:48:47


global geom termo
nsep=geom.nsep;
rleff0=termo.rleff0;

Rol = cor_rol(P,tl);
Rog = cor_rog(cor_tsat(P));

wg = eq_vg(S,jm,alfa);
wl = eq_vl(S,jm,alfa);

Gm = alfa.*Rog.*wg + (1 - alfa).*Rol.*wl;                        % eq. 4.4.97


% This is done due to problems with finite differences since the 
% outlet node in the riser affects the other riser nodes

if calctype==-1
  y = Gm.*Hz;
else
  %Steam separators
  j = get_risernodes;j(1) = [];jo = j(length(j));
  Gg = Rog(jo)*wg(jo)*alfa(jo);
  x = Gg/(Gm(jo));
  hrsr = sum(Hz(j)); %Height of separator
  l = A(jo)/hrsr/nsep*(1-x)*(rleff0 + 118*(11.5 + 55.6*x)*x);    % eq. 4.4.156
  Lrsr = ones(get_thsize,1);
  Lrsr(j) = l*ones(length(j),1); 
  if calctype==0
    y = Lrsr;
  elseif calctype==1,
    y = Gm.*Hz.*Lrsr;
  end
end
