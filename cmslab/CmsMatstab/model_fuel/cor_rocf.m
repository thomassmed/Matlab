function y = cor_rocf(tfm,rocfx)
%
% y = eq_rocf(tfm,rocfx)
%
% INDATA : Medeltemperaturen f÷r varje skikt i kutsen samt konduktivitetsvar.
%
% UTDATA : konduktiviteten f÷r varje del av kutsen
%

% documented in the Ramona user manuel section 3.2 equation 16

% philipp haenggi, leibstadt 17.11.95

y = zeros(size(tfm));


y = rocfx(1)+rocfx(2).*tfm+rocfx(3).*tfm.^2+...
             rocfx(4).*tfm.^2.*tfm+rocfx(5).*(tfm.^2).^2;
 
  
