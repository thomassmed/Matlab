function java_read_caxfile(cn,caxfile)

global cs;

cs.s(cn).readcaifile(caxfile);
cs.s(cn).readcaxfile(caxfile);
cs.s(cn).init;
cs.s(cn).gettype;
cs.s(cn).bigcalc;
cs.s(cn).calcbtf;
cs.s(cn).calc_u235;


end





