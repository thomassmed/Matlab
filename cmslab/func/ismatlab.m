function yon = ismatlab
% ismatlab - True if program used is matlab
%
%   yon = ismatlab
%  
% Output
%   yon - 1 if matlab
%   yon - 0 if not matlab (tested with octave)
%
% Example:
%   if ismatlab
%       variable = 1;
%   else
%       variable = 13;
%   end
%
% Created 2011-09-19 Mikael Andersson

vers = version;
if regexp(vers,'R2') ~= 0
    if ~isempty(matlabpath)
        yon = 1;
    end
else
    yon = 0;
end
end