function cel=blob2cell(blob)
% blob2cell - Convert a string read with fread to a cellstr
%
% cel=blob2cell(blob)
%
% Input:
%  blob - Onedimensional string including newline characters (output from read_simfile)
%
% Output:
%  cel  - Cell array, one row per cell
%
% Example:
%   blob=read_simfile('s3.inp');
%   TXT=blob2cell(blob);
%
% See also cell2blob, read_simfile, ReadAscii


nl=find(blob==10);
cel=cell(length(nl),1);
cel{1}=blob(1:nl(1)-1);
for i=2:length(nl),
    cel{i}=blob(nl(i-1)+1:nl(i)-1);
end
if length(blob)>max(nl),
    cel{i+1}=blob(nl(end)+1:end);
end
    