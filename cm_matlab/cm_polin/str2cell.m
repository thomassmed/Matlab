function cmatrix=str2cell(str)

[cmatrix{1},rest]=strtok(str,',');

i=2

while ~isempty(rest)
	[cmatrix{i},rest]=strtok(rest,',');
	i=i+1;
end
