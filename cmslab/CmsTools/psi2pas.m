function [p,psipas]=psi2pas(psi)
% Convert pascal psi
%
% [p,psipas]=psi2pas(psi)
%
% Input
%   psi - Pressure in psi (lb/sq inch)
%
% Output
%   pas - Pressure in Pascal (=N/m^2=kg/(s^2*m))
% ps
%
% Example
%    p=psi2pas(1015.264); % Gives 70 Bar = 7e6 Pascal
%    [p,psipas]=psi2pas(1015.264); % Gives 70 Bar = 7e6 Pascal and the
%                                  % conversion factor
%
% See also C2F, F2C, pas2psi, lb2kg, kg2lb, Btu2kJkg, kJkg2Btu
psipas=6894.75729;
p=psipas*psi;