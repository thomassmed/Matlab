%% Exercise CMSSuite
%% Get metadata from sim-dep.sum
suminfo=ReadCore('../../../BigFiles/sim-dep.sum');
%% Read in FLC 2D MAP from sim-dep.sum
FLC=ReadCore(suminfo,'FLC 2D MAP');
%% 1) Convert FLC in state point 7 to a map
flcmap=vec2cor(FLC{7},suminfo.core.mminj)
%% 2a) Find flcmax
flmax=nan(length(FLC),1);
for i=1:length(FLC),
    flmax(i)=max(FLC{i});
end
figure
plot(flmax)
%% 2b)
figure
plot(suminfo.Xpo,flmax)
%% As a preparation for task 3-5, read in 'FUE.LAB' to a cell array fuelab:
fuelab=ReadCore(suminfo,'FUE.LAB');
%% 3) Plot flcmax as a function of exposure for fuel of type 28A7
i28a7=strcmp('28A7',fuelab);
flmax28a7=nan(length(FLC),1);
for i=1:length(FLC),
    flmax28a7(i)=max(FLC{i}(i28a7));
end
figure
plot(suminfo.Xpo,flmax28a7);
%% 4) Plot flcmax as a function of exposure for fuel of type 28A8
i28a8=strcmp('28A8',fuelab);
flmax28a8=nan(length(FLC),1);
for i=1:length(FLC),
    flmax28a8(i)=max(FLC{i}(i28a8));
end
figure
plot(suminfo.Xpo,flmax28a8);
%% 5) Plot flcmax as a function of exposure for fuel of either type 28A7 or 28A8 by
%% a) Combining the result of 4 and 5
flmax28a=max(flmax28a8,flmax28a7);
figure
plot(suminfo.Xpo,flmax28a);
%% b) By using '28A' as pattern in strncmp
i28a=strncmp('28A',fuelab,3);
flmax28a2=nan(length(FLC),1);
for i=1:length(FLC),
    flmax28a2(i)=max(FLC{i}(i28a));
end
figure
plot(suminfo.Xpo,flmax28a2);
%% 6 Annotate the plots
%% b) Programmatically
xlabel('Exposure (EFPH)');
ylabel('Fraction of limit for CPR');
title('Fraction of limit for CPR for bundle type 28A7 and 28A8')
grid
%% 7) find the number of bundles above 0.85 in each state point and plot with the bar-command
ngt0pt85=nan(length(FLC),1);
for i=1:length(FLC),
    ngt0pt85(i)=sum(FLC{i}>0.85);
end
figure
bar(suminfo.Xpo,ngt0pt85)
%% 8) Make a 'flugskitsplot' of all flcs vs individual bundle exp at all dep steps
EXP2=ReadCore(suminfo,'EXP 2D MAP');
figure
hold all
% hold on
grid
xlabel('Bundle Exposure (MWd/kgU)');
ylabel('Fraction of limit CPR')
title('All bundles for the entire cycle');
for i=1:length(FLC),
    plot(EXP2{i},FLC{i},'x')
    figure(gcf)
%     pause
end
%% Prepare for exercises 9 and 10:
cmsinfo=ReadCore('../../../BigFiles/sim-dep.cms');
lhg3=ReadCore(cmsinfo,'3LHG');
exp3=ReadCore(cmsinfo,'3EXP');
%% 9) Plot each node
figure
hold all
for i=1:length(lhg3),
    plot(exp3{i}(:),lhg3{i}(:),'x');
%     pause
end
%% 10) Calculate the fraction to limit in state pt 9 if the limits are given by: 
xpo=[00.0  16.0  38.0  59.0  70.0];
lhg=[417.6 417.6 367.7 265.0 171.4];
figure
plot(xpo,lhg)
lims=interp1(xpo,lhg,exp3{9});
flp3_9=lhg3{9}./lims;
cmsplot ../../../BigFiles/sim-dep.cms flp3_9
set_cmsplot_prop operator max
set_cmsplot_prop rescale auto
cmsplot_now
%% Compare with the 'reference'
flp3=read_cms_dist(cmsinfo,'3FLP');
cmsplot ../../../BigFiles/sim-dep.cms flp3{9}
set_cmsplot_prop operator max
set_cmsplot_prop rescale auto
cmsplot_now
%% 11) Find all the segments on the restart file 
resinfo=ReadRes('../../../BigFiles/dist-boc.res');
Lib = ReadRes(resinfo,'Library');
Segs=cellstr(Lib.Segment);
unique(Segs)
%% 12) Find all segments in the present core
Segs(unique(Lib.Core_Seg{1}))
%% Preparation for exercise 13-15
mminj=resinfo.core.mminj;  % Note that this info could be picked up from
kan=resinfo.core.kan;      % suminfo or cmsinfo as well
%% 13) Create a core map of channel numbers
coremap=vec2cor(1:kan,mminj)
%% 14) Find the channel numbers for all bundles in the SE quarter of the core
[ia,ja]=mminj2ij(mminj);
SE=ia>13&ja>13;
iaSE=ia(SE);jaSE=ja(SE);
knumSE=cpos2knum(iaSE,jaSE,mminj);
%% 15) Try ij2mminj on iaSE and jaSE
[mminj,sym,knum]=ij2mminj(iaSE,jaSE);
sym
size(knum)
%% Expand a quarter core dist to a full dist
qc=1:125; % Create a dummy quarter core distribution
FullCore=sym_full(qc,knum);
vec2cor(FullCore,mminj)





