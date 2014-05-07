function f=ReadOneRacsFloat(fid)

b=[256 128 64 32 16 8 4 2 1];
bm=zeros(1,22);
bm(1:13)=[.5 .25 .125 .0625 0.03125 0.015625 0.0078125 0.00390625 .001953125 9.765625e-4 4.8828125e-4 2.44140625e-4 1.220703125e-4];
bm(14:22)=[1/16384 3.0517578125e-5 1/65536 1/131072 1/262144 1/524288 1/1048576 2^-21 2^-22];
s=fread(fid,1,'ubit1','ieee-be');
p=fread(fid,9,'ubit1','ieee-be');
m=fread(fid,22,'ubit1','ieee-be');

if all(p==0)&&all(m==0), f=0; return;end

xp=b*p-257;
sgn=(-1)^s;
mant=bm*m;
f=sgn*2^xp*(1+mant);