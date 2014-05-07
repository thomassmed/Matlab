function p=eq_pacc(Wl,Wg,wl,wg,A)
%p=eq_pacc
%
%p=eq_pacc(Wl,Wg,wl,wg,A)
%Beräknar accelerationstryckfallen för
%den slutna kretsen genom kanalerna. 

%@(#)   eq_pacc.m 2.2   02/02/27     12:05:33

global geom
kmax=geom.kmax;
ncc=geom.ncc;


i1 = 1:kmax:kmax*ncc;   % Inlopps-index
i2=kmax:kmax:kmax*ncc;  % Utlopps-index

p = zeros(size(Wl));
p(i1) = -(Wl(i1).*wl(i1)+Wg(i1).*wg(i1))./A(i1);
p(i2) = (Wl(i2).*wl(i2)+Wg(i2).*wg(i2))./A(i2);
