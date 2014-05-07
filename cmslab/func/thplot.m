function thplot(th,sd)
% thplot(th, sd)
% plottar zero-pol och dämpkvot för en th-modell i en subplot
% standardavvikelse sd, default=1

% Gustav van den Bussche 1998-09-25

if nargin<2 sd=1; end
clf

subplot(121)
zpplot(th2zp(th),sd)
zgrid

subplot(122)
[dk,fd,sigma]=th2dkfd(th,sd);
grid on