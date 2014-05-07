function [e0,xi]=dist2en(power)
%[e0,xi] = dist2en(power);
%
%en is the starting guess on neutronic eigenvector
%xi is the number of the channel that has the highest mean power

%@(#)   dist2en.m 1.8   02/02/27     21:38:24

startvinkel=-[0 0 0 0 1 2 5 8 11 15 19 23 27 31 35 39 42 45 48 50 52 54 55 56 56 56 56 56 56]';

e0=power;
[x,xi] = max(mean(e0));

for i=1:size(e0,1)
  e0(i,:)=-e0(i,:)*exp(pi*1j*startvinkel(i)/180);
end

