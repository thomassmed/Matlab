function TXT=ClearNewPage(TXT)
% ClearNewPage - Clears the new page printout
%
%  TXTout = ClearNewPage(TXT)
%
% Input:
%   TXT - A cell array read by ReadAscii
%
% Output:
%   TXTout - A cell array with no page printouts
%
% Example:
%   TXT=ReadAscii('sim-tip.out');
%   TXT=ClearNewPage(TXT);
%
% See also: ReadAscii, findrow
% 
inew=findrow(TXT,'^1 S I M U');
if isempty(inew),
    inew=findrow(TXT,'^1S I M U');
end
for i=length(inew):-1:1,
    TXT(inew(i):inew(i)+2)=[];
end