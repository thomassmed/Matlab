function p=eq_pacc(Wl,Wg,wl,wg,A)
%p=eq_pacc
%
%p=eq_pacc(Wl,Wg,wl,wg,A)
%Beräknar accelerationstryckfallen för
%den slutna kretsen genom kanalerna. 

%@(#)   eq_pacc.m 2.2   02/02/27     12:05:33

global geom
nin=geom.nin;
nout=geom.nout;
ncc=geom.ncc;


i1 = nin;
i1(1:4) = i1(1:4)+1;
i1(5:(5+ncc)) = i1(5:(5+ncc)) + ncc + 1; 
i1(5+ncc+1) = i1(5+ncc+1) + 1;

i2 = nout; %Utlopps-index

p = zeros(get_thsize,1);
p(i1) = -(Wl(i1).*wl(i1)+Wg(i1).*wg(i1))./A(i1);
p(i2) = (Wl(i2).*wl(i2)+Wg(i2).*wg(i2))./A(i2);
