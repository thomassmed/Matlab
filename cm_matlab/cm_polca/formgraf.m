%@(#)   formgraf.m 1.2	 05/12/08     10:31:35
%
function formgraf
load('sim/simfile');
sf=size(filenames);sb=size(bocfile);
if sf(2)>sb(2),bocfile=[bocfile setstr(32*ones(1,sf(2)-sb(2)))];end
if sb(2)>sf(2),filenames=[filenames setstr(32*ones(sf(1),sb(2)-sf(2)))];end
filenames=[bocfile;filenames];
for i=1:size(filenames,1)-1
  distfile=filenames(i+1,:);
  frad(i)=max(mean(readdist7(distfile,'power')));
  pow=readdist7(distfile,'power');
  fax(i)=mean(pow(6,:));
  ppf(i)=max(max(readdist7(distfile,'power')));
  distfile=filenames(i,:);
  efph(i)=min(readdist7(distfile,'efph'));
end
figure;
subplot(3,1,1)
plot(efph,frad)
xlabel('EFPH')
title('F-rad')
%axis([0 8000 1.4 1.8])
grid
subplot(3,1,2)
plot(efph,fax)
xlabel('EFPH')
title('Fax (nod 6)')
%axis([0 8000 0.9 1.4])
grid
subplot(3,1,3)
plot(efph,ppf)
xlabel('EFPH')
title('PPF')
%axis([0 8000 1.8 2.8])
grid
