function [e0,v0]=expand_ev(A0,e,v)

% [e0,v0]=expand_ev(A0,e,v)
%

% Philipp Haenggi

global geom 

ncc=geom.ncc;

if isempty(ncc)
  disp(' ');
  error('The global variables must be present')
  return;
end

r = ind_tnr(0,get_varsize);

%Differential equations
k = (get_hydsize - 2 - ncc):(get_hydsize-1);
r1 = [1,r+1,r+2,k];

[rr,k]=get_neutnodes;
%Algebraic equations
%k1=[k+11];
r2 = [r+7,r+12,k+5,k+11];
r3 = [r+3,r+4,r+5,r+6,r+8,r+9,r+10,r+11,r+13,get_hydsize];

%Build sub-matrices
a11 = A0(r1,r1);a12=A0(r1,r2);a13=A0(r1,r3);
a21 = A0(r2,r1);a22=A0(r2,r2);a23=A0(r2,r3);
a31 = A0(r3,r1);a32=A0(r3,r2);a33=A0(r3,r3);

i11=find(any([a11 a12 a13]'));
i22=find(any(a22'));
i33=find(any(a33'));

a33=subset(a33,i33,i33);
a31=subset(a31,i33,i11);
a32=subset(a32,i33,i22);
a13=subset(a13,i11,i33);
a23=subset(a23,i22,i33);

s1 = a33\a31;
s2 = a33\a32;
s3 = a33'\a13';
s4 = a33'\a23';

e1=e(r1);
e2=e(r2);
v1=v(r1);
v2=v(r2);

e3(i33)=-s1*e1(i11)-s2*e2(i22);
v3(i33)=-s3*v1(i11)-s4*v2(i22);

e0=e;
e0(r3)=e3;
v0=v;
v0(r3)=v3;

%norm((A0+AIm*1j)*e0-lam*B*e0)/norm(e0)
%norm(v0.'*(A0+AIm*1j)-lam*v0.'*B)/norm(v0)

