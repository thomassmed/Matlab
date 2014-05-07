function tol=res_eig_half(At,Atq,Atf,Bt,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afq,Af,Bf,et,en,eq,ef,lam,a,etn,de,den,def,deq,dlam)
  rest = At*(et+a*de) + Atq*(eq+a*deq) + Atf*(ef+a*def);
  resn = Ant*(etn+a*de) + AntIm*((et+a*de)*1j) + An*(en+a*den)+AnIm*((en+a*den)*1j) + Anf*(ef+a*def);
  resq = Aqt*(et+a*de) + Aqn*(en+a*den) +Aqf*(ef+a*def) - eq-a*deq;
  resf = Aft*(et+a*de) + Afq*(eq+a*deq) + Af*(ef+a*def);
  nrmt = (et'+a*de')*Bt*(et+a*de);
  nrmf = (ef'+a*def')*Bf*(ef+a*def);

  rest = rest  - (lam+a*dlam)*Bt*(et+a*de);
  resf = resf - (lam+a*dlam)*Bf*(ef+a*def);
  tol = (rest'*rest+resq'*resq+resf'*resf+resn'*resn)/(nrmt+nrmf);
  tol = sqrt(tol);
%lam1=(et.'*rest+ej.'*resj+en.'*resn+eq.'*resq+ef.'*resf)/(nrmt+nrmf);
%@(#)   res_eig.m 1.1   97/08/12     13:55:33
