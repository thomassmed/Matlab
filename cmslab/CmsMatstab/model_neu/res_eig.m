function  [tol,rtrt,rjrj,rqrq,rfrf,rnrn]=res_eig(At,Atj,Atq,Atf,Bt,Btj,Ajt,Ajq,Aj,Bj,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Afj,Af,Bf,et,ej,en,eq,ef,lam,etn,Bu)
  if nargin<31, Bu=0;end
  rest = At*et + Atq*eq + Atf*ef + Atj*ej;
  resj = Aj*ej + Ajt*et + Ajq*eq+Bu;
  resn = Ant*etn + 1j*AntIm*etn + An*en+1j*AnIm*en + Anf*ef;
  resq = Aqt*etn + Aqn*en +Aqf*ef - eq;
  resf = Aft*et + Afq*eq + Af*ef + Afj*ej;
  nrmt = et'*Bt*et;
  nrmt=real(nrmt);
  nrmf = ef'*Bf*ef;
  nrmj=ej'*ej;

  rest = rest  - lam*Bt*et -lam*Btj*ej;
  resf = resf - lam*Bf*ef;
  resj = resj - lam*Bj*ej;
  rtrt=rest'*rest;
  rjrj=resj'*resj;
  rqrq=resq'*resq;
  rfrf=resf'*resf;
  rnrn=resn'*resn;
  tol = (rtrt + rjrj + rqrq + rfrf + rnrn)/(nrmt+nrmf+nrmj);
  tol = sqrt(tol);
%lam1=(et.'*rest+ej.'*resj+en.'*resn+eq.'*resq+ef.'*resf)/(nrmt+nrmf);
%@(#)   res_eig.m 1.1   97/08/12     13:55:33
