function [dr,fd]=p2drfd(p,T);
%
%  [dr,fd]=p2drfd(p,T); Lämnar DR och Wd som resultat med en given
%  pol i z-plan eller i s-planet som inparameter. T är samplingstiden.
%  Om T utelämnas beräknas dr och fd för poler i z-planet
%

% Pr Lansker  5/4-91

if nargin == 2,
  p=log(p)/T;
  [dr,fd]=p2drfd(p);
else
  wd=imag(p);
  fd=wd/2/pi;
  w0=abs(p);
  z=-real(p)./w0;
  dr=z2dr(z);
end
