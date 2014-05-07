function values=cell2num(cell)

i=1;

while i<=length(cell)
	if ~isempty(str2num(cell{i}))
		values{i}=str2num(cell{i});
	else
		values{i}=remblank(cell{i});
	end
	i=i+1;
end
