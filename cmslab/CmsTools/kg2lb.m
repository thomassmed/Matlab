function [lb,kglb]=kg2lb(kg)
% Convert kg to pounds
%
% [lb,kglb]=kg2lb(kg)
%
% Input
%   kg   - mass in kg
%
% Output
%   lb - mass in pounds
%   kglb - conversion factor
% 
%
%
% See also C2F, F2C, pas2psi, psi2pas, kg2lb, Btu2kJkg, kJkg2Btu
kglb=1/0.45359237;
lb=kglb*kg;