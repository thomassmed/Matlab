%@(#)   pltip.m 1.2	 94/08/12     12:10:42
%
%function pltip(direc,dname)
%plots distr. dname for all tip-??????.dat on directory direc
%default for dname is 'POWER'
%default for direc is current directory
function pltip(direc,dname)
if nargin<2, dname='POWER';end
if nargin<1, [s,direc]=unix('pwd');direc=direc(1:length(direc)-1);end
distfil=findtip(direc);
[id,jd]=size(distfil);
p=[528   379   620   490];
cfig=distplot(distfil(1,:),dname,p);
p=[19   126   350   200];
ponoff(p);
p=[12   367   485   504];
figure(cfig);
fig=setaxplot(p);
axplot(fig);
setprop(20,'yes');
pause
for i=2:id
  figure(cfig);
  setprop(5,distfil(i,:));
  ccplot
  figure(cfig);
  pause
end
