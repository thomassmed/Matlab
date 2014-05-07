function [distr,disti]=plot_contribution(save_file);

% [distr,disti]=plot_contribution(save_file);
%
% plots the contribution of the fuel assemblies to the eigenvalue

load(save_file,'msopt','termo')

global msopt termo

distfile=msopt.DistFile;

dist=contrib2dist(save_file,0,0);
dist=mstab2dist(sum(dist),distfile);
distr=real(dist);
disti=imag(dist);
distplot(distfile,'lambda',[],distr);
