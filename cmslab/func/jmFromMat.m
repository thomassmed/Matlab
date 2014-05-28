function jm=jmFromMat(matfil)
load(matfil)
A=fue_new.afuel;
A=A(:,geom.knum(:,1));
jm=eq_jm(steady.Wl,steady.Wg,steady.P,steady.tl,A);

