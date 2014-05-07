function   [An,Ant,AnIm,AntIm,l,u]= ...
  newt_half(At,Atq,Atf,Aqt,Aqn,Aft,Afq,Af,Bt,Bf,fue_new,Xsec,matr)

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


%%
global msopt geom termo neu steady stab

nr=msopt.Harmonics;
maxiter=msopt.HarmonicHalfMaxiter;
tolnewt=msopt.HarmonicHalfTol;
neumodel=msopt.NeuModel;
Midpoint=get_bool(msopt.Midpoint);

ntot=geom.ntot;
knum=geom.knum;
hz=geom.hz;
hx=geom.hx;
neig=neu.neig;
kmax=geom.kmax;
kan=geom.kan;

Ppower=steady.Ppower;
Pvoid=steady.Pvoid;
fa1=steady.fa1;
fa2=steady.fa2;
keff=steady.keff;
%%
if ischar(msopt.Harmonics), msopt.Harmonics=str2num(msopt.Harmonics);end
nr=msopt.Harmonics; % For testing!!

en=stab.en;
et=stab.et;
ef=stab.ef;
eq=stab.eq;

lam=stab.lam;
lam0=lam-0.05-0.2j;       % Starting guess for harmonics
lam=lam0;

if msopt.CoreSym==1
  regio=0;
elseif msopt.CoreSym==2
  regio=1;
else
  error('Symmetry not supported')
end

en0=en;
qtherm=termo.Qtot/get_sym;
[a11,a21,a22,cp]=read_alb7(fue_new);

[X1nm,Y1nm,X2nm,Y2nm]=eq_xy(neig,hx,hz,Xsec.d1,Xsec.d2,Xsec.usig1,Xsec.usig2,Xsec.siga1,...
Xsec.sigr,Xsec.siga2,a11,a21,a22,fa1,fa2,keff,cp);
A1nm=eq_A1nm(neig,X1nm,Y1nm,X2nm,Y2nm,Xsec.usig2,Xsec.usig1,Xsec.siga1,Xsec.sigr,Xsec.siga2,keff,0,0,1,regio);
dA1nm=spdiags(A1nm,0);Anm=A1nm-spdiags(dA1nm,0,ntot,ntot);

options.disp=0;
options.tol=1e-4;

if msopt.CoreSym==1
    [F,D,FLAG] = eigs(-Anm,nr+3,'LR',options);
    icount=0;imode=2;
    for imode=1:nr+3,
        if abs(mean(aocalc(reshape(F(:,imode),kmax,kan))))<1,
            icount=icount+1;
            ih(icount)=imode;
        end
        if icount==nr+1, break;end
    end
    kk=diag(D);
    kk=kk(ih);
    [x,i]=sort(kk,1,'descend');
    ih=ih(i);
    ih(1)=[]; %Remove the global mode
else
    [F,D,FLAG] = eigs(-Anm,nr,'LR',options); 
    ih=1:nr;
    kk=diag(D);
    kk=kk(ih);
    [x,i]=sort(kk,1,'descend');
    ih=ih(i);
end
% It HAS to be -Anm!!! +Anm is another problem (not 'LR')
Keff=diag(D);
fprintf(1,'\n Harmonic Keff \n');
for i=1:nr,
  fprintf(1,'%7i   ',i);
end
fprintf(1,'\n');
for i=1:nr,
  fprintf(1,'%10.5f',Keff(ih(i))*keff);
end
fprintf(1,'\n');

%%
[An,Ant,Anf,Aqn,Aqt,Aqf]=A_neu(fue_new,Xsec,matr,lam,regio);
AnIm=imag(An);
An=real(An);
AntIm=imag(Ant);
Ant=real(Ant);

setup.type='nofill';
setup.droptol=0;
setup.milu='off';
setup.udiag=0;
setup.thresh=1;
[l,u]=ilu(An,setup);

[l1,u1] = lu(lam*Bt-At);

