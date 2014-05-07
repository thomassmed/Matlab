function dfl=dp_outlier(dY2)
%%
dfl=dY2;
[xx,ii]=max(abs(dY2));
dtest=abs(dY2);
dtest(ii)=[];
if xx/max(dtest)>10, dfl(ii)=dfl(ii)*min(10*max(dtest)/xx,10);end 