function utstr=remtab(instr)
% utstr=remtab(instr)
utstr=instr;
i=find(abs(utstr)==9);utstr(i)='';
