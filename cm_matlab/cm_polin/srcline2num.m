function [values]=srcline2num(s,card)

lines=[];
values=[];

s=s';

for i=1:size(s)
	if isempty(s(i).(card)) | ~sum(~(isspace(s(i).(card))))
		lines=strvcat(lines,0);
	end
	lines=strvcat(lines,s(i).(card));
end

for i=1:size(lines)
	newline=strread(lines(i,:),'%f','delimiter',',');
	if isempty(newline)
		newline=[zeros(1,20-size(newline,2))]';
	end
	newline=[newline' zeros(1,20-size(newline',2))];
	values=[values; newline];
end
