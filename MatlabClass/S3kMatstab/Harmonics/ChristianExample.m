%% Read data
cmsinfo=ReadCore('../../../BigFiles/r1_cy14_09_glbl.cms');
A=ReadCore(cmsinfo,'Scalars'); % Other way to read all scalars
t=ReadCore(cmsinfo,'Elapsed')';
Qt=ReadCore(cmsinfo,cmsinfo.ScalarNames{7})';
Qc=ReadCore(cmsinfo,cmsinfo.ScalarNames{8})';
%% Interpolate to get equally spaced data
ti=0:min(diff(t)):max(t);
Qti=interp1(t,Qt,ti);
Qci=interp1(t,Qc,ti);
%% First try quick and dirty
NeuFilt=tf(1,[3 1])
%% Use NeuFilt
QchatNeuFilt=lsim(NeuFilt,Qti-Qci(1),ti)+Qci(1);
%% Compare
figure
plot(ti,Qci)
hold on
plot(ti,QchatNeuFilt,'r');
legend('S3K','Simple First Order Filter')
%% Include gamma-heating
QchatNeuFilt_gamma=0.96*QchatNeuFilt+0.04*Qti;
plot(ti,QchatNeuFilt,'r');

%% Identify
Qt2Qc=iddata(Qci,Qti,0.05);
Fuel2=pem(Qt2Qc,'P2Z');



