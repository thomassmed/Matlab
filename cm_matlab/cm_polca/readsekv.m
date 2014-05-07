function [keff,sekvgrp,sekvstep]=readsekv(sekvfile)

a=textread(sekvfile,'%s','delimiter','\n');

keffstart=strmatch('KEFF',a);
sekvstart=strmatch('SEKVENS',a);
endind=strmatch('END',a);

keff=cellfun(@str2num,a(keffstart+1:sekvstart-1));

sekvgrp=str2num(a{sekvstart+1});

sekvstep=cellfun(@str2num,a(sekvstart+2:endind-1),'UniformOutput',false);