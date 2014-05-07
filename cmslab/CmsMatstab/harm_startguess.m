function [Keff,F]=harm_startguess(nr,Xsec,fue_new)

global steady msopt geom neu


NodalCode=msopt.NodalCode;

if strcmpi(NodalCode,'POLCA4'),
  [d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
  xsec2mstab(msopt.DistFile,steady.Ppower,steady.Pvoid,msopt.MasterFile,geom.knum);
  [a11,a21,a22,cp]=read_alb;
elseif strcmpi(NodalCode,'POLCA7'),
  [d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
  xsec2mstab7(msopt.DistFile,msopt.MasterFile,steady.Pdens,steady.Tfm,geom.knum);
  [a11,a21,a22,cp]=read_alb7;
elseif strcmpi(NodalCode,'SIM3'),
    ny=Xsec.ny;
    d1=Xsec.d1;
    d2=Xsec.d2;
    sigr=Xsec.sigr;
    siga1=Xsec.siga1;
    siga2=Xsec.siga2;
    usig1=Xsec.usig1;
    usig2=Xsec.usig2;
    [a11,a21,a22,cp]=read_alb7(fue_new);
end

[X1nm,Y1nm,X2nm,Y2nm]=eq_xy(neu.neig,geom.hx,geom.hz,d1,d2,usig1,usig2,siga1,...
sigr,siga2,a11,a21,a22,steady.fa1,steady.fa2,steady.keff,cp);
A1nm=eq_A1nm(neu.neig,X1nm,Y1nm,X2nm,Y2nm,usig2,usig1,siga1,sigr,siga2,steady.keff);
dA1nm=spdiags(A1nm,0);Anm=A1nm-spdiags(dA1nm,0,geom.ntot,geom.ntot);
options.disp=0;
options.tol=5e-4;
[F,D,FLAG] = eigs(-Anm,nr+1,'LR',options); 
Keff=diag(D);
fprintf(1,'\n Harmonic Keff \n');
for i=1:nr,
  fprintf(1,'%7i   ',i);
end
fprintf(1,'\n');
for i=1:nr,
  fprintf(1,'%10.5f',Keff(i+1));
end
fprintf(1,'\n');
 
