function y = eq_slip(alfa,P,variabel)
%
% y = eq_slip(alfa,P,variabel)
% 
% INDATA : Void,systemtryck samt vilken sorts korrelation det är.
%         
% Korrelationer.
%        'bmalnes'   :   Bankoff-Malnes
%        'bjones'    :   Bankoff-Jones
%
% UTDATA : Slip.
%
% Ekvation 4.4.65-4.4.66

%@(#)   eq_slip.m 2.2   02/02/27     12:06:41

global termo

c14 = termo.css(3);
maxss = termo.css(1);
cutoff = termo.css(2);

%maxss=1.9*ones(size(alfa));

% Bankoff-Malnes 
if strcmp(variabel,'bmalnes')
  y = (1 + cutoff - c14 + (alfa - c14 + cutoff).*(1 - c14)./cutoff)./cutoff;
  j = find(alfa<=(c14-cutoff));
  y(j) = (1-alfa(j))./(c14-alfa(j));
%  y = min([y maxss]')';
else
% Bankoff-Jones
  if strcmp(variabel,'bjones')
    a = 0.71 + P*1.3119e-8;
    b = 3.4483 - P.*(2.7194e-8 - P*1.230e-14);
    f = a + (1 - a).*alfa.^b;
    y = (1-alfa)./(f-alfa);
  else
    disp(' ');
    error(['Unknown correlation: ',variabel]);
    return
  end
end

