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

maxiter=5;

eq=Aqn*en;
ef = (lam*Bf-Af)\(Afq*eq);

[l1,u1] = lu(lam*Bt-At);

den=0*en;def=0*ef;
deq=0*eq;dlam=0;

et=u1\(l1\(Atf*ef+Atq*eq));
[l,u]=luinc(An,1e-3);
eq=Aqn*en;
ef = (lam*Bf-Af)\(Afq*eq);
for ii0=1:2,
  et=u1\(l1\(Atf*ef+Atq*eq));
  for i3=1:2,
    en = pcgsolve(An,-(Ant*et+AntIm*(et*1j)+AnIm*(en*1j)),en,0.001,30,0,l,u);
  end
  eq=Aqn*en+Aqt*et;
  ef = (lam*Bf-Af)\(Aft*et+Afq*eq);
  de=0*et;
  a=0;res_eig11; %disp(tol);
  %fprintf(1,' %g %g %g %g %g \n',rest'*rest,resj'*resj,resn'*resn,resq'*resq,resf'*resf);
end



[l2,u2] = lu([lam*Bt-At Bt*et;ett 0]);
ibryt=0;
fprintf(1,'\n');
fprintf(1,'  It.#     dr      freq.       tol  \n') 
fprintf(1,'-------+--------+---------+------------- \n');
for n0=1:maxiter,
  lam0=lam;
  [dr0,fd0]=p2drfd(lam0);
  for n1=1:3,
    rhs1=-Bt*et*lam+At*et+Atf*ef+Atq*eq;
    de=u2\(l2\([rhs1;0]));dlam=de(let+1);de(let+1)=[];
    et=et+de;
    lam=lam+dlam;
       
    for i3=1:2,
      en = pcgsolve(An,-(Ant*et+AntIm*(et*1j)+AnIm*(en*1j)),en,0.0001,30,0,l,u);
    end
    eq=Aqn*en+Aqt*et;
    ef = (lam*Bf-Af)\(Aft*et+Afq*eq);[dk,fd]=p2drfd(lam);
    a=0;res_eig11;fprintf(1,'       %8.4f  %8.4f  %g \n',dk,fd,tol);
    if abs(tol)<1e-10&(abs(dk-dr0))<0.01, ibryt=1;break;end
  end
 
  a=0;res_eig11;fprintf(1,'  %i    %8.4f  %8.4f  %g \n',n0,dk,fd,tol);

  if ibryt==1|n0==maxiter, break;end

  [l1,u1] = lu(lam*Bt-At);

  [l2,u2] = lu([lam*Bt-At Bt*et;ett 0]);

  [iA,jA,xA]=A_neu(f_polca,f_master,al,b,Beta,NEIG,ihydr,knum,...
  keff,Ppower,Pvoid,fa1,fa2,lam);
  AA=sparse([iA;nA],[jA;nA],[real(xA);1]);
  AA = scale_A(AA);
  An=subset(AA,jn,jn);
  Ant=subset(AA,jn,j2);
  AAIm=sparse([iA;nA],[jA;nA],[imag(xA);1]);
  AAIm = scale_A(AAIm);
  AnIm=subset(AAIm,jn,jn);
  AntIm=subset(AAIm,jn,j2);
  clear AA AAIm iA jA xA
end
enorm=et(efix); 
e(j2)=et;
e(jn)=en;
e(jq)=eq;
e(jf)=ef;
e=e(:)/enorm;
