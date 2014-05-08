%%
matfil='c13-2.mat';
load(matfil,'stab','matr','geom','fue_new','steady');
ibast=matr.ibas_t;
knum=geom.knum;
kmax=fue_new.kmax;
ncc=size(knum,1);
evoid=sym_full(reshape(stab.et(ibast),kmax,ncc),knum);
absevoid=abs(evoid);