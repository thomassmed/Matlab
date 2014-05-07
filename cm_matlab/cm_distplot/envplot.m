%@(#)   envplot.m 1.2	 05/12/13     07:38:52
%
%function envplot(dname,minmax,simfile)
function envplot(dname,minmax,simfile)
if nargin<3, simfile='simfile.mat';end
load(simfile);
s=size(filenames);
for i=1:s(1)
  [dist,mminj,konrod,bb,hy,mz,ks]=readdist7(filenames(i,:),dname);
  e=readdist7(filenames(i,:),'efph');
  efph(i)=min(e);
  if size(dist,1)>1
    evstr=['dist=' minmax '(dist);'];
    eval(evstr);
  end
  evstr=['val(i)=' minmax '(dist);'];
  eval(evstr);
end
figure;
plot(efph,val)
%ytick=min(val):(max(val)-min(val))/7:max(val);
%set(gca,'ytick',ytick);
title([upper(minmax) ' ' upper(dname)])
xlabel('EFPH');
grid
