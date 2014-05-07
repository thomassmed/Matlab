function thexp=expandsteady(steady,fue_new,geom)

A=fue_new.afuel(:,geom.knum(:,1));
thexp.jm=eq_jm(steady.Wl,steady.Wg,steady.P,steady.tl,A);
thexp.s=eq_slip(steady.alfa,steady.P,'bmalnes');
thexp.vl=eq_vl(thexp.s,thexp.jm,steady.alfa);
thexp.vg=eq_vg(thexp.s,thexp.jm,steady.alfa);

thexp.Jm=sym_full(thexp.jm,geom.knum);
thexp.S=sym_full(thexp.s,geom.knum);
thexp.Vl=sym_full(thexp.vl,geom.knum);
thexp.Vg=sym_full(thexp.vg,geom.knum);






