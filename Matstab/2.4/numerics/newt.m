function [An,Ant,AnIm,AntIm,l,u]=newt(lam,en0,At,Atj,Atq,Atf,Ajt, ...
      Aj,Ajf,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,harmonic);

%  [An,Ant,AnIm,AntIm,l,u]=newt(lam,en0,At,Atj,Atq,Atf,Ajt, ...
%     Aj,Ajf,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,harmonic);



global msopt geom termo vec stab

tolnewt=msopt.GlobalFullTol;
distfile=msopt.DistFile;
% msopt.UpdateAneuNewLam=1;

if ~exist('harmonic','var'), harmonic=0; end

en=en0;
ett=vec.ett;
let=vec.let;
efix=vec.efix;
jn=vec.n;
j2=vec.t;
jf=vec.f;
jq=vec.q;

na=size(An,1);
nA=termo.nhyd+geom.ntot*geom.nvn;


eq=Aqn*en;
ef = (lam*Bf-Af)\(Afq*eq);

[l1,u1] = lu(lam*Bt-At);
Ajttj=Ajt*(u1\(l1\Atj));

ej=zeros(size(Aj,1),1);
dej=ej;
den=0*en;def=0*ef;
deq=0*eq;dlam=0;

et=u1\(l1\(Atf*ef+Atq*eq));
dej=0*ej;
den=0*en;def=0*ef;
deq=0*eq;dlam=0;
de=0*et;
[l,u]=luinc(An,1e-3);
for ii0=1:2,
  for ii=1:3,
    rhs1=-Bt*et*lam+At*et+Atj*ej+Atf*ef+Atq*eq;
    dej=(lam*Bj-Aj-Ajttj)\(-Bj*lam*ej+Ajf*ef+Aj*ej+Ajt*et+Ajt*(u1\(l1\rhs1)));
    ej=ej+dej;
    et=u1\(l1\(Atf*ef+Atq*eq+Atj*ej));
  end
  for i3=1:2,
    hl=Ant*et+AntIm*(et*1j)+AnIm*(en*1j)+Anf*ef;
    en = pcgsolve(An,-hl,en,0.001,30,0,l,u);
  end
  for i3=1:3,
    eq=Aqn*en+Aqt*et+Aqf*ef;
    ef = (lam*Bf-Af)\(Aft*et+Afq*eq+Afj*ej);
  end
  a=0;res_eig; %disp(tol);  
  %fprintf(1,' %g %g %g %g %g \n',rest'*rest,resj'*resj,resn'*resn,resq'*resq,resf'*resf);
end
de=0*et;


[l2,u2] = lu([lam*Bt-At Bt*et;ett 0]);
j_ett=find(ett);

ibryt=0;
fprintf(1,'\n');
fprintf(1,'  It.#     dr      freq.       tol  \n') 
fprintf(1,'-------+--------+---------+------------- \n');
[dk,fd]=p2drfd(lam);
fprintf(1,'  %i    %8.4f  %8.4f  %g \n',0,dk,fd,tol);
maxiter=msopt.GlobalFullMaxiter;
for n0=1:maxiter,
  lam0=lam;
  [dr0,fd0]=p2drfd(lam0);
  for n1=1:3,
    for n2=1:5,
      rhs1=-Bt*et*lam+At*et+Atj*ej+Atf*ef+Atq*eq;
      dej=(lam*Bj-Aj-Ajttj)\(-Bj*lam*ej+Aj*ej+Ajf*(ef+def)+Ajt*et+Ajt*(u1\(l1\rhs1)));
      ej=ej+dej;
      de=u2\(l2\([rhs1+Atj*dej;0]));dlam=de(let+1);de(let+1)=[];
      et=et+de;
      lam=lam+dlam;
    end 
    for i3=1:3,
      hl=Ant*et+AntIm*(et*1j)+AnIm*(en*1j)+Anf*ef;
      en = pcgsolve(An,-hl,en,1e-5,30,0,l,u);
    end
    for i3=1:3,
      eq=Aqn*en+Aqt*et+Aqf*ef;
      ef = (lam*Bf-Af)\(Aft*et+Afq*eq+Afj*ej);
    end
    [dk,fd]=p2drfd(lam);
    a=0;res_eig;
    if abs(tol)<tolnewt&abs(dk-dr0)<0.0005, ibryt=1; break;end		% Orginal: 0.005
    if n1<3, fprintf(1,'       %8.4f  %8.4f  %g \n',dk,fd,tol);end
  end
 
  a=0;res_eig;fprintf(1,'  %i    %8.4f  %8.4f  %g \n',n0,dk,fd,tol);
  if ibryt==1|n0==maxiter, break;end

  [l1,u1] = lu(lam*Bt-At);

  [l2,u2] = lu([lam*Bt-At Bt*et;ett 0]);

  Ajttj=Ajt*(u1\(l1\Atj));

  if strcmpi(msopt.UpdateAneuNewLam,'on'),
    [iA,jA,xA]=A_neu(lam);
    AA=sparse([iA;nA],[jA;nA],[real(xA);1]);
    AA = scale_A(AA);
    An=subset(AA,jn,jn);
    Ant=subset(AA,jn,j2);
    AAIm=sparse([iA;nA],[jA;nA],[imag(xA);1]);
    AAIm = scale_A(AAIm);
    AnIm=subset(AAIm,jn,jn);
    AntIm=subset(AAIm,jn,j2);
    Anf=subset(AA,jn,jf)+1j*subset(AAIm,jn,jf);
    Aqf=subset(AA,jq,jf)+1j*subset(AAIm,jq,jf); 
    clear AA AAIm iA jA xA
  end
end
enorm=et(efix); 
e(vec.t)=et;
e(vec.j)=ej;
e(vec.n)=en;
e(vec.q)=eq;
e(vec.f)=ef;
e=e(:)/enorm;

if harmonic==0,
  vec.enorm=enorm;
  stab.e=e;
  stab.lam=lam;
else
  stab.eh(:,harmonic)=e;
  stab.lamh(harmonic)=lam;
end

save('-append',msopt.MstabFile,'stab','vec');
