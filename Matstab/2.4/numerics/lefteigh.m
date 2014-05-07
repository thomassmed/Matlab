function lefteigh(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm, ...
                 Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj,l,u);

%
% This is the system used:
%
% | lam*Bt'*vt |     | At'  ANT' Aqt' Aft'|  | vt |   (T/H and fuel)
% |  0         |  =  |  0   AN'  Aqn'  0  |  | vn |   (Neutron flux.)
% |  0         |  =  | Atq'  0   -I   Afq'|  | vq |   (Fission Power)
% | lam*Bf'*vf |     | Atf'  0    0   Af' |  | vf |   (Power in fuel)
%
% Philipp Haenggi

global msopt vec stab

for ih=1:msopt.Harmonics
  lam=stab.lamh(:,ih);
  e=stab.eh(:,ih);;

  en=e(vec.n);
  eq=e(vec.q);
  et=e(vec.t);
  ef=e(vec.f);
  ej=e(vec.j);

  [laf,uaf]=lu(lam*Bf-Af');
  Afttf=Aft'*(uaf\(laf\Atf'));
  Afqtf=Afq'*(uaf\(laf\Atf'));

  [laft,uaft]=lu(lam*Bt-At'-Afttf);

  Atqf=Atq'+Afqtf;

  vn=en;
  vq=eq;

  for i=1:5                             
    vn=pcgsolve(An',-AnIm.'*(1j)*vn-Aqn'*vq,vn,1e-6,30,0,u',l');
    vq=Atqf*(uaft\(laft\((Ant'+AntIm.'*(1j))*vn+Aqt'*vq)));
    sc=norm(vn);
    vn=vn/sc;
    vq=vq/sc;
  end

  vt=uaft\(laft\((Ant'+AntIm.'*(1j))*vn+Aqt'*vq));
  vf=uaf\(laf\(Atf'*vt));
  vq=Atqf*vt;
  vn=pcgsolve(An',-Aqn'*vq-AnIm.'*(1j*vn),vn,1e-3,30,0,u',l');    
  rest = Ant'*vn + AntIm.' *(1j*vn)+ Aqt'*vq + Aft'*vf + At'*vt - lam*Bt'*vt;
  resn = An'*vn +AnIm.'*(1j*vn) + Aqn'*vq;
  resf = Atf'*vt + Af'*vf - lam*Bf'*vf;
  resq = Atq'*vt + Afq'*vf - vq;
  nrmt = vt'*Bt'*vt;
  nrmf = vf'*Bf'*vf;
  tol = (rest'*rest + resq'*resq +resf'*resf+resn'*resn)/(nrmt+nrmf);

  disp(['Tolerance of the left eigenvector: ' num2str(abs(tol))])

  v=zeros(length(e),1);
  v(vec.j1)=vt;
  v(vec.n)=vn;
  v(vec.q)=vq;
  v(vec.f)=vf;
  v=v/(vt.'*Bt*et+vf.'*Bf*ef);
  
  stab.vh(:,ih)=v;

end

save('-append',msopt.MstabFile,'stab');
