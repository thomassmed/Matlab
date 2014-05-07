function [pos nia] = FindPos(struct,label)
% FindPos finds the position in file and position in the array from struct
% with Label and abs_pos.
% 
%  [pos nia] = FindPos(struct,label)
%
% Input
%   struct  - structure with cell array Label, and cell array or array with
%             absolute positions.
%   label   - the label wanted
%   
% Output
%   pos     - the absolute position of label
%   nia     - the position of the label in struct cell array Label
%
% Example:
%
% [pos,nia] = FindPos(resinfo.data,'PARAMETERS');
%
% See also FindLabels
%

if iscell(label)
    for i=1:length(label)
    [strex(i) nia(i)] = max(strcmp(strtrim(upper(label{i})),strtrim(struct.Label)));
    end
else
    [strex nia] = max(strcmp(strtrim(upper(label)),strtrim(struct.Label)));
end

if strex == 0
     warning('Label not found in structure, values are set to 0');
end
     pos = struct.abs_pos(nia);
end