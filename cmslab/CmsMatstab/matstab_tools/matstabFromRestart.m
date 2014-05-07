function [dr,fd]=matstabFromRestart(resfil,varargin)
% matstabFromRestart - Calculates decay ratio for all cases in a RestartFile
%
% [dr,fd]=matstabFromRestart(resfil,matstabOptions)
%
% Input:
%   resfil - Name on restart file
%   matstabOption - Property/value pairs legal for matstab
%
% Output
%   dr   - decay ratio
%   fd   - frequency
%
% If no value is given for Qrel and Wtot, the following default values will
% be used:
%  Qrel - 70%
%  Wtot - 0.4*Wnom (Oper.Wnom from restartfile)
%
% Examples:
%  matstabFromRestart dist-sim.res Qrel 65 Wtot 4000
%  [dr,fd]=matstabFromRestart('dist-sim.res','Qrel',65,'Wtot',4000);
%  matstabFromRestart dist-sim.res
%
%  See also: matstab
 

[limits,Xpo,Titles]=read_restart_bin(resfil,-1);
[fue_new,Oper]=read_restart_bin(resfil,limits(1),limits(2));
matfil=strrep(resfil,'.res','.mat');
wtot=0.4*Oper.Wnom;
for i=1:length(Xpo),
    matstab(resfil,'Qrel',70,'Wtot',wtot,'xpo',Xpo(i),varargin{:});
    load(matfil,'stab');
    [dr(i),fd(i)]=p2drfd(stab.lam);
end