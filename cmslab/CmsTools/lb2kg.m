function [kg,lbkg]=lb2kg(lb)
% Convert pound to kg
%
% [kg,lbkg]=lb2kg(lb)
%
% Input
%   lb - mass in pounds
%
% Output
%   kg   - mass in kg
%   lbkg - conversion factor
% 
%
% See also C2F, F2C, pas2psi, psi2pas, kg2lb, Btu2kJkg, kJkg2Btu
lbkg=0.45359237;
kg=lbkg*lb;