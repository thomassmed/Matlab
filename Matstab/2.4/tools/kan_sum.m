function y = kan_sum(koeff)
%kan_sum
%
%y = kan_sum(koeff)
%Summering av koefficienter kanalvist
%koeff är resultat från 'lin_' -function

%@(#)   kan_sum.m 2.2   02/02/27     12:10:41

k = get_kan;
sk = size(k);
k = reshape(koeff(k),sk(1),sk(2));
y=sum(k)';
