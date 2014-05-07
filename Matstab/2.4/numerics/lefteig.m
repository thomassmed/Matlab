function lefteig(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm, ...
                 Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj,l,u);


% lefteig(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm, ...
%                 Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj,l,u);
%
% or lefteig(A,B,AIm);
%
% This is the system used:
%
% | lambda*Bt'*vt |     | At'  Ajt' ANT' Aqt' Aft'|  | vt |   (T/H and fuel)
% | lambda*Bj'*vj |     | Atj' Aj'   0    0   Afj'|  | vj |   (Flow flux]
% |     0         |  =  |  0   0    AN'  Aqn'  0  |  | vn |   (Neutron flux.)
% |     0         |  =  | Atq' 0     0   -I   Afq'|  | vq |   (Fission Power)
% | lambda*Bf'*vf |     | Atf' Ajf'  0    0   Af' |  | vf |   (Power in fuel)
%
% Philipp Haenggi

global msopt vec stab
maxiter=msopt.LeftEigGlobalMaxiter;
tol_lefteig=msopt.LeftEigGlobalTol;


lam=stab.lam;
e=stab.e;

en=e(vec.n);
eq=e(vec.q);
et=e(vec.t);
ef=e(vec.f);
ej=e(vec.j);

if nargin<22
  [l,u]=luinc(An,1e-3);
  if nargin==3
    A=At;B=Atj;AIm=Atq;
    [At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm, ...
     Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj]=A2part(A,B,AIm);     
  end
end
[laf,uaf]=lu(lam*Bf-Af');

Afjjf=Afj'*(uaf\(laf\Ajf'));
Afttf=Aft'*(uaf\(laf\Atf'));
Aftjf=Aft'*(uaf\(laf\Ajf'));
Afjtf=Afj'*(uaf\(laf\Atf'));
Afqtf=Afq'*(uaf\(laf\Atf'));
Afqjf=Afq'*(uaf\(laf\Ajf'));
[laft,uaft]=lu(lam*Bt-At'-Afttf);

vtj=uaft\(laft\(Ajt'+Aftjf));
Alba=lam*Bj-Aj'-Afjjf-(Afjtf+Atj')*vtj;
Atqf=Atq'+Afqtf;
AVA=Atqf*vtj+Afqjf;
AAA=Alba\(Afjtf+Atj');

vn=en;
vq=eq;

for i=1:5;                              
  vtNT=uaft\(laft\((Ant'+AntIm.'*(1j))*vn));
  Xvn=Atqf*vtNT+AVA*(AAA*vtNT);

  cgsolve_lefteig

  vn=pcgsolve(An',-AnIm.'*(1j)*vn-Aqn'*vq,vn,1e-6,30,0,u',l');

  %norm(An'*vn +AnIm.'*(1j*vn) + Aqn'*vq)/norm(Aqn'*vq)

  sc=norm(vn);
  vn=vn/sc;
  vq=vq/sc;
end

vtNTq=vtq+vtNT;
vj=Alba\((Afjtf+Atj')*vtNTq);
vt=vtj*vj+vtNTq;
vf =uaf\(laf\(Atf'*vt+Ajf'*vj));
vq=Atq'*vt+Afqtf*vt+Afqjf*vj;
vn=pcgsolve(An',-Aqn'*vq-AnIm.'*(1j*vn),vn,1e-3,30,0,u',l');    
rest = Ajt'*vj + Ant'*vn + AntIm.' *(1j*vn)+ Aqt'*vq + Aft'*vf + At'*vt - lam*Bt'*vt;
resj = Atj'*vt + Aj'*vj +Afj'*vf- lam*Bj'*vj;
resn = An'*vn +AnIm.'*(1j*vn) + Aqn'*vq;
resf = Atf'*vt + Af'*vf + Ajf'*vj- lam*Bf'*vf;
resq = Atq'*vt + Afq'*vf - vq;
nrmt = vt'*Bt'*vt;
nrmj = vj'*Bj'*vj;
nrmf = vf'*Bf'*vf;
tol = (rest'*rest + resq'*resq + resj'*resj+resf'*resf+resn'*resn)/(nrmt+nrmj+nrmf);

disp(['Tolerance of the left eigenvector: ' num2str(abs(tol))])

v=zeros(length(e),1);
v(vec.j1)=vt;
v(vec.n)=vn;
v(vec.q)=vq;
v(vec.f)=vf;
v(vec.jj1)=vj;
v=v/(vt.'*Bt*et+vf.'*Bf*ef+vj.'*Bj*ej);
  
stab.v=v;

save('-append',msopt.MstabFile,'stab');
