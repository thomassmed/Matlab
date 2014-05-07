%function utstr=remtab(instr)
%
% Removes tab-characters from string
%

function utstr=remtab(instr)
utstr=instr;
i=find(abs(utstr)==9);utstr(i)='';
