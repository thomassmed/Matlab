function psi=pas2psi(p)
% Convert pascal psi
%
% Input
%   pas - Pressure in Pascal (=N/m^2=kg/(s^2*m))
%
% Output
%   psi - Pressure in psi (lb/sq inch)
%
% Example
%    psi=pas2psi(7e6); % Gives 1015.26 psi
%
% See also C2F, F2C, pas2psi, lb2kg, kg2lb, Btu2kJkg, kJkg2Btu
psi=p/6894.75729;