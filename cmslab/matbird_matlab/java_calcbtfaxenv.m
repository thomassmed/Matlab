function [btfax_env,imax,jmax] = java_calcbtfaxenv()

global cs;

pwr = 0;
for k = 1:cs.cnmax
    if (strcmp('pwr', cs.s(k).type))
        pwr = 1;
    end
end

if (pwr == 0)
    [imax,jmax] = cs.calc_btfax_env;
    btfax_env = cs.btfax_env;
else
    cs.btfax_env = ones(cs.s(1).npst);
    cs.maxbtfax_env = 1;
    btfax_env = cs.btfax_env;
    imax=1;
    jmax=1;
end


end