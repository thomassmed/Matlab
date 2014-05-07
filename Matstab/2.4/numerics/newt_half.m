function   [An,Ant,AnIm,AntIm,l,u]= ...
  newt_half(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj);

% [An,Ant,AnIm,AntIm,l,u]= ...
%  newt_half(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj);
%
%
%Build the system:
%
% This is the system used:
% 
% | lambda*Bt*et |     | At   Atj 0    Atq Atf|   | et |   (T/H In-core)
% | lambda*Bj*ej |     | Ajt  Aj  0     0  0  |   | ej |   (T/H Ex-core]
% |     0        |  =  | Ant  0   An    0  0  |   | en |   (Neutron flux.)
% |     0        |     | Aqt  0   Aqn  -I  0  |   | eq |   (Fission Power)
% | lambda*Bf*ef |     | Aft  Afj 0    Afq Af |   | ef |   (Power in fuel)
%
%    Ant = Ant + j * AntIm    An = An + j * AnIm
%
% Here, ej,Ajx,Axj,Bj are all assumed to be zero.
% An is modified to account for anti-symmetry.

% For higher harmonics (>1), the neutronic vector is adjusted so that the
% search will be in orthogonal directions of the earlier modes: 
%   en=en-en1*(en1.'*en)/(en1.'*en1);
% This procedure is not entirely theoretically motivated. Therefore, the
% results for higher order harmonics should interpreted with care.

global msopt geom termo neu steady vec stab

nr=msopt.Harmonics;
maxiter=msopt.HarmonicHalfMaxiter;
tolnewt=msopt.HarmonicHalfTol;
distfile=msopt.DistFile;
neumodel=neu.NeuModel;

ntot=geom.ntot;
knum=geom.knum;
hz=geom.hz;
hx=geom.hx;
neig=neu.neig;
kmax=geom.kmax;
kan=geom.kan;
r=geom.r;

Ppower=steady.Ppower;
Pvoid=steady.Pvoid;
fa1=steady.fa1;
fa2=steady.fa2;
keff=steady.keff;

en=stab.e(vec.n);
et=stab.e(vec.t);
ef=stab.e(vec.f);
eq=stab.e(vec.q);

lam=stab.lam;
lam0=lam-0.1-0.2j;       % Starting guess for harmonics
lam=lam0;

jn=vec.n;
j2=vec.t;
jf=vec.f;
jq=vec.q;

if msopt.CoreSym==1
  regio=0;
elseif msopt.CoreSym==2
  regio=1;
else
  error('Symmetry not supported')
end

en0=en;
qtherm=termo.Qtot/get_sym;
nA=termo.nhyd+geom.ntot*geom.nvn;

