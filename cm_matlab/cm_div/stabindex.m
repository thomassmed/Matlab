%@(#)   stabindex.m 1.3	 05/12/08     13:21:50
%
%function mnedupp=stabindex(distfil,noplot);
% Plots upper (node 18-24) and lower (node 2-8) power densities 
% Input: distfil
%        noplot if noplot is given any value, no plots will be generated
% Output beside the plots:  mnedupp, a 3 by 1 vector
% containing: mnedupp(1) - average power node 2-8
%             mnedupp(2) - (average power node 2-8) times av(18-24)
%             mnedupp(3) - average power (node 18-24 times 18-24)
function mnedupp=stabindex(distfil);
power=readdist7(distfil,'POWER');
ned=mean(power(2:8,:));
upp=mean(power(18:24,:));
if nargin<2
  distplot(distfil,'ned',upright,ned);
  text(1.5,4,'Lower','color','black');
  distplot(distfil,'upp',upleft,upp);
  text(1.5,4,'Upper','color','black');
  p=[19   126   350   200];
  ponoff(p);
end
mned=mean(ned);
mnedupp(1)=mned;
mnedupp(2,1)=mned*mean(upp);
mnedupp(3,1)=mean(upp.*ned);
end
