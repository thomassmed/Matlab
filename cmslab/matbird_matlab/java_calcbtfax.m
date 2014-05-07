function [btfax] = java_calcbtfax()

global cs;

pwr = 0;
for k = 1:cs.cnmax
    if (strcmp('pwr', cs.s(k).type))
        pwr = 1;
    end
end

if (pwr == 0)
    cs.calc_btfax;
    btfax = cs.btfax;
else
    cs.btfax = ones(cs.s(1).npst,cs.s(1).npst,cs.Nburnup);
    btfax = cs.btfax;
end

end