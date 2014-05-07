function [fue_new,Oper]=sim5_read_restart(resfil,xpo)
%%
resinfo=ReadRes(resfil);
Oper=ReadRes(resinfo,'Oper',xpo);
%%
dat = ReadRes(resinfo,{'THERMAL HYD','LIBRARY','CONTROL ROD','BURNUP','VHIST','TFUHIST','CRDHIST','XENON','SAMARIUM'},xpo);
%%
fue_new = catstruct(dat.resinfo.core,dat.thermalhyd,dat.library,dat.controlrod);
fue_new.burnup = dat.burnup;
fue_new.vhist = dat.vhist;
fue_new.tfuhist = dat.tfuhist;
fue_new.crdhist = dat.crdhist;
fue_new.xenon = dat.xenon;
fue_new.samarium = dat.samarium;
%%
asslab=ReadRes(resinfo,'ASSEMBLY LABELS');
fue_new.lab=char(32*ones(length(asslab.lab),length(asslab.lab{1})));
for i=1:length(asslab.lab),
    fue_new.lab(i,:)=asslab.lab{i}';
end

psipas=6894.75729;                                  % 1 psi 6894.75729 Pa
lbh_kgs=126e-6;                                     % 1 lb/h = 126e-6 kg/s
fue_new.casup=fue_new.casup*lbh_kgs/sqrt(psipas);   % Convert from lb_m/(h*psi^0.5) to kg/(s pa^.5) = kg^0.5*m^0.5
fue_new.cbsup=fue_new.cbsup*lbh_kgs/psipas;         % Convert from lb_m/(h*psi) to kg/(s pa) = ms
fue_new.ccsup=fue_new.ccsup*lbh_kgs/psipas^2;       % Convert from lb_m/(h*psi^2) to kg/(s pa^2)= m^2s^3/kg