nA=length(et)+length(en)+length(eq)+length(ef);
eh=zeros(nA,nr);   
stabh.et=nan(length(stab.et),nr);
stabh.en=nan(length(stab.en),nr);
stabh.eq=nan(length(stab.eq),nr);
stabh.ef=nan(length(stab.ef),nr);
for i0=1:nr,
  lam=lam0;
  if i0>1, 
      lam=lamh(i0-1)-0.05-0.1j;
  end      
  fprintf(1,'\n');
  fprintf(1,'Eigenvalue calculation for Harmonics no. %i: \n',i0);
  if i0==2, 
    %fprintf(1,'For harmonics >1, the en-vector is kept orthogonal to \n');
    %fprintf(1,'the lower harmonics for the first three iterations.\n');
  end
  en=en0.*F(:,ih(i0));
  e0tmp = reshape(F(:,ih(i0)).*abs(stab.et(matr.ibas_t)),kmax,kan);
  [enmax,enmaxi]=max(mean(abs(e0tmp)));clear e0tmp;
  node=(enmaxi-1)*kmax+8;
  efix=matr.ibas_t(node);
  
  %fprintf(1,'\n enmaxi= %5i efix= %5i node = %5i \n',enmaxi,efix,node);
  let=size(At,1);
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
      getMidpoint
      hl=Ant*etn+AntIm*(et*1j)+AnIm*(en*1j)+Anf*ef;
      en = pcgsolve(An,-hl,en,0.001,30,0,l,u);
      for i4=1:i0-1,
        en1=stab.en(:,i4);
        en=en-en1*(en1.'*en)/(en1.'*en1);
      end
    end
    for i3=1:3,
      eq=Aqn*en+Aqt*et+Aqf*ef;
      ef = (lam*Bf-Af)\(Aft*et+Afq*eq);
      a=0;
      tol=res_eig_half(At,Atq,Atf,Bt,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Af,Bf,et,en,eq,ef,lam,a,etn,de,den,def,deq,dlam);
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
  for n0=1:10,
    for n1=1:3,
      [dr0,fd0]=p2drfd(lam);
      rhs1=-Bt*et*lam+At*et+Atf*ef+Atq*eq;
      de=u2\(l2\([rhs1;0]));dlam=de(let+1);de(let+1)=[];
      kv=1;
      if abs(dlam)>0.2, kv=0.2/abs(dlam);end
      et=et+kv*de;
      lam=lam+kv*dlam;
     
      for i3=1:2,
          getMidpoint
          hl=Ant*etn+AntIm*(et*1j)+AnIm*(en*1j)+Anf*ef;
          en = pcgsolve(An,-hl,en,0.0001,30,0,l,u);
          if n0<10,                          %This portion is not fully tested
              if msopt.CoreSym==1,
                  en=en-en0*(en0.'*en)/(en0.'*en0);
              end
              for i4=1:i0-1,
                  en1=stabh.en(:,i4);
                  en=en-en1*(en1.'*en)/(en1.'*en1);
              end
          end                                    %This portion is not fully tested
      end
      for i3=1:3,
          eq=Aqn*en+Aqt*et+Aqf*ef;
          ef = (lam*Bf-Af)\(Aft*et+Afq*eq);
      end
      [dk,fd]=p2drfd(lam);
      tol=res_eig_half(At,Atq,Atf,Bt,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Af,Bf,et,en,eq,ef,lam,a,etn,de,den,def,deq,dlam);
      %fprintf(1,' %g %g %g %g \n',rest'*rest,resn'*resn,resq'*resq,resf'*resf);
      if abs(tol)<tolnewt*10&&(abs(dk-dr0))<0.005, ibryt=1;break;end
      if n1<3, fprintf(1,'       %8.4f  %8.4f  %g \n',dk,fd,tol); end
    end
    a=0;
    tol=res_eig_half(At,Atq,Atf,Bt,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Af,Bf,et,en,eq,ef,lam,a,etn,de,den,def,deq,dlam);
    fprintf(1,'  %2i   %8.4f  %8.4f  %g \n',n0,dk,fd,tol);
    if ibryt==1||n0==maxiter, break;end
    [An,Ant,Anf,Aqn,Aqt,Aqf]=A_neu(fue_new,Xsec,matr,lam,regio);
    AnIm=imag(An);
    An=real(An);
    AntIm=imag(Ant);
    Ant=real(Ant);
    [l1,u1] = lu(lam*Bt-At);
    [l2,u2] = lu([lam*Bt-At Bt*et;ett 0]);
  end
  enorm=et(efix);  
  lamh(i0)=lam;
  stabh.et(:,i0)=et/enorm;
  stabh.en(:,i0)=en/enorm;
  stabh.eq(:,i0)=eq/enorm;
  stabh.ef(:,i0)=ef/enorm;
end
Keff=Keff*keff;

stab.lamh=lamh;
stabh.lamh=lamh;
stabh.Keff=Keff;

save('-append',msopt.MstabFile,'stabh','F','D','stab');
    function getMidpoint
        etn=et;
        if Midpoint, %Midpoint
            ev=et(matr.ibas_t);
            ev=reshape(ev,geom.kmax,geom.ncc);
            ev=bound2mid(ev);
            etn(matr.ibas_t)=ev(:);
        end
    end
end
