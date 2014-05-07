%% Prepare for exercise 1
cmsinfo=ReadCore('../../../BigFiles/sim-dep.cms');
lhg3=ReadCore(cmsinfo,'3LHG');
exp3=ReadCore(cmsinfo,'3EXP');
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
flp3=ReadCore(cmsinfo,'3FLP');
cmsplot ../../../BigFiles/sim-dep.cms flp3{9}
set_cmsplot_prop operator max
set_cmsplot_prop rescale auto
cmsplot_now
%% 
cmsplot ../../../BigFiles/sim-dep.cms abs(flp3{9}-flp3_9)
compare2(flp3_9,flp3{9})
%% Try with approximation of peak pin burnup
lims2=interp1(0.9*xpo,lhg,exp3{9});
flp3_92=lhg3{9}./lims2;
cmsplot ../../../BigFiles/sim-dep.cms abs(flp3{9}-flp3_92)
compare2(flp3_9,flp3{9},flp3_92)
%% Try with the other set of margins
lhg2=[427.5 427.5 323.0 237.5  95.0];
lims2=interp1(xpo,lhg2,exp3{9});
flp3_92=lhg3{9}./lims2;
cmsplot ../../../BigFiles/sim-dep.cms abs(flp3{9}-flp3_92)
compare2(flp3_9,flp3{9},flp3_92)