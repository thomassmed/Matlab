function dr=z2dr(z);
%
% dr=z2dr(z);
%
% Lmnar DR som resultat. z definieras ur ekvationen:
%
%              2
%            w0
% G = ----------------- 
%      2              2
%     S  + 2zw0 S + w0

% Par Lansaker 15/4-91

dr=exp(-z.*2*pi./sqrt(1-z.^2));

