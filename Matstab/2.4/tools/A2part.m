function [At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj]=A2part(A,B,AIm)
% Input:
%   A      - A-Matrix, Default: A-matrix is created from ramfile
%   B      - B-Matrix
%   AIm    - Imaginary part of A-Matrix
%   AntIm  - Imaginary part of Ant-Matrix
%
% Partition A, B and AIm  into its components
%
%
% | lambda*Bt*et |     | At  Atj  0   Atq  Atf |   | et |   (T/H and fuel) 
% | lambda*Bj*ej |     | Ajt Aj   0   0    Ajf |   | ej |   (Impulse momentum)
% |     0        |  =  | ANT 0    AN  0    ANF |   | en |   (Neutron flux.)
% |     0        |     | Aqt 0    Aqn -I   Aqf   |   | eq |   (Fission Power)
% | lambda*Bf*ef |     | Aft Afj  0   Afq  Af  |   | ef |   (Power in fuel)
%
%   ANT = Ant + j * AntIm    AN = An + j * AnIm   ANF = Anf + j * AnfIm

global geom termo vec

kmax=geom.kmax;
kan=geom.kan;
ncc=geom.ncc;
nvt=geom.nvt;
r=geom.r;
k=geom.k;
nhyd = termo.nhyd;

jj=1:nhyd';

ll=4*length(get_ch(1))+1;

jt=zeros(1,(ncc+1)*ll);

Istart=get_thsize*nvt+1;

for i=1:ncc+1,
  jtemp=[(get_ch(i)-1)*nvt+1];
  jjtemp=[jtemp+1;jtemp+2;jtemp+7;jtemp+12];jjtemp=jjtemp(:)';
  jt((i-1)*ll+1:i*ll)=[jjtemp Istart+i];
end 


%P jm
At=A(jt,jt);
j1 = jt(find(any(At')));
j2 = jt(find(any(At)));
At = subset(A,j1,j2); 
Bt = subset(B,j1,j2);
if ~(j1==j2),error('Error in A-matrix'),end

%Find other nodes
jj(j1)=[];
jj1=jj(find(any(A(jj,[j1,jj])')));
jj2=jj(find(any(A([jj,j2],jj))));

Aj=subset(A,jj1,jj2);
Bj=subset(B,jj1,jj2);

Ajt = A(jj1,j2);
Atj = A(j1,jj2);

jq  = [(k+5)'];
Aq  = A(jq,jq); 
Aqt = A(jq,j2);
Atq = A(j1,jq);
Ajq = A(jj1,jq);
Aqj = A(jq,jj2);

%Fuel
jf = [(k+6)',(k+7)',(k+8)',(k+9)',(k+10)',(k+11)']';
jf=jf(:);
jf  = jf(find(any(A(jf,jf)')));
Af  = A(jf,jf);
Aft = A(jf,j2);
Atf = A(j1,jf);
Afj = A(jf,jj2);
Ajf = A(jj1,jf);
Bf = subset(B,jf,jf);
Afq = A(jf,jq);

%Neutronics
jn=k';
An=A(jn,jn);

AnIm=subset(AIm,jn,jn);
AntIm=subset(AIm,jn,j2);

Ant=A(jn,j2);
Aqn=A(jq,jn);
Aqf=A(jq,jf)+1j*subset(AIm,jq,jf);
Anf=A(jn,jf)+1j*subset(AIm,jn,jf);

vec.n=jn;
vec.t=j2;
vec.j=jj2;
vec.q=jq;
vec.f=jf;
vec.j1=j1;
vec.jj1=jj1;
