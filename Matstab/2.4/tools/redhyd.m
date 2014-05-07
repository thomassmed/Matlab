function A=redhyd(A0,B,AIm)

% A=redhyd(A0,B,AIm);
%
%Solves the major part (no neighbour dependencies) of the 
%algebraic equations in the thermo hydraulics.
%A is the input to this script


%@(#)   redhyd.m 1.11   97/08/15     13:42:52

global geom msopt


ncc=geom.ncc;								% ncc = antal kanaler = 338 st

r = ind_tnr(0,get_varsize);						% r = 1,14,27,... 13 ekvationer per nod, 8843 noder

%Differential equations							% hydsize = storlek på TH-matrisen = antal noder * antal ekvationer
									% + antal kanaler + 4 = 8843*13 + 338 + 4 = 115301
k = (get_hydsize - 2 - ncc):(get_hydsize-1);				% k = 114961:115300  => 340 element
r1 = [1,r+1,r+2,k];							% r1 = 1,   2,15,..,114948,   3,16,..,114949,  114961:115300
									% ekvation 1 och 2
									% DIFFEKVATIONER!!! (alfa, E)

[rr,k]=get_neutnodes;							% position för neutroniknoder i TH-vektor (storlek 8450)
%Algebraic equations
%k1=[k+11];
r2 = [r+7,r+12,k+5,k+11];						% ekvation 7 och 12, (tl och jm)
r3 = [r+3,r+4,r+5,r+6,r+8,r+9,r+10,r+11,r+13,get_hydsize];		% ekvation 3, 4, 5, 6, 8, 9, 10, 11 och 13 (3 och 13 tomma)

%Build sub-matrices
a11 = A0(r1,r1);a12=A0(r1,r2);a13=A0(r1,r3);				% ekvation 1 och 2, DIFFEKVATIONER
a21 = A0(r2,r1);a22=A0(r2,r2);a23=A0(r2,r3);				% ekvation 7 och 12, (tl och jm)
a31 = A0(r3,r1);a32=A0(r3,r2);a33=A0(r3,r3);				% ekvation 3, 4, 5, 6, 8, 9, 10, 11 och 13 (3 och 13 tomma)
%b31 = A0(r3,k1);


%Equations to be solved
i11=find(any([a11 a12 a13]'));						% hittar position för vilka ekvationer som existerar
i22=find(any(a22'));							% behöver ej kolla alla då algebraiska ekvationer!!!
i33=find(any(a33'));							% behöver ej kolla alla då algebraiska ekvationer!!!
									% bör plocka bort ekvation 3 och 13...

a33=subset(a33,i33,i33);						% plockar bort nollrader!!!
a31=subset(a31,i33,i11);
a32=subset(a32,i33,i22);
a13=subset(a13,i11,i33);
a23=subset(a23,i22,i33);
a11=subset(a11,i11,i11);
a12=subset(a12,i11,i22);
a21=subset(a21,i22,i11);
a22=subset(a22,i22,i22);

%----------------------------------------------------------------------------
%
%	[a11	a12	a13		[x1		[d/dt...	
%	 a21	a22	a23	*	 x2	=	 0		<=>
%	 a31	a32	a33]		 x3]		 0]	
%
%	a11*x1 + a12*x2 + a13*x3 = d/dt...
%	a21*x1 + a22*x2 + a23*x3 = 0
%	a31*x1 + a32*x2 + a33*x3 = 0		<=>	x3 = -a33\a31*x1 - a33\a32*x2
%
%	Insättning =>
%
%	a11*x1 + a12*x2 - a13*(a33\a31)*x1 - a13*(a33\a32)*x2 = d/dt...
%	a21*x1 + a22*x2 - a23*(a33\a31)*x1 - a23*(a33\a32)*x2 = 0	<=>
%
%	(a11 - a13*(a33\a31))*x1 + (a12 - a13*(a33\a32))*x2 = d/dt...
%	(a21 - a23*(a33\a31))*x1 + (a22 - a23*(a33\a32))*x2 = 0
%
%	Reducerad matris:
%
%	[a11 - a13*(a33\a31)		a12 - a13*(a33\a32)
%	 a21 - a23*(a33\a31)		a22 - a23*(a33\a32)]	
%
%-----------------------------------------------------------------------------
s1 = a33\a31;
s2 = a33\a32;
%s3 = a33'\a13';							% ANVÄNDS ALDRIG!!! -> ONÖDIG BERÄKNING tas bort 051221, eml
%s4 = a33'\a23';							% ANVÄNDS ALDRIG!!! -> ONÖDIG BERÄKNING tas bort 051221, eml
a11 = a11 - a13*s1;							% reducerar bort ekvation 3,4,5,6,8,9,10,11 och 13
a12 = a12 - a13*s2;
a21 = a21 - a23*s1;
a22 = a22 - a23*s2;

a = [a11,a12;a21,a22];							% har kvar diffekv (alfa E) och (tl, jm)
j1=find(~any(a'));							% plockar bort eventuella nollrader
j2=find(~any(a));							% plockar bort eventuella nollkolumner
a(j1,:)=[];
a(:,j2)=[];

tr = [r1(i11),r2(i22)];tr(j1)=[];					% rader
tk = [r1(i11),r2(i22)];tk(j2)=[];					% kolumner

[iA,jA,xA] = find(a);							% hitta nollskilda element i den reducerade matrisen
iA = tr(iA)';								% sätt korrekta positioner
jA = tk(jA)';								% sätt korrekta positioner
ibort=find(iA>get_hydsize);						
iA(ibort)=[];
jA(ibort)=[];
xA(ibort)=[];

i1 = 1:get_hydsize;l1 = length(i1);
i2 = (get_hydsize+1):length(A0);

[r,k,x] = find(A0(i2,i1));
iA = [iA;r+l1];jA = [jA;k];xA = [xA;x];					% Lägg till ekvationer från andra delar än TH
[r,k,x] = find(A0(i2,i2));
iA = [iA;r+l1];jA = [jA;k+l1];xA = [xA;x];

A=sparse(iA,jA,xA);							% OBS!!! Minskar inte på storleken på matrisen 
									% reducerade ekvationer blir nollrader!!!

if strcmp(msopt.SaveOption,'large')
  save('-append',msopt.MstabFile,'A');
end

