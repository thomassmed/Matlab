%unction  [tol,lam1]=resid_eig(At,Atj,Atq,Atf,Bt,Ajt,Aj,Bj,Ant,AntIm,An,AnIm,Aqt,Aqn,Aft,Afq,Af,Bf,et,ej,en,eq,ef,lam);
  rest = At*(et+a*de) + Atj*(ej+a*dej) + Atq*(eq+a*deq) + Atf*(ef+a*def);
  resj = Ajt*(et+a*de) + Aj*(ej+a*dej) + Ajf * (ef+a*def);
  resn = Ant*(et+a*de) + AntIm*((et+a*de)*1j) + An*(en+a*den) + AnIm*((en+a*den)*1j) + Anf * (ef+a*def);
  resq = Aqt*(et+a*de) + Aqn*(en+a*den) + Aqf*(ef+a*def) - eq-a*deq;
  resf = Aft*(et+a*de) + Afq*(eq+a*deq) + Af*(ef+a*def) + Afj *(ej+a*dej);
  nrmt = (et'+a*de')*Bt*(et+a*de);
  nrmj = (ej'+a*dej')*Bj*(ej+a*dej);
  nrmf = (ef'+a*def')*Bf*(ef+a*def);

  rest = rest  - (lam+a*dlam)*Bt*(et+a*de);
  resj = resj  - (lam+a*dlam)*Bj*(ej+a*dej);
  resf = resf - (lam+a*dlam)*Bf*(ef+a*def);
  tol = (rest'*rest+resj'*resj+resq'*resq+resf'*resf+resn'*resn)/(nrmt+nrmj+nrmf);
  tol = sqrt(tol);
%lam1=(et.'*rest+ej.'*resj+en.'*resn+eq.'*resq+ef.'*resf)/(nrmt+nrmj+nrmf);
%@(#)   res_eig.m 1.1   97/08/12     13:55:33
