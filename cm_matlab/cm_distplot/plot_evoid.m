function plot_evoid(ichoice)
if nargin<1, ichoice=1; end
distfil=setprop(5);
i=findstr('.',distfil);
if isempty(i),
 f_matstab=[remblank(distfil),'.mat'];
else
 f_matstab=[distfil(1:i-1),'.mat'];
end

[efi1,evoid,efi2]=f_matstab2dist(f_matstab);
load(f_matstab,'stab');
[dr,fd]=p2drfd(stab.lam);
setprop(9,'auto');
if ichoice==1,
  setprop(4,'MATLAB:abs(evoid)');
  ccplot(abs(evoid));
elseif ichoice==2,
  setprop(4,'MATLAB:abs(efi1)');
  ccplot(abs(efi1));
else
  setprop(4,'MATLAB:abs(efi2)');
  ccplot(abs(efi2));
end
hh=text(1,29.9,sprintf('DR= %4.2f  Fr= %5.2f Hz',dr,fd));
set(hh,'fontsize',13);
