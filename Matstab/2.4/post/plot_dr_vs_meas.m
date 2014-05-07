%function plot_dr_vs_meas(verfile)
%
% Plots difference between measured vs calculated decay ratio and frequency
% for all cases in the validation results-file (.mat)
%
% Input: verfile - Output-file(.mat) from verify_matstab.m
%
%
function plot_dr_vs_meas(verfile)
load(verfile)
figure
plot(drmeas,'b');
hold on
plot(drmeas,'b^');
plot(drmstab,'r');
plot(drmstab,'rs');
l=size(f_polca_list,1);
set(gca,'xtick',1:l);
set(gca,'tickdir','out');
axis([0 l+1 0.1 1]);
set(gca,'xticklabel',[]);
for i=1:l, 
  t(i)=text(i,0.11,remblank(f_polca_list(i,4:end)));
  set(t(i),'interpreter','none','rotation',90);
end

p(1)=plot([0 l+1],[.8 .8],'--k');
p(2)=plot([0 l+1],[.7 .7],'--k');
p(3)=plot([0 l+1],[.6 .6],'--k');
p(4)=plot([0 l+1],[.5 .5],'--k');
plot([l-7,l-5],[0.95 0.95],'b');
plot([l-7,l-5],[0.95 0.95],'b^');
text(l-4.5,0.95,'Measured');
plot([l-7,l-5],[0.90 0.90],'r');
plot([l-7,l-5],[0.90 0.90],'rs');
text(l-4.5,0.90,'MATSTAB 2 - P7');
title(['Validation ',upper(staton)]);
ylabel('Decay Ratio');
figure
plot(fdms,'b');
hold on
plot(fdms,'b^');
plot(fdmstab,'r');
plot(fdmstab,'rs');
set(gca,'xtick',1:l);
set(gca,'tickdir','out');
axis([0 l+1 0.3 .7]);
set(gca,'xticklabel',[]);
for i=1:l, 
  t(i)=text(i,0.31,remblank(f_polca_list(i,4:end)));
  set(t(i),'interpreter','none','rotation',90);
end

p(2)=plot([0 l+1],[.55 .55],'--k');
p(3)=plot([0 l+1],[.5 .5],'--k');
p(4)=plot([0 l+1],[.45 .45],'--k');
plot([l-20,l-18],[0.65 0.65],'b');
plot([l-20,l-18],[0.65 0.65],'b^');
text(l-17.5,0.65,'Measured');
plot([l-20,l-18],[0.60 0.60],'r');
plot([l-20,l-18],[0.60 0.60],'rs');
text(l-17.5,0.60,'MATSTAB 2 - P7');
title(['Validation ',upper(staton)]);
ylabel('Frequency (Hz)');
 
