function wd=wr2wd(wr,z);
%
%wd=wr2wd(wr,z);
%
%Berknar den dmpade egenfrekvensen wd utgende frn
%resonansfrekvensen wr och dmpfaktorn z.

%Pr Lansker 20/9-91

wd=wr*sqrt((1-z^2)/(1-2*z^2));

