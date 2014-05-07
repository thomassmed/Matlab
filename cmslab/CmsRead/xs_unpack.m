function       [d1,d2,sigr,siga1,siga2,usig1,usig2,ny,d1d,d2d,sigrd,siga1d,siga2d,usig1d,usig2d,...
    d1t,d2t,sigrt,siga1t,siga2t,usig1t,usig2t]=xs_unpack(xs,xsd,xst,kmax,ncc)
% xs_unpack - Unpacks result from xs_pin_lib
%
% [d1,d2,sigr,siga1,siga2,usig1,usig2,ny,d1d,d2d,sigrd,siga1d,siga2d,usig1d,usig2d,...
%    d1t,d2t,sigrt,siga1t,siga2t,usig1t,usig2t]=xs_unpack(xs,xsd,xst,kmax,ncc)
%
% Input:
%   xs,xsd,xst - output from xs_pin_lib, XS and derivatives wrt density and temp
%   kmax       - number of nodes axially
%   ncc        - number of channels
%
%  Output: XS and their derivatives from pin library
%
%  Example:
%   dens=reads3_out('s3.out','3DEN');
%   Tfm=reads3_out('s3.out','3TFU');
%   fue_new=read_restart_bin('s3.res');kmax=fue_new.kmax;ncc=fue_new.kan;
%   [xs,xsd,xst,XS,xsdd]=xs_pin_lib('xs.lib',fue_new,dens,Tfm);
%   [d1,d2,sigr,siga1,siga2,usig1,usig2,ny,d1d,d2d,sigrd,siga1d,siga2d,usig1d,usig2d,...
%    d1t,d2t,sigrt,siga1t,siga2t,usig1t,usig2t]=xs_unpack(xs,xsd,xst,kmax,ncc);
%
% See also: xs_cms, read_restart_bin, reads3_out

% Written Thomas Smed 2009-05-05
    d1=xs(:,1);
   d2=xs(:,2);
   sigr=xs(:,3);
   siga1=xs(:,4);   
   siga2=xs(:,5);
   usig1=xs(:,6);
   usig2=xs(:,7);
   ny=3.2041e-11./xs(:,8);
   d1d=xsd(:,1);
   d2d=xsd(:,2);
   sigrd=xsd(:,3);
   siga1d=xsd(:,4);   
   siga2d=xsd(:,5);
   usig1d=xsd(:,6);
   usig2d=xsd(:,7);   
   d1t=xst(:,1);
   d2t=xst(:,2);
   sigrt=xst(:,3);
   siga1t=xst(:,4);   
   siga2t=xst(:,5);
   usig1t=xst(:,6);
   usig2t=xst(:,7);   
    ny=reshape(ny,kmax,ncc);
    d1=reshape(d1,kmax,ncc);
    d1d=reshape(d1d,kmax,ncc);
    d1t=reshape(d1t,kmax,ncc);
    d2=reshape(d2,kmax,ncc);
    d2d=reshape(d2d,kmax,ncc);
    d2t=reshape(d2t,kmax,ncc);
    sigr=reshape(sigr,kmax,ncc);
    sigrd=reshape(sigrd,kmax,ncc);
    sigrt=reshape(sigrt,kmax,ncc);
    siga1=reshape(siga1,kmax,ncc);
    siga1d=reshape(siga1d,kmax,ncc);
    siga1t=reshape(siga1t,kmax,ncc);
    siga2=reshape(siga2,kmax,ncc);
    siga2d=reshape(siga2d,kmax,ncc);
    siga2t=reshape(siga2t,kmax,ncc);
    usig1=reshape(usig1,kmax,ncc);
    usig1d=reshape(usig1d,kmax,ncc);
    usig1t=reshape(usig1t,kmax,ncc);
    usig2=reshape(usig2,kmax,ncc);
    usig2d=reshape(usig2d,kmax,ncc);
    usig2t=reshape(usig2t,kmax,ncc); 