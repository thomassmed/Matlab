function C=F2C(F)
% Convert Fahrenheit to Celsius (centigrades)
%
% Input
%   F - Temeperature in Fahrenheit
%
% Output
%   C - Temperature in degrees Celsius
%
% Example
%    C=F2C(522); %Typical inlet temperature
%
% See also F2C, pas2psi, psi2pas, lb2kg, kg2lb, Btu2kJkg, kJkg2Btu

C=(F-32)*5/9;