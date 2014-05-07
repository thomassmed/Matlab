function F=C2F(C)
% Convert Celsius (centigrades) to Fahrenheit
%
% F=C2F(C)
%
% Input
%   C - Temperature in degrees Celsius
%
% Output
%   F - Temeperature in Fahrenheit
%
% Example
%    F=C2F(274); %Typical inlet temperature
%
% See also F2C, pas2psi, psi2pas, lb2kg, kg2lb, Btu2kJkg, kJkg2Btu
F=C*9/5+32;