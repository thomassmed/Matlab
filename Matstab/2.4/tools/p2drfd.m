function [dr,fd]=p2drfd(p,T);
%
%  [dr,fd]=p2drfd(p,T); L�mnar DR och Wd som resultat med en given
%  pol i z-plan eller i s-planet som inparameter. T �r samplingstiden.
%  Om T utel�mnas ber�knas dr och fd f�r poler i z-planet
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
