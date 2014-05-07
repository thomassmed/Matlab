% function [line]=stripline(inpline)
%
% Removes comments from sourceline
%
function [line]=stripline(inpline)
	line=inpline(8:size(inpline,2));
	pos=find(line=='*')-1;
	if isempty(pos)
		pos=find(line=='!')-1;
	end
	if isempty(pos)
		pos=size(line,2);
	end
	line=line(1:pos);
	line=deblank(line);
	line=fliplr(deblank(fliplr(line)));
