function y = eq_tfout(tfm,mod)
%
% y = eq_tfout(tfm,mod)
%
% INDATA : Medeltemperaturen f÷r varje skikt i kutsen samt vilken modell.
%          Vill du anv„nda dig av bokens modell ange d… mod=0.
%	   Vill du anv„nda dig av RAMONA koden ange d… mod=1.
% 
% UTDATA : Temperaturen mellan varje radiellt skikt typ ekv. 6.3.20
%

% Ekvation rad 171 i tfdyn_sb.F

% Joakim Persson Forsmark 950227

global fuel

mm=fuel.mm;

if (mod==1)
  for i = 1:mm-1
    y(:,i+1) = tfm(:,i)+(i^0.5-(i-1)^0.5)*(tfm(:,i+1)-tfm(:,i) )./((i+1)^0.5-(i-1)^0.5);
  end;
  y(:,mm+1) = tfm(:,mm) + (tfm(:,mm)-y(:,mm));
end

% the following equation is 6.3.20 from Wulff
% however it seems to be wrong, because the one above is implemented in Ramona
% an when i did my own calculations i also got the one above ! philipp

if (mod==0)
  for j = 2:mm
    y(:,j) = ( (j+1)^0.5 - (j-1)^0.5 )*tfm(:,j-1)./( (j+1)^0.5 - (j-2)^0.5 ) + ( (j-1)^0.5 - (j-2)^0.5 )*tfm(:,j)/( (j+1)^0.5 - (j-2)^0.5 );
  end
end
