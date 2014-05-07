%@(#)   sim_info.m 1.4	 05/12/13     08:54:58
%
%function siminfo(simfile)
function siminfo(simfile)
if nargin==0, simfile='sim/simfile.mat';end
load(simfile);
s=size(filenames);
for i=1:s(1)
  [dist,mminj,konrod,bb,hy,mz,ks]=readdist7(filenames(i,:),'efph');
  efph(i)=min(dist);
  keff(i)=bb(96);
  frad(i)=bb(104);
  ppf(i)=bb(105);
end
figure;
subplot(3,1,1);
plot(efph,keff);
title('keff');
grid;
subplot(3,1,2);
plot(efph,frad);
title('F-rad');
grid;
subplot(3,1,3);
plot(efph,ppf);
title('PPF');
grid;
