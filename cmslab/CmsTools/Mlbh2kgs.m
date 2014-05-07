function kgs=Mlbh2kgs(Mlbh)
% Convert Mlb/h to kg/s
%
% kgs=Mlbh2kgs(Mlbh)
%
% Input
%   Mlbh - Flow in MLB/H
%
% Output
%   kgs   - Flow in kg/s
% 
%
%
% See also C2F, F2C, pas2psi, psi2pas, kg2lb, lb2kg, Btu2kJkg, kJkg2Btu
[dum,lbkg]=lb2kg(1);
kgs=Mlbh*(lbkg*1e6/3600);