function TEXT=ReadAscii(filename,offset,Nrow)
% ReadAscii - Reads any ascii file and put each row in a cell
%
% TEXT=ReadAscii(filename)
%
% Input
%   filename - name on ascii file to be read
%
% Output 
%   TEXT - Cell array of ascii file, one cell for each row
%
% Example
%   TXT=ReadAscii('sim-tip.inp');
%   ipage=findrow(TXT,'^1 S I M U'); % Finds rows beginning with: 1 S I M U
%   irows=findrow(TXT,'^''CRD.POS'''); % Finds rows begininning with 'CRD.POS'
%
%  See also ReadOut, ReadSum, ReadTip, ReadPriMac, ReadOut2D, ReadOut3D, findrow
if nargin<2, offset=0;end
fid=fopen(filename,'r');
fseek(fid,offset,-1);
if nargin<3,
    TEXT = textscan(fid,'%s','delimiter','\n');
else
    TEXT = textscan(fid,'%s',Nrow,'delimiter','\n');
end
TEXT = TEXT{1};
fclose(fid);