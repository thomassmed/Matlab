function java_calc_tmol_limit(ba_tmol, plr_tmol, corner_tmol, aut_ba, ba_limit, plr_limit, corner_limit)

global cs;


for k=1:cs.cnmax
    cs.s(k).ba_tmol = ba_tmol(k);
    cs.s(k).plr_tmol = plr_tmol(k);
    cs.s(k).corner_tmol = corner_tmol(k);
    cs.s(k).aut_ba = aut_ba(k);
end

for m=1:cs.cnmax
%     cs.s(m).calc_powl(1+ba_value/100, 1+plr_value/100, 1+corner_value/100, cs.s(m).ba_tmol, cs.s(m).plr_tmol, cs.s(m).corner_tmol);
    cs.s(m).calc_powl(ba_limit(m), plr_limit(m), corner_limit(m), cs.s(m).ba_tmol, cs.s(m).plr_tmol, cs.s(m).corner_tmol);
end

cs.calc_powp();



end
