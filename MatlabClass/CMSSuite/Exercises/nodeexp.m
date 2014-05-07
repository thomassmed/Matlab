%%
cmsinfo=read_cms('../sim-dep.cms');
lhg3=read_cms_dist(cmsinfo,'3LHG');
exp3=read_cms_dist(cmsinfo,'3EXP');
flp3=read_cms_dist(cmsinfo,'3FLP');
%%
a=0.8:.01:1;
for i=1:length(a);
    xpo=[00.0  16.0  38.0  59.0  70.0];
    lhg=[417.6 417.6 367.7 265.0 171.4];
    lims=interp1(xpo*a(i),lhg,exp3{9});
    flp3_9=lhg3{9}./lims;
    errf(i)=std(flp3_9(:)-flp3{9}(:));
end
plot(a,errf)