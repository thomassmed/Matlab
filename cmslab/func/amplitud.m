function [amax,h1,h2]=amplitud(x,f,Ts)
% [amax,h1,h2]=amplitud(x,f,Ts)
% x - indatavektor
% f - sökt frekvens
% Ts - samplingstid
%
% amax - max amplitud
% h1 = 1 om amplitud >= +-8 i 10 sekunder
% h2 = 1 om amplitud >= +-15 i 10 sekunder
x=x-mean(x);
a=mxAmplitud(f,Ts,x);
amax=max(a);
h1=250<=length(find(a>=8));
h2=250<=length(find(a>=15));
