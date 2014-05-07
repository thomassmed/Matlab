%% Read data
cmsinfo=read_cms('../../BigFiles/r1_cy14_09_glbl.cms');
t0=read_cms_scalar(cmsinfo,1);
Qc0=read_cms_scalar(cmsinfo,cmsinfo.ScalarNames{8});
Qt0=read_cms_scalar(cmsinfo,cmsinfo.ScalarNames{7});
%% 
t=5.3:0.05:14.75;t=t';
Qt0=interp1(t0,Qt0,t);
Qc0=interp1(t0,Qc0,t);
Qt=detrend(Qt0,0);
Qc=detrend(Qc0,0);
%% Read Pressure in Upper Plenum
[dr,fd]=read_drfd_s3kout('../../BigFiles/r1_cy14_09_glbl.out');
lam=drfd2p(dr,fd);
mult=exp(lam'*t(:)');
QT=mult*Qt;
QC=mult*Qc;
%%
QT0=QT;
tilt=exp(-1j*angle(QT0));
QT=QT/QT0;
QC=QC/QT0;
%%
% gamma=0.05;
% T=3;
% simf
%% Find the right amount of gamma and modify
p=fminsearch(@fitQcQt,[0;3]);
gamma=p(1);
T=p(2);
simf
