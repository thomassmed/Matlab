matstabfile=input('Give name on matfile:','s');
load(matstabfile)
init_msopt(msopt.DistFile);
get_inp;
[ploss,pacc,pelev,pfric,prestr]=eq_pparts(steady.Wl,steady.Wg,steady.wg,...
termo.P,steady.alfa,steady.tl,steady.vhk,geom.Dh,geom.Hz,geom.A,...
termo.dc2corr,termo.twophasekorr);
