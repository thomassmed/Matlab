%ds=ReadMatdataFil('Varmaprov_2013-04-04_09_000.dat');
function [GA,GP]=AnalysFil(filename,tlow,thigh,f)
%%
ds=ReadMatdataFil(filename);
t=ds.data(:,1);
Pbv=ds.data(:,99);
P=ds.data(:,2);
APRM=ds.data(:,21);
figure
plot(t,Pbv)
Ms=ds.data(:,11)+ds.data(:,12);
bafr=ds.data(:,102);
hc=ds.data(:,4);
%%
if nargin<2, tlow=20;end
if nargin<3, thigh=1000;end
%%
isel=t>tlow&t<thigh;
%%
FPbv=fft(detrend(Pbv(isel),0));
lFP=min(length(FPbv),1000);
[~,imax]=max(abs(FPbv(1:lFP)));
FAPRM=fft(detrend(APRM(isel),0));
FP=fft(detrend(P(isel),0));
Fhc=fft(detrend(hc,0));
FMs=fft(detrend(Ms,0));
Fbafr=fft(detrend(bafr,0));


GA=FAPRM(imax)/FP(imax);
GP=FP(imax)/FPbv(imax);
if nargin>3,
    [PP,ff]=spectrum(Pbv,P,512,[],[],50);
    GP(2)=interp1(ff,PP(:,4),f);
end
