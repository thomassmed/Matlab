function irow=findrow(TEXT,str_regexp)
% findrow - finds a certain row in a ascii file read into a cell array
% 
% irow=findrow(TEXT,str_regexp)
% irow=findrow(filename,str_regexp) works also, but is slower for repeated reading
%
% Input:
%   TEXT - cell array with
%  or filename - name on ascii file
%   str_regexp - regexp string
%
% Output:
%   irow - vector of integers with row numbers with a
% 
% Example
%  TXT=ReadAscii('sim-tip.inp');
%  irow=findrow(TXT,'^
%  irow=findrow(TXT,'^''RES'); % Finds rows beginng with 'RES
%  irow=findrow(TXT,'LPRM'); % Finds rows containing the string LPRM
%
% See also ReadAscii, ReadOut, ReadSum
if ischar(TEXT), TEXT=ReadAscii(TEXT);end
irow=find(~cellfun(@isempty,regexp(TEXT,str_regexp)));
