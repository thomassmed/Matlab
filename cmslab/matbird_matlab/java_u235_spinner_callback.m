function java_u235_spinner_callback(cn,y,u235)

global cs;
cs.s(cn).fue(y,3)=u235;
cs.s(cn).update_enr_ba();
cs.s(cn).calc_u235;
% cs.s(cn).bigcalc;
% cs.s(cn).calcbtf;
end