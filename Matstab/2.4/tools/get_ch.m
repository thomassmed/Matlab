function j=get_ch(num)
% j=get_ch(num)
% H�mtar index f�r kanal num. Bypasskanalens
% index f�s genom att ange num=ncc+1. 
% F�rsta indexet �r inloppet till kanalens f�rsta nod

%@(#)   get_ch.m 2.3   02/02/27     12:08:08

global geom

nin=geom.nin;
nout=geom.nout;
ncc=geom.ncc;
kmax=geom.kmax;

j=zeros(kmax+1,length(num));

for i=1:length(num)
  j(:,i)=(nin(4+num(i)):(ncc+1):nout(4+num(i)))';
end
j=j(:)';
