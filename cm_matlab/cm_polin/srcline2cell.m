function [values]=srcline2cell(s,card)

s=s';

lines=[];
values=cell(1,size(s,1));


for i=1:size(s)
	newline=s(i).(card);
	for n=1:size(newline)
		values{i}=[values{:,i}; strread(remblank(newline(n,:)),'%s','delimiter',',')'];
	end
end
