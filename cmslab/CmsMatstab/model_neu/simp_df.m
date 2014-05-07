function [d1,d1d,sigr,sigrd,sigrt,siga1,siga1d,siga1t,usig1,usig1d,...
    d2,d2d,siga2,siga2d,siga2t,usig2,usig2d,usig2t]=simp_df(...
    d1,d1d,sigr,sigrd,sigrt,siga1,siga1d,siga1t,usig1,usig1d,...
    d2,d2d,siga2,siga2d,siga2t,usig2,usig2d,usig2t,wcr)
%Discontinuity factors
% Epithermal
df1=1+(wcr>0.5)*0.1;
d1=d1./df1;
d1d=d1d./df1;
sigr=sigr./df1;
sigrd=sigrd./df1;
sigrt=sigrt./df1;
siga1=siga1./df1;
siga1d=siga1d./df1;
siga1t=siga1t./df1;
usig1=usig1./df1;
usig1d=usig1d./df1;
% Thermal
df2=1+(wcr>0.5)*0.25;
d2=d2./df2;
d2d=d2d./df2;
siga2=siga2./df2;
siga2d=siga2d./df2;
siga2t=siga2t./df2;
usig2=usig2./df2;
usig2d=usig2d./df2;
usig2t=usig2t./df2;