function y = eq_kf(tfm,tcm,gca,drcax,rlcax,e1x,e2x,rfx,mod)
%
% y = eq_kf(tfout,e1x,e2x)
%
% INDATA : Br„nsletemperaturen mellan varje skikt samt tv… korrelationskonst.
%
% UTDATA : Volymetriska v„rme kapaciteten f÷r br„nslet. J/m3/C
%

% Ekvation 3.4.15

% Joakim Persson Forsmark 950227

global fuel

mm=fuel.mm;
mmc=fuel.mmc;

y=zeros(size(tfm,1),mm+1);

tfout = eq_tfout(tfm,mod);

for i = 2:mm+1
  y(:,i) = e1x./(1+e2x.*tfout(:,i));
end;

for it=1:3
  tfrf=rfx.*(1-sqrt(1-1/mm))./y(:,mm+1).*(tcm(:,1)-tfm(:,mm))...
     ./((1-sqrt(1-1/mm))./y(:,mm+1)+ 2./gca + drcax./mmc./rlcax)...
     + tfm(:,mm);

  y(:,mm+1)= e1x./(1+e2x.*tfrf);
end




if (mod==2)
  y(:,1) = y(:,2);
end


