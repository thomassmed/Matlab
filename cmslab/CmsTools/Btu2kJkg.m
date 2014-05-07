function [kJ,Btulb_kJkg]=Btu2kJkg(Btulb)
% Convert Btu kJ/Kg
%
% [kJ,Btulb_kJkg]=Btu2kJkg(Btulb)
%
% Input
%   Btu   - Enthalpy in Btu
%
% Output
%   lb - mass in pounds
%   kglb - conversion factor
% 
%
%
% See also C2F, F2C, pas2psi, psi2pas, kg2lb, Btu2kJkg, kJkg2Btu
lbkg=0.45359237;
Btulb_kJkg=1.05505585/lbkg;
kJ=Btulb_kJkg*Btulb;