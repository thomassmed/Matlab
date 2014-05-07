function grep(filename,str)
if nargin==1,
    str=filename;
    temp=dir('*.m');
    filename={temp(:).name};
else
    temp=dir(filename);
    filename={temp(:).name}';
end

for j=1:length(filename)
    fil=ReadAscii(filename{j});
    ifil=findrow(fil,str);
    if ~isempty(ifil)
        fprintf(1,'%s\n',filename{j});
        for i=1:length(ifil),
            fprintf(1,'%i: %s\n',ifil(i),fil{ifil(i)});
        end
    end
end