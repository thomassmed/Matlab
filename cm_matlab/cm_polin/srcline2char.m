function [lines]=srcline2char(s,card)

lines=[];
values=[];

s=s';

for i=1:size(s)
		lines=strvcat(lines,s(i).(card));
end
