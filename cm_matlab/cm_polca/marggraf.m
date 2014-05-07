%@(#)   marggraf.m 1.5	 06/12/18     14:59:44
%
%function marggraf
function marggraf
figure;
load sim/simfile;
sf=size(filenames);sb=size(bocfile);
if sf(2)>sb(2),bocfile=[bocfile setstr(32*ones(1,sf(2)-sb(2)))];end
if sb(2)>sf(2),filenames=[filenames setstr(32*ones(sf(1),sb(2)-sf(2)))];end
filenames=[bocfile;filenames];
for i=1:size(filenames,1)-1
  distfile=filenames(i+1,:);
  fl_cpr(i)=max(max(readdist7(distfile,'fl_cpr1')));
  fl_lhgr(i)=max(max(readdist7(distfile,'fl_lhgr1')));
  distfile=filenames(i,:);
%  efph(i)=min(readdist7(distfile,'efph'));
end
efph=blist(1:end-1);
subplot(2,1,1)
plot(efph,fl_cpr)
hold on
plot(efph,.97*ones(1,length(efph)),'--')
text(3000,1,'Designgräns')
ylabel('Frac of lim')
xlabel('EFPH')
title('FL-CPR')
axis([blist(1) blist(end) 0.7 1.1])
grid
subplot(2,1,2)
plot(efph,fl_lhgr)
hold on
plot(efph,0.943*ones(1,length(efph)),'--')
text(3000,.97,'Designgräns')
ylabel('Frac of lim')
xlabel('EFPH')
title('FL-LHGR')
axis([blist(1) blist(end) 0.7 1.1])
grid
