%function map=asywei2map(weifile,distfile,mapfile)
%
% Creates an ASYWEI-map from input file with weights for each asytyp
% 
%  Input:
% weifile  - Input file with assembly weights for each asytyp
% distfile - Distfile to be used when reading the asytyp map
%
%  Output:
% mapfile -  Output file with the created ASYWEI-map
%
%
function map=asywei2map(weifile,distfile,mapfile)

% Read weights
[weitypes,wei]=textread(weifile,'%s%f');

% Read asytyp
[asytyp,mminj]=readdist7(distfile,'ASYTYP');

% Create asywei vector
asywei=zeros(size(asytyp,1),1);
for i=1:size(asytyp,1)
    ind=strmatch(strtrim(asytyp(i,:)),weitypes);
    
    asywei(i)=wei(ind);
end

% Convert asywei vector to ascii-map
map=ascdist2map(num2str(asywei,'%3.2f'),mminj,6);

% Write to output file
fid=fopen(mapfile,'w');
fprintf(fid,map);
fclose(fid);
