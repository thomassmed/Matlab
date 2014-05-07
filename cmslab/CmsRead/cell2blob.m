function blob=cell2blob(cel)
% cell2blob - Convert a cell to a string read with fread
%
% blob=cell2blob(cel)
%
% Input:
%  blob - Onedimensional string including newline characters (output from read_simfile)
%  cel  - Cell array, one row per cell
%
% Output:
%  blob - Onedimensional string including newline characters (output from read_simfile)
%
% Example:
%   TXT=ReadAscii('sim-tip.out';
%   blob=cell2blob(TXT);
%   Resfil=get_card(blob,'RES');
%
% See also blob2cell, read_simfile, ReadAscii
blob=cel{1};
for i=2:length(cel),
    blob=[blob 10 cel{i}];
end