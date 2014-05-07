function y=eq_phi2(Wg,Wl,P,tl,A,korrtype)
%eq_phi2
%
%y=eq_phi2(Wg,Wl,P,tl,A,korrtype)
%
%Tvåfaskorrelationer.
%korrtyp='becker'  :  Becker, Hernberg och Bode [1962]
%        'mnelson' :  Martinelli-Nelson
%        'rolstad' :  Rolstad

%@(#)   eq_phi2.m 2.2   96/12/05     15:03:23

Rol = cor_rol(P,tl);
Rog = cor_rog(cor_tsat(P));
Wtot = (Wg + Wl);
ii = find(Wtot<=0);
Wtot(ii) = zeros(length(ii),1);
x = Wg./Wtot;
Gm = Wtot./A;

%Becker
if strcmp(korrtype,'becker'),
  y = 1 + 1.49e8*(x./P).^0.96;

%Martinelli-Nelson
elseif strcmp(korrtype,'mnelson'),

  ii = find((Gm<950)&(Gm>0));
  jj = find(Gm>=950);
  kk = find(Gm<=0);
  if ~isempty(ii),
    c(ii) = 1.36 + 7.252e-8*P(ii) + 7.3733e-5*Gm(ii) - 7.6357e-11*P(ii).*Gm(ii); 
  end 
  if ~isempty(jj),
    c(jj) = 1.26 - 5.802e-8*P(jj) + 1.6139e2./Gm(jj) + 5.5079e-5*P(jj)./Gm(jj);
  end
  if ~isempty(kk),
    c(kk)=zeros(length(kk),1);
  end
  c=c(:);

  y = 1.2*c.*(Rol./Rog-1).*(x.^0.824) + 1;

%Rolstad
elseif strcmp(korrtype,'rolstad'),

 y = 1 + 3e6./(1000+Gm).*98100./P.*(x.^0.7);

else

  error('Ingen sådan korrelation!')

end
