function [d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
xsec2mstab(f_polca,Ppower,Pvoid,knum);
% function [d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
% xsec2mstab(f_polca,Ppower,Pvoid,f_master,knum);
%

[d1,d2,sigr,siga1,siga2,usig1,usig2,ny,dd1dv,dd2dv,dsigr1dv,dsiga1dv,...
dsiga2dv,dusig1dv,dusig2dv,dnydv]=xsec2mlab(f_polca,Ppower,Pvoid,f_master);

  d1=d1(:,knum(:,1));d1=d1(:);
  d2=d2(:,knum(:,1));d2=d2(:);
  ny=ny(:,knum(:,1));ny=ny(:);
  siga1=siga1(:,knum(:,1));siga1=siga1(:);
  siga2=siga2(:,knum(:,1));siga2=siga2(:);
  usig1=usig1(:,knum(:,1));usig1=usig1(:);
  usig2=usig2(:,knum(:,1));usig2=usig2(:);
  sigr=sigr(:,knum(:,1));sigr=sigr(:);
%@(#)   xsec2mstab.m 1.1   98/03/06     13:18:42