if strcmp(upper(neumodel),'POLCA4'),
  [d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
  xsec2mstab(distfile,Ppower,Pvoid,knum);
  [a11,a21,a22,cp]=read_alb;
elseif strcmp(upper(neumodel),'POLCA7'),
  [d1,d2,sigr,siga1,siga2,usig1,usig2,ny]=...
  xsec2mstab7(msopt.DistFile,steady.Pdens,steady.Tfm,geom.knum);
  [a11,a21,a22,cp]=read_alb7;
end
  
[X1nm,Y1nm,X2nm,Y2nm]=eq_xy(neig,hx,hz,d1,d2,usig1,usig2,siga1,...
sigr,siga2,a11,a21,a22,fa1,fa2,cp);
A1nm=eq_A1nm(neig,X1nm,Y1nm,X2nm,Y2nm,usig2,usig1,siga1,sigr,siga2,keff,0,0,1,regio);
dA1nm=spdiags(A1nm,0);Anm=A1nm-spdiags(dA1nm,0,ntot,ntot);

options.disp=0;
options.tol=1e-4;
[F,D,FLAG] = eigs(-Anm,nr,'LR',options); 
% It HAS to be -Anm!!! +Anm is another problem (not 'LR')
Keff=diag(D);
fprintf(1,'\n Harmonic Keff \n');
for i=1:nr,
  fprintf(1,'%7i   ',i);
end
fprintf(1,'\n');
for i=1:nr,
  fprintf(1,'%10.5f',Keff(i));
end
fprintf(1,'\n');

[iA,jA,xA]=A_neu(lam,regio);

AA=sparse([iA;nA],[jA;nA],[real(xA);1]);
AA = scale_A(AA);
An=subset(AA,jn,jn);
Ant=subset(AA,jn,j2);
Anf=subset(AA,jn,jf);
Aqf=subset(AA,jq,jf);
AAIm=sparse([iA;nA],[jA;nA],[imag(xA);1]);
AAIm = scale_A(AAIm);
AnIm=subset(AAIm,jn,jn);
AntIm=subset(AAIm,jn,j2);
clear AA AAIm iA jA xA
[l,u]=luinc(An,1e-3);

[l1,u1] = lu(stab.lam*Bt-At);

eh=zeros(nA,nr);   
for i0=1:nr,
  lam=lam0;
  if i0>1, lam=lamh(i0-1)-0.05-0.1j; end
  fprintf(1,'\n');
  fprintf(1,'Eigenvalue calculation for Harmonics no. %i: \n',i0);
  if i0==2, 
    fprintf(1,'For harmonics >1, the en-vector is kept orthogonal to \n');
    fprintf(1,'the lower harmonics for the first two iterations.\n');
  end
  en=en0.*F(:,i0);
  e0=en; 
  e0tmp = reshape(F(:,i0).*abs(stab.e(r)),kmax,kan);
  [enmax,enmaxi]=max(mean(abs(e0tmp)));clear e0tmp;
  node=(enmaxi-1)*kmax+8;
  efix=find(j2==r(node));
  while isempty(efix),   % To ensure that node is not voidfree
    node=node+1;
    efix=find(j2==r(node));
  end
  %fprintf(1,'\n enmaxi= %5i efix= %5i node = %5i \n',enmaxi,efix,node);
  let=length(j2);
  ett=zeros(1,let);
  ett(efix)=1;
  As=[Bt*lam-At Bt*et;ett 0];
  den=0*en;def=0*ef;
  deq=0*eq;dlam=0;
  de=0*et;
  eq=Aqn*en+Aqf*ef;
  ef = (lam*Bf-Af)\(Afq*eq);
  for ii0=1:2,
    et=u1\(l1\(Atf*ef+Atq*eq));
    for i3=1:2,
      hl=Ant*et+AntIm*(et*1j)+AnIm*(en*1j)+Anf*ef;
      en = pcgsolve(An,-hl,en,0.001,30,0,l,u);
      for i4=1:i0-1,
        en1=eh(vec.n,i4);
        en=en-en1*(en1.'*en)/(en1.'*en1);
      end
    end
    for i3=1:3,
      eq=Aqn*en+Aqt*et+Aqf*ef;
      ef = (lam*Bf-Af)\(Aft*et+Afq*eq);
      a=0;res_eig_half; %disp(tol);
      %fprintf(1,' %g %g %g %g \n',rest'*rest,resn'*resn,resq'*resq,resf'*resf);
    end
  end
  [l2,u2] = lu([lam*Bt-At Bt*et;ett 0]);
  ibryt=0;
  fprintf(1,'\n');
  fprintf(1,'  It.#     dr      freq.       tol  \n') 
  fprintf(1,'-------+--------+---------+------------- \n');
  [dk,fd]=p2drfd(lam);
  fprintf(1,'  %i    %8.4f  %8.4f  %g \n',0,dk,fd,tol);
  for n0=1:maxiter,
    for n1=1:3,
      [dr0,fd0]=p2drfd(lam);
      rhs1=-Bt*et*lam+At*et+Atf*ef+Atq*eq;
      de=u2\(l2\([rhs1;0]));dlam=de(let+1);de(let+1)=[];
      et=et+de;
      lam=lam+dlam;
     
      for i3=1:2,
        hl=Ant*et+AntIm*(et*1j)+AnIm*(en*1j)+Anf*ef;
        en = pcgsolve(An,-hl,en,0.0001,30,0,l,u);
        if n0<3,                          %This portion is not fully tested
	  for i4=1:i0-1,
            en1=eh(vec.n,i4);
            en=en-en1*(en1.'*en)/(en1.'*en1);
          end
	end                                    %This portion is not fully tested
      end
      for i3=1:3,
        eq=Aqn*en+Aqt*et+Aqf*ef;
        ef = (lam*Bf-Af)\(Aft*et+Afq*eq);
      end
      [dk,fd]=p2drfd(lam);
      a=0;res_eig_half;
      %fprintf(1,' %g %g %g %g \n',rest'*rest,resn'*resn,resq'*resq,resf'*resf);
      if abs(tol)<tolnewt&(abs(dk-dr0))<0.01, ibryt=1;break;end
      if n1<3, fprintf(1,'       %8.4f  %8.4f  %g \n',dk,fd,tol); end
    end
    a=0;res_eig_half;fprintf(1,'  %i    %8.4f  %8.4f  %g \n',n0,dk,fd,tol);
    if ibryt==1|n0==maxiter, break;end
    [l1,u1] = lu(lam*Bt-At);
    [l2,u2] = lu([lam*Bt-At Bt*et;ett 0]);
    [iA,jA,xA]=A_neu(lam,regio);

    AA=sparse([iA;nA],[jA;nA],[real(xA);1]);
    AA = scale_A(AA);
    An=subset(AA,jn,jn);
    Ant=subset(AA,jn,j2);
    Anf=subset(AA,jn,jf);
    Aqf=subset(AA,jq,jf);
    AAIm=sparse([iA;nA],[jA;nA],[imag(xA);1]);
    AAIm = scale_A(AAIm);
    AnIm=subset(AAIm,jn,jn);
    AntIm=subset(AAIm,jn,j2);
    clear AA AAIm iA jA xA
  end
  enorm=et(efix);  
  lamh(i0)=lam;
  eh(vec.t,i0)=et;
  eh(vec.n,i0)=en;
  eh(vec.q,i0)=eq;
  eh(vec.f,i0)=ef;
  eh(:,i0)=eh(:,i0)/enorm;
end
Keff=Keff*keff;

stab.eh=eh;
stab.lamh=lamh;

save('-append',msopt.MstabFile,'stab','vec');